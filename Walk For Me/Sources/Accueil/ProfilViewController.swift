//
//  ViewController.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/1/15.
//

import UIKit

final class ProfilViewController: UITableViewController {
    
    @IBOutlet weak var followSteps: UISwitch!
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func reminderSwitch(_ sender: UISwitch) {
            switch sender.isOn {
            case true:
                print("Activate Notifications")
                reminderSwitch.isOn = true
            case false:
                print("Desativate notification")
                reminderSwitch.isOn = false
            }
        }
    
    @IBAction func followsteps(_ sender: UISwitch) {
        switch sender.isOn {
        case true:
            print("Activate pace tracking")
            followSteps.isOn = true
        case false:
            print("Desativate pace tracking")
            followSteps.isOn = false
        }
    }
}

