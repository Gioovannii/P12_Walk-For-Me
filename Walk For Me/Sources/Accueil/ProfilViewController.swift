//
//  ViewController.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/1/15.
//

import UIKit

final class ProfilViewController: UITableViewController {
    
    @IBOutlet weak var experience: UILabel!
    @IBOutlet weak var followSteps: UISwitch!
    var coreDataManager: CoreDataManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        coreDataManager = CoreDataManager(coreDataStack: appDelegate.coreDataStack)
        guard let coreDataManager = coreDataManager else { return }
        self.coreDataManager = coreDataManager
        
        experience.text = coreDataManager.game?.experience
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

