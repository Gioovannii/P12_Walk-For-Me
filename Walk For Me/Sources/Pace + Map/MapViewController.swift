//
//  MapViewController.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/1/23.
//

import UIKit
import MapKit

/// Map controller
final class MapViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var location: CLLocationCoordinate2D?
    var currentTrack = [CLLocation]()
    var currentLocation: CLLocation?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let latitude = currentTrack.last?.coordinate.latitude else { return }
        guard let longitude = currentTrack.last?.coordinate.longitude else { return }
        
        let loadLocation = CLLocation(latitude: (latitude),longitude: (longitude))
        
        let regionRadius: CLLocationDistance = 1000.0
        let region = MKCoordinateRegion(center: loadLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        mapView.setRegion(region, animated: true)
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backBarButtonItem?.tintColor = .red
        produceOverlay()
    }
    
    // MARK: - Actions
    @IBAction func changeMapType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
            mapView.isRotateEnabled = false
        case 1:
            mapView.mapType = .satelliteFlyover
            if var location = location {
                guard let currentLocation = currentLocation else { return }
                location.latitude = (currentLocation.coordinate.latitude)
                location.longitude = (currentLocation.coordinate.longitude)
                let camera = MKMapCamera(lookingAtCenter: location, fromDistance: 300, pitch: 40, heading: 0)
                mapView.camera = camera
                mapView.isRotateEnabled = true
            }
            
        default:
            print("Nothing happened")
        }
    }
    
    /// Set some line where user go
    private func produceOverlay() {
        var points: [CLLocationCoordinate2D] = []
        
        for i in 0..<currentTrack.count {
            points.append(CLLocationCoordinate2DMake(currentTrack[i].coordinate.latitude, currentTrack[i].coordinate.longitude))
        }
                
        let polygon = MKPolygon(coordinates: &points, count: points.count)
        mapView.addOverlay(polygon)
        
    }
}

// MARK: - Map View Delegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyRenderer = MKPolygonRenderer(overlay: overlay)
        polyRenderer.strokeColor = UIColor(red: 0.557, green: 0.267, blue: 0.678, alpha: 1)
        polyRenderer.lineWidth = 4.0
        
        return polyRenderer
    }
    
    func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
                print("Rendering ...")
    }
}
