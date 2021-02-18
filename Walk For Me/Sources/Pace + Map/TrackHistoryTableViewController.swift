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
    
    private var paceTitle = [String]()
    private var paceNumber = ["0"]
    
    private var locationManager: CLLocationManager?
    private var previousLocation: CLLocation?
    private var currentLocation: CLLocation?
    
    private var user = UserInformations()
    private var index = 0
    var distanceInMeters = 0.0
    
    var coreDataManager: CoreDataManager?
    
    var lastLocationError: Error?
    var location: CLLocation?
    
    @IBOutlet weak var playButton: UIBarButtonItem!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        paceTitle.append("nombre de pas \(paceNumber.count)")
        locationManager = CLLocationManager()
        requestLocation()
        stopButton.isEnabled = false
        //print("Fetch core data")
    }
    
    @IBAction func newSessionButton(_ sender: UIBarButtonItem) {
        paceTitle.append("Nombre de pas \(paceNumber.count + 1)")
        paceNumber.append("0")
        index += 1
        playButton.isEnabled = true
        tableView.reloadData()
    }
    
    func activateLocationServices() { locationManager?.startUpdatingLocation() }
    
    func requestLocation() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            activateLocationServices()
        } else {
            locationManager?.requestAlwaysAuthorization()
        }
    }
    
    func stopLoc() {
        locationManager?.stopUpdatingLocation()
        locationManager?.delegate = nil
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.cellToMap {
            
            guard let mapController = segue.destination as? MapViewController else { return }
            guard let currentLocation = currentLocation else { return }
            mapController.currentLocation = currentLocation
            mapController.user.locations = user.locations
        }
    }
    
    @IBAction func startButtonPressed(_ sender: UIBarButtonItem) {
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager?.delegate = self
        stopButton.isEnabled = true
    }
    
    @available(iOS 13.0, *)
    @IBAction func stopButtonPressed(_ sender: UIBarButtonItem) {

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate else { return }
            
        coreDataManager = CoreDataManager(coreDataStack: delegate.coreDataStack)
        guard let coreDataManager = coreDataManager else { return }
        self.coreDataManager = coreDataManager
        
        let convert = distanceInMeters / 0.762
        user.totalPace = convert.rounded()
        
        let alertVC = UIAlertController(title: "Veut tu arreter l'entrainement? ", message: "Félicitations!! Tu as gagner \(user.totalPace.clean) pas", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Oui je suis sûr de moi", style: .default) {  _ in
            // * Stop Action
            self.stopButton.isEnabled = false
            self.locationManager?.stopUpdatingLocation()
            self.locationManager?.delegate = nil
            
            // ** Save to core data
            self.user.totalPace += convert
            
            let rounded = self.user.totalPace.rounded().clean
            print("Pace send to save: \(rounded)")
            self.coreDataManager!.savePace(numberOfPace: "\(rounded)")
            
            // Open all values register
            for user in coreDataManager.users {
                print("CoreData Values: \(user.pace ?? "Default")")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        
        alertVC.addAction(continueAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - TableView DataSource

extension TrackHistoryTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paceNumber.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.walkCell, for: indexPath)
        cell.textLabel?.text = paceTitle[indexPath.row]
        cell.detailTextLabel?.text = "\(paceNumber[indexPath.row]) mètres parcourrus"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        index = indexPath.row
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
        lastLocationError = error
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if previousLocation == nil { previousLocation = locations.first
        } else {
            guard let newLocation = locations.last else { return }
            
            if newLocation.speed > 0  {
                if newLocation.speed < 1  {
                    print("Too slow")
                    print(newLocation)
//                    locationManager?.stopUpdatingLocation()
//                    presentAlert(title: "too slow", message: "")
                    
                    
                } else if newLocation.speed >= 8.8  {
                    print("too fast")
//                    locationManager?.stopUpdatingLocation()
//                    presentAlert(title: "too fast", message: "")
                    print(newLocation)


                }
            } else {
                locationManager?.startUpdatingLocation()
            }
            
            print("Speed now \(newLocation.speed)")
            guard let unwrappedPaceNumber = Double(paceNumber[index]) else { return }
            
            
            // Get distance from previous to latest to get distance walked
            let distanceInMeters = previousLocation?.distance(from: newLocation) ?? 0
            var distanceRounded = distanceInMeters.rounded()
            
            distanceRounded += unwrappedPaceNumber
            paceNumber[index] = "\(distanceRounded.clean)"
            
            guard let convertToDouble = Double(paceNumber[index]) else { return }
            self.distanceInMeters = convertToDouble
            
            print(distanceRounded.clean)
            tableView.reloadData()
            
            user.locations.append(CLLocation(latitude: newLocation.coordinate.latitude,
                                             longitude: newLocation.coordinate.longitude))
            
            previousLocation = newLocation
            currentLocation = newLocation
        }
    }
}
