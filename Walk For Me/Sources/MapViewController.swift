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
    
    // MARK: - Actions
    
    @IBAction func changeMapType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        default:
            return
        }
    }
    
    private func produceOverlay() {
        var points: [CLLocationCoordinate2D] = []
        points.append(CLLocationCoordinate2DMake(25.029835, 121.529526))
        points.append(CLLocationCoordinate2DMake(25.029900, 121.529570))
        points.append(CLLocationCoordinate2DMake(25.030450, 121.529890))
        points.append(CLLocationCoordinate2DMake(25.030500, 121.532000))

        let polygon = MKPolygon(coordinates: &points, count: points.count)
        mapView.addOverlay(polygon)

    }
}

// MARK: - Map View Delegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyRenderer = MKPolygonRenderer(overlay: overlay)
        polyRenderer.strokeColor = .blue
        polyRenderer.lineWidth = 9.0
        
        return polyRenderer
    }

}
