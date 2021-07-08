//
//  ViewController.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/1/15.
//

import UIKit

/// Controller for set User's profil
final class ProfilViewController: UITableViewController {
    
    // MARK: - Property / outlet
    
    var coreDataManager: CoreDataManager?
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    
    /// Each time user switch back here
    /// - Parameter animated: UI Purpose Only
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        coreDataManager = CoreDataManager(coreDataStack: appDelegate.coreDataStack)
        guard let coreDataManager = coreDataManager else { return }
        self.coreDataManager = coreDataManager
        guard let experience = coreDataManager.game?.experience else {
            experienceLabel.text = "0"
            return
        }
        experienceLabel.text = experience
    }
}
