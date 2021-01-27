//
//  MapViewController.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/1/23.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var mapView: MKMapView!
    
    var longitude = 0.0
    var latitude = 0.0
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loadLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let regionRadius: CLLocationDistance = 1000.0
        let region = MKCoordinateRegion(center: loadLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
        mapView.delegate = self
        produceOverlay()
    }
    
 
}
