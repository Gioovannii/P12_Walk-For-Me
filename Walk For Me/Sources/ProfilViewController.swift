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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

