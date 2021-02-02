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
    
    var paceTitle = [String]()
    var paceNumber = ["1"]
    
    var locationManager: CLLocationManager?
    var previousLocation: CLLocation?
    var currentLocation: CLLocation?
    var user = PositionUser()
    var index = 0

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        paceTitle.append("nombre de pas \(paceNumber.count)")
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    @IBAction func newSessionButton(_ sender: UIBarButtonItem) {
        paceTitle.append("Nombre de pas \(paceNumber.count + 1)")
        paceNumber.append("0")
        index += 1
        tableView.reloadData()
    }
    
    func activateLocationServices() { locationManager?.startUpdatingLocation() }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.cellToMap {
            
            guard let mapController = segue.destination as? MapViewController else { return }
            guard let currentLocation = currentLocation else { return }
            mapController.currentLocation = currentLocation
            mapController.user.locations = user.locations
//            mapController.user.locations = self.userArray
        }
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
        cell.detailTextLabel?.text = "\(paceNumber[indexPath.row]) mètres par secondes"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // MARK: - Check current location
        //        currentLocation = locations.first
        //        print(currentLocation as Any)
        
        if previousLocation == nil {
            previousLocation = locations.first
            user.location = previousLocation!
            print("First location of user: \(user.location)")
            //            currentLocation = locations.first
            
        } else {
            guard let latest = locations.first else { return }
            let distanceInMeters = previousLocation?.distance(from: latest) ?? 0
            var distanceRounded = distanceInMeters.rounded()
            print("Distance in meters: \(distanceRounded)")
            let unwrappedPaceNumber = paceNumber[0]
            distanceRounded += Double(unwrappedPaceNumber)!
            paceNumber[0] = "\(distanceRounded.clean)"
            print(paceNumber[0])
            tableView.reloadData()
            user.locations.append(CLLocation(latitude: latest.coordinate.latitude, longitude: latest.coordinate.longitude))
            print("User array location: \(user.locations)")
            //self.userArray = user.locations
            previousLocation = latest
            currentLocation = latest
            

        }
    }
}
