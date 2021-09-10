//
//  ViewController.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/1/15.
//

import UIKit
import MessageUI

/// Controller for set User's profil
final class ProfilViewController: UITableViewController {
    
    // MARK: - Property / outlet
    
    var coreDataManager: CoreDataManager?
    @IBOutlet weak var experienceLabel: UILabel!
    
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
    
    @IBAction func contactTapButton(_ sender: UIBarButtonItem) {
        sendEmail()
    }
}

extension ProfilViewController: MFMailComposeViewControllerDelegate {
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["gaffeJonathan@ymail.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

