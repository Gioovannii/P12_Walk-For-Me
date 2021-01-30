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
    var paceNumber = ["1", "20", "59", "78", "71", "82", "56"]

    var locationManager: CLLocationManager?
    var previousLocation: CLLocation?
    var currentLocation: CLLocation?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        for i in 1...paceNumber.count {
            paceTitle.append("Nombre de pas " + "\(i)")
        }
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager?.allowsBackgroundLocationUpdates = true
    }
    
    func activateLocationServices() {
        locationManager?.startUpdatingLocation()
        
        // MARK: - Ask location only one time
        
//        locationManager?.requestLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CellToMap" {
            
            guard let mapController = segue.destination as? MapViewController else { return }
            guard let currentLocation = currentLocation else { return }
            mapController.longitude = currentLocation.coordinate.longitude
            mapController.latitude = currentLocation.coordinate.latitude
        }
    }
}

// MARK: - TableView DataSource

extension TrackHistoryTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paceNumber.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Walk Cell", for: indexPath)
        cell.textLabel?.text = paceTitle[indexPath.row]
        cell.detailTextLabel?.text = paceNumber[indexPath.row]
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
//                currentLocation = locations.first
//                print(currentLocation as Any)
        
        if previousLocation == nil {
            previousLocation = locations.first
        } else {
            guard let latest = locations.first else { return }
            let distanceInMeters = previousLocation?.distance(from: latest) ?? 0
            var distanceRounded = distanceInMeters.rounded()
            print("Distance in meters: \(distanceRounded)")
            let unwrappedPaceNumber = paceNumber[0]
            distanceRounded += Double(unwrappedPaceNumber)!
            paceNumber[0] = "\(distanceRounded)"
            print(paceNumber[0])
            tableView.reloadData()

            previousLocation = latest
        }
    }
}