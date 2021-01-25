//
//  TrackHistory.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/1/19.
//

import UIKit
import CoreLocation

class PlaceTableViewController: UITableViewController {
    var history = ["historique 1", "historique 2", "historique 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PlaceTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paceTitle.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Walk Cell", for: indexPath)
        cell.textLabel?.text = paceTitle[indexPath.row]
        cell.detailTextLabel?.text = paceNumber[indexPath.row]
        return cell
    }
    
}
