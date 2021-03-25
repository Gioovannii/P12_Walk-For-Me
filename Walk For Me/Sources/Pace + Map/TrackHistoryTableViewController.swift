//
//  TrackHistory.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/1/19.
//

import UIKit
import CoreLocation

final class TrackHistoryTableViewController: UITableViewController {
    
    // MARK: - Properties
    private var locationManager: CLLocationManager?
    private var previousLocation: CLLocation?
    private var currentLocation: CLLocation?
    
    private var currentTrack = Track()
    var temporaryLocations = [CLLocation]()
    
    var coreDataManager: CoreDataManager?
    var trackMapped = [Track]()
    
    var selectedRow = 0
    
    // MARK: - Outlets
    @IBOutlet weak var playButton: UIBarButtonItem!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
        coreDataManager = CoreDataManager(coreDataStack: sceneDelegate.coreDataStack)
        guard let coreDataManager = coreDataManager else { return }
        self.coreDataManager = coreDataManager
        
        tableView.tableFooterView = UIView()
        
        locationManager = CLLocationManager()
        requestLocation()
        
        let track: [Track] = coreDataManager.tracks.map { Track(locations: $0.locations!, totalPace: Double($0.totalPace ?? "0")!, timeStamp: $0.timestamp! ) }
        
        self.trackMapped = track
        print(trackMapped , trackMapped.count)
    }
    
    // MARK: - Actions
    @IBAction func newSessionButton(_ sender: UIBarButtonItem) {
 
        //coreDataManager.newSession()
        
        currentTrack = Track(locations: temporaryLocations)
        trackMapped.append(currentTrack)
        
//        paceNumber.append("0")

        index = trackMapped.count - 1
        playButton.isEnabled = true
        tableView.reloadData()
    }
    
    @IBAction func startButtonPressed(_ sender: UIBarButtonItem) {
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager?.delegate = self
        stopButton.isEnabled = true
    }
    
    // MARK: - StopButton
    @IBAction func stopButtonPressed(_ sender: UIBarButtonItem) {
        guard let coreDataManager = coreDataManager else { return }
        locationManager?.stopUpdatingLocation()
        
        
        let convert = currentTrack.totalPace ?? 0.0 / 0.762
        self.currentTrack.totalPace = convert.rounded()
        let rounded = "\(String(describing: self.currentTrack.totalPace.clean))"
        
        let alertVC = UIAlertController(title: "Veut tu arreter l'entrainement? ", message: "Félicitations!! Tu as gagner \(currentTrack.totalPace.clean ?? "Erreur de ") pas", preferredStyle: .alert)
        let stopAction = UIAlertAction(title: "Oui je suis sûr de moi", style: .default) {  _ in
            self.stopButton.isEnabled = false
            self.locationManager?.delegate = nil
            
            coreDataManager.saveTrack(numberOfPace: "\(rounded)", locations: self.temporaryLocations)
            let track: [Track] = coreDataManager.tracks.map { Track(locations: $0.locations!, totalPace: Double($0.totalPace ?? "0")!, timeStamp: $0.timestamp!) }
            
            self.trackMapped = track
            self.tableView.reloadData()
            print("***\(self.trackMapped)")
            self.temporaryLocations = [CLLocation]()
            print(self.temporaryLocations)
        }
        
        let continueAction = UIAlertAction(title: "Annuler", style: .cancel) { _ in
            self.locationManager?.startUpdatingLocation()
        }
        
        alertVC.addAction(stopAction)
        alertVC.addAction(continueAction)
        present(alertVC, animated: true, completion: nil)
        print("Tracks save \(coreDataManager.tracks)")
    }
    
    // MARK: - Localisation Services
    func requestLocation() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            activateLocationServices()
        } else {
            locationManager?.requestAlwaysAuthorization()
        }
    }
    
    func activateLocationServices() { locationManager?.startUpdatingLocation() }
    
    func stopLocalisationServices() {
        locationManager?.stopUpdatingLocation()
        locationManager?.delegate = nil
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.cellToMap {
            
            guard let mapController = segue.destination as? MapViewController else { return }
            guard let currentLocation = currentLocation else { return }
            mapController.currentLocation = currentLocation
            mapController.currentTrack.locations = currentTrack.locations
            mapController.index = index
        }
    }
}

// MARK: - TableView DataSource
extension TrackHistoryTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return coreDataManager?.tracks.count ?? 0
        print(trackMapped.count)
        return trackMapped.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //guard let coreDataManager = coreDataManager else { return UITableViewCell() }
        //guard let pace = coreDataManager.tracks[indexPath.row].totalPace else { return UITableViewCell() }
        let pace = trackMapped[indexPath.row].totalPace
        print(pace)
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.walkCell, for: indexPath)
//        cell.textLabel?.text = "Nombre de pas: \(countSessionArray[indexPath.row])"
        cell.textLabel?.text = "Nombre de pas: \(indexPath.row + 1)"
        cell.detailTextLabel?.text = "\(pace.clean) mètres parcourrus"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        index = indexPath.row
    }
}

// MARK: - Table View Delegate
extension TrackHistoryTableViewController {
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "⚠️Informations⚠️ \n\n Pour éviter toute erreur nous ajusterons votre nombre de pas à 0.\n Si vous êtes en dessous de la marche normale \n ou au-dessus de la vitesse maximum en vélo. \n\n Allez tu peux le faire. \n\n Pour commencer? Demmare une nouvelle session. "
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = Constant.Color.pink
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return coreDataManager?.tracks.isEmpty ?? true ? 300 : 0
        return trackMapped.isEmpty ? 300 : 0
    }
}

// MARK: - Location Manager Delegate
extension TrackHistoryTableViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            activateLocationServices()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error detected: \(error.localizedDescription)")
        
        if (error as NSError).code == CLError.locationUnknown.rawValue { return }
        locationManager?.stopUpdatingLocation()
    }
    
    // MARK: - Update locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if previousLocation == nil { previousLocation = locations.first
        } else {
            guard let newLocation = locations.last else { return }
//            guard paceNumber.isEmpty else { return }
//            guard let positionTrackArray = Double((coreDataManager?.tracks.last!.totalPace)!) else { return }
            guard let positionTrackArray = trackMapped.last?.totalPace else { return }
            
            // Get distance from previous to latest to get distance walked
            var distanceInMeters = previousLocation?.distance(from: newLocation) ?? 0
            
            // - Check where speed is not too fast or not too slow
            if distanceInMeters < 1 || distanceInMeters > 8.8 { distanceInMeters = 0 }
            
            var distanceRounded = distanceInMeters.rounded()
            distanceRounded += positionTrackArray
            
//            paceNumber[(coreDataManager?.users.count)! - 1] = "\(distanceRounded.clean)"
//            coreDataManager?.tracks.last!.totalPace = "\(distanceRounded.clean)"
            trackMapped[index].totalPace = distanceRounded
            
            currentTrack.totalPace = distanceRounded
            tableView.reloadData()
            
            // Store Location temporary in array which will be use until user stop to save in Core Data
            temporaryLocations.append(CLLocation(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude))
            
            previousLocation = newLocation
            currentLocation = newLocation
            print("temporaryLocations: \(temporaryLocations)")
        }
    }
}
