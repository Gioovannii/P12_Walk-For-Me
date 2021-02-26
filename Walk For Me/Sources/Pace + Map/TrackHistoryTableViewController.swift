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
    private var paceNumber = [String]()
    
    private var locationManager: CLLocationManager?
    private var previousLocation: CLLocation?
    private var currentLocation: CLLocation?
    
    private var user = User()
    private var index = 0
    var distanceInMeters = 0.0
    
    var coreDataManager: CoreDataManager?
    
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
        playButton.isEnabled = false
        stopButton.isEnabled = false
        //print("Fetch core data")
    }
    
    @IBAction func newSessionButton(_ sender: UIBarButtonItem) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
        
        coreDataManager = CoreDataManager(coreDataStack: sceneDelegate.coreDataStack)
        guard let coreDataManager = coreDataManager else { return }
        self.coreDataManager = coreDataManager
        
        paceTitle.append("Nombre de pas \(paceNumber.count + 1)")
        paceNumber.append("0")
        index += 1
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

            //print("Pace send to save: \(rounded)")
            coreDataManager.savePace(numberOfPace: "\(rounded)")
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
        return paceNumber.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.walkCell, for: indexPath)
        cell.textLabel?.text = paceTitle[indexPath.row + 1]
        cell.detailTextLabel?.text = "\(paceNumber[indexPath.row]) mètres parcourrus"
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
        return paceNumber.isEmpty ? 300 : 0
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
        let seconds = 300.0
        
        if previousLocation == nil { previousLocation = locations.first
        } else {
            guard let newLocation = locations.last else { return }
            
            if newLocation.speed > 0  {
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    print("Too slow")
                    print(newLocation.timestamp)
                }
                if newLocation.speed < 1  {
             
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                        print("Too slow")
                        print(newLocation.timestamp)
                    }
                    
                } else if newLocation.speed >= 8.8  {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                        print("too fast")
                        print(newLocation.timestamp)

                    }
                    print("too fast")
                    print(newLocation.timestamp)

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
