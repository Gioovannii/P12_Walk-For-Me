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
    var paceNumber = [String]()
    var count = [String]()
    var countTrack = 0
    
    private var locationManager: CLLocationManager?
    private var previousLocation: CLLocation?
    private var currentLocation: CLLocation?
    
    private var user = Track()
    private var index = 0
    var temporaryLocations = [CLLocation]()
    
    var coreDataManager: CoreDataManager?
    
    @IBOutlet weak var playButton: UIBarButtonItem!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.isEnabled = false
        stopButton.isEnabled = false
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
        
        coreDataManager = CoreDataManager(coreDataStack: sceneDelegate.coreDataStack)
        guard let coreDataManager = coreDataManager else { return }
        self.coreDataManager = coreDataManager
        
        if !coreDataManager.users.isEmpty { playButton.isEnabled = true }
        tableView.tableFooterView = UIView()

        locationManager = CLLocationManager()
        requestLocation()
        
        
        
        for track in coreDataManager.users {
            print("Looping sessions \(track.locations as Any)")
            count.append("\(countTrack + 1)")
            paceNumber.append("0")
            guard let last = Int(count.last ?? "") else { return }
            countTrack = last
        }
    }
    
    // MARK: - Actions
    @IBAction func newSessionButton(_ sender: UIBarButtonItem) {
        guard let coreDataManager = coreDataManager else { return }
        index = coreDataManager.users.count - 1
        
        count.append("\(countTrack + 1)")
        guard let last = Int(count.last ?? "0") else { return }
        countTrack = last
        coreDataManager.newSession()
        paceNumber.append("0")
    
        if paceNumber.count > 1 {
            index += 1
            let newArray = [CLLocation]()
            user.locations.append(newArray)
        }
        else {
            index = 0
        }
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
        
        let convert = user.totalPace / 0.762
        self.user.totalPace = convert.rounded()
        let rounded = "\(self.user.totalPace.clean)"
        
        let alertVC = UIAlertController(title: "Veut tu arreter l'entrainement? ", message: "Félicitations!! Tu as gagner \(user.totalPace.clean) pas", preferredStyle: .alert)
        let stopAction = UIAlertAction(title: "Oui je suis sûr de moi", style: .default) {  _ in
            self.stopButton.isEnabled = false
            self.locationManager?.delegate = nil
            
            coreDataManager.saveTrack(numberOfPace: "\(rounded)", locations: self.temporaryLocations)
        }
        
        let continueAction = UIAlertAction(title: "Annuler", style: .cancel) { _ in
            self.locationManager?.startUpdatingLocation()
        }
        
        alertVC.addAction(stopAction)
        alertVC.addAction(continueAction)
        present(alertVC, animated: true, completion: nil)
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
            mapController.user.locations = user.locations
            mapController.index = index
        }
    }
}

// MARK: - TableView DataSource
extension TrackHistoryTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataManager?.users.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let coreDataManager = coreDataManager else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.walkCell, for: indexPath)
//        cell.textLabel?.text = paceTitle[indexPath.row + 1]
        cell.textLabel?.text = "Nombre de pas: \(coreDataManager.count[indexPath.row])"
//        cell.detailTextLabel?.text = "\(paceNumber[indexPath.row]) mètres parcourrus"
        cell.detailTextLabel?.text = "\(coreDataManager.users[indexPath.row].pace!) mètres parcourrus"
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
        label.text = "⚠️Informations⚠️ \n\n 🛑 Pour éviter toute erreur nous ajusterons votre nombre de pas à 0.\n Si vous êtes en dessous de la marche normale ou au-dessus de la vitesse maximum en vélo. 🛑 \n\n Allez tu peux le faire. 💪 \n\n 🚀 Pour commencer Creer une nouvelle session. 🚀 "
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = Constant.Color.pink
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return coreDataManager?.users.isEmpty ?? true ? 300 : 0
            //paceNumber.isEmpty ? 300 : 0
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if previousLocation == nil { previousLocation = locations.first
        } else {
            guard let newLocation = locations.last else { return }
            guard let positionTrackArray = Double(paceNumber[(coreDataManager?.users.count)! - 1]) else { return }
            
            
            // Get distance from previous to latest to get distance walked
            var distanceInMeters = previousLocation?.distance(from: newLocation) ?? 0
            
            // - Check where speed is not too fast or not too slow
            if distanceInMeters < 1 || distanceInMeters > 8.8 { distanceInMeters = 0 }
            
            var distanceRounded = distanceInMeters.rounded()
            distanceRounded += positionTrackArray
            
            paceNumber[(coreDataManager?.users.count)! - 1] = "\(distanceRounded.clean)"
            user.totalPace = distanceRounded
            
            tableView.reloadData()
            
            // Store Location temporary in array which will be use until user stop to save in Core Data
            temporaryLocations.append(CLLocation(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude))
            
            previousLocation = newLocation
            currentLocation = newLocation
            print("temporaryLocations: \(temporaryLocations)")
//            if user.locations.isEmpty {
//                user.locations.append([CLLocation(latitude: newLocation.coordinate.latitude,
//                                                  longitude: newLocation.coordinate.longitude)])
//            } else { user.locations[index].append(CLLocation(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude))
//
//            }
//            print(user.locations[index])
           
        }
    }
}
