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
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    private var exp = 0
    private let progress = Progress(totalUnitCount: 1000)
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 4)
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
        exp = Int(experience) ?? 0
        progressView.progress = Float(exp) / 1000
        print(experience)

    }
    
    // MARK: - Actions

    @IBAction func contactTapButton(_ sender: UIBarButtonItem) {
        sendEmail()
    }
    
    @IBAction func collectExperience(_ sender: UIBarButtonItem) {
        if exp < 100 {
            let progressFloat = Float(exp) / 1000
            self.progressView.setProgress(progressFloat, animated: true)
        } else if exp > 100 {
            guard var levelAmount = Int(levelLabel.text ?? "0") else { return }
             levelAmount += 1
            progressView.progress = 0
        }
    }
}

// MARK: - Mail Compose View Delegate

extension ProfilViewController: MFMailComposeViewControllerDelegate {
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["gaffeJonathan@ymail.com"])
            mail.setMessageBody("<p>Bonjour, comment pouvons-nous vous aider ?</p>", isHTML: true)
            
            present(mail, animated: true)
        } else { presentAlert(title: "Oups", message: "Une erreur est survenue", actionTitle: "OK") }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

