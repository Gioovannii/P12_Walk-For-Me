//
//  ViewController.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/1/15.
//

import UIKit

class ProfilViewController: UITableViewController {
    
    @IBOutlet weak var followSteps: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func reminderSwitch(_ sender: UISwitch) {
    }
    
    func FollowSteps(sender: UISwitch) {
        switch sender.isOn {
        case true:
            print("Activate follow Steps")
            return
        case false:
            print("Activate follow Steps")
            return
            
        }
    }
}

