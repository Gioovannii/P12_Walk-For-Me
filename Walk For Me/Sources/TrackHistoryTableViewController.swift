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
    
    func requestLocation() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            activateLocationServices()
        } else {
            locationManager?.requestAlwaysAuthorization()
        }
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
    
    @IBAction func stopButtonPressed(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(title: "Veut tu arreter l'entrainement? ", message: "Tu as gagner \(totalPace) de pas", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Oui je suis sûr de moi", style: .default) { _ in
            self.stopButton.isEnabled = false
            self.locationManager?.stopUpdatingLocation()
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
//            print("Prev loc \(previousLocation)")
            
            guard let newLocation = locations.last else { return }
           // if newLocation.course < 50 { return }
            if newLocation.speed > 0 {
                if newLocation.speed < 1 { print("not mooving?")
                    presentAlert(title: "Erreur", message: "As tu arreter l'entrainement ??")
                } else if newLocation.speed > 8.8 { print("too fast")
                    presentAlert(title: "Erreur", message: "Tu dois faire du sport et non prendre les transport 🧐 ")
                }
            }
            print("Loc now \(newLocation)")

            guard let unwrappedPaceNumber = Double(paceNumber[index]) else { return }
            
            // Get distance from previous to latest to get distance walked
            let distanceInMeters = previousLocation?.distance(from: newLocation) ?? 0
            var distanceRounded = distanceInMeters.rounded()

            distanceRounded += unwrappedPaceNumber
            paceNumber[index] = "\(distanceRounded.clean)"

            
            guard let convertToDouble = Double(paceNumber[index]) else { return }
            let convert = convertToDouble / 0.762
            totalPace = "\(convert.rounded().clean)"
            print(distanceRounded.clean)
            tableView.reloadData()

            user.locations.append(CLLocation(latitude: newLocation.coordinate.latitude,
                                             longitude: newLocation.coordinate.longitude))

            previousLocation = newLocation
            currentLocation = newLocation
        }
    }
}
