//
//  TrackHistory.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/1/19.
//

import UIKit

class TrackHistory: UITableViewController {
    var history = ["historique 1", "historique 2", "historique 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TrackHistory {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        history.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Walk Cell", for: indexPath)
        cell.textLabel?.text = history[indexPath.row]
        return cell
    }
    
    
}
