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
    
    private var user = PositionUser()
    private var index = 0
    private var totalPace = ""
    
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
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if previousLocation == nil {
            previousLocation = locations.first

            
        } else {
            guard let latest = locations.first else { return }
            guard let unwrappedPaceNumber = Double(paceNumber[index]) else { return }
            
            let distanceInMeters = previousLocation?.distance(from: latest) ?? 0
            var distanceRounded = distanceInMeters.rounded()
            
            distanceRounded += unwrappedPaceNumber
            paceNumber[index] = "\(distanceRounded.clean)"
            print(distanceRounded.clean)
            tableView.reloadData()
            user.locations.append(CLLocation(latitude: latest.coordinate.latitude, longitude: latest.coordinate.longitude))
            print("User array location: \(user.locations)")
            
            previousLocation = latest
            currentLocation = latest
            

        }
    }
}
