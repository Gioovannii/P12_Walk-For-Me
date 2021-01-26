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
    }
    
    @IBAction func addItemPressed(_ sender: Any) {
        
    }
}
