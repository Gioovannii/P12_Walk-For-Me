//
//  TrackHistory.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/1/19.
//

import UIKit
import CoreLocation

/// TrackController
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
    @IBOutlet weak var clearButton: UIBarButtonItem!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        coreDataManager = CoreDataManager(coreDataStack: appDelegate.coreDataStack)
        guard let coreDataManager = coreDataManager else { return }
        self.coreDataManager = coreDataManager
        if coreDataManager.tracks.isEmpty { clearButton.isEnabled = false }
        tableView.tableFooterView = UIView()
        
        locationManager = CLLocationManager()
        requestLocation()
        
        let track: [Track] = coreDataManager.tracks.map { Track(locations: $0.locations!, totalPace: Double($0.totalPace ?? "0")!, timeStamp: $0.timestamp! ) }
        
        self.trackMapped = track
        
    }
    
    // MARK: - Actions
    @IBAction func newSessionButton(_ sender: UIBarButtonItem) {
        currentTrack = Track(locations: temporaryLocations)
        trackMapped.append(currentTrack)
        playButton.isEnabled = true
        clearButton.isEnabled = true
        tableView.reloadData()
    }
    
    /// Start button
    @IBAction func startButtonPressed(_ sender: UIBarButtonItem) {
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager?.delegate = self
        stopButton.isEnabled = true
        playButton.isEnabled = false
    }
    
    // MARK: - StopButton
    @IBAction func stopButtonPressed(_ sender: UIBarButtonItem) {
        guard let coreDataManager = coreDataManager else { return }
        locationManager?.stopUpdatingLocation()
        let convert = currentTrack.totalPace / 0.762
        
        // Retrieve last pace and add current amount of pace
        guard let lastPace = Int((coreDataManager.game?.paceAmount ?? "0")) else { return }
        let paceToGame = lastPace + Int(convert.rounded())
        self.currentTrack.totalPace = convert.rounded()
        let rounded = "\(String(describing: self.currentTrack.totalPace.clean))"
        
        let alertVC = UIAlertController(title: "Veut tu arreter l'entrainement? ", message: "Félicitations!! Tu as gagner \(currentTrack.totalPace.clean) pas", preferredStyle: .alert)
        let stopAction = UIAlertAction(title: "Oui je suis sûr de moi", style: .default) {  _ in
            self.playButton.isEnabled = false
            self.stopButton.isEnabled = false
            self.locationManager?.delegate = nil
            coreDataManager.saveTrack(numberOfPace: "\(rounded)", locations: self.temporaryLocations)
            let track: [Track] = coreDataManager.tracks.map { Track(locations: $0.locations!, totalPace: Double($0.totalPace ?? "0")!, timeStamp: $0.timestamp!) }
            
            self.trackMapped = track
            self.tableView.reloadData()
            self.temporaryLocations = [CLLocation]()
        }
        
        let continueAction = UIAlertAction(title: "Annuler", style: .cancel) { _ in
            self.locationManager?.startUpdatingLocation()
        }
        
        alertVC.addAction(stopAction)
        alertVC.addAction(continueAction)
        present(alertVC, animated: true, completion: nil)
        
        // Game Data
        coreDataManager.saveData(paceAmount: "\(paceToGame)")
    }
    
    @IBAction func deleteTracks(_ sender: UIBarButtonItem) {
        coreDataManager?.clearTracks()
        trackMapped.removeAll()
        playButton.isEnabled = false
        clearButton.isEnabled = false
        tableView.reloadData()
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
            mapController.currentTrack = trackMapped[selectedRow].locations
            //         mapController.currentTrack.locations = currentTrack.locations // Do something with location of user
        }
    }
}

// MARK: - TableView DataSource

extension TrackHistoryTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackMapped.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pace = trackMapped[indexPath.row].totalPace
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.walkCell, for: indexPath)
        cell.textLabel?.text = "Nombre de pas: \(indexPath.row + 1)"
        cell.detailTextLabel?.text = "\(pace.clean) mètres parcourrus"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRow = indexPath.row
        performSegue(withIdentifier: Constant.cellToMap, sender: nil)
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
            guard let positionTrackArray = trackMapped.last?.totalPace else { return }
            
            // Get distance from previous to latest to get distance walked
            var distanceInMeters = previousLocation?.distance(from: newLocation) ?? 0
            
            // Check where speed is not too fast or not too slow
            if distanceInMeters < 1 || distanceInMeters > 8.8 { distanceInMeters = 0 }
            
            var distanceRounded = distanceInMeters.rounded()
            distanceRounded += positionTrackArray
            
            trackMapped[trackMapped.count - 1].totalPace = distanceRounded
            currentTrack.totalPace = distanceRounded
            print(distanceRounded)
            print(distanceInMeters)
            print("Instead of pas in table view")
            tableView.reloadData()
            
            // Store Location temporary in array which will be use until user stop to save in Core Data
            temporaryLocations.append(CLLocation(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude))
            
            previousLocation = newLocation
            currentLocation = newLocation
        }
    }
}
