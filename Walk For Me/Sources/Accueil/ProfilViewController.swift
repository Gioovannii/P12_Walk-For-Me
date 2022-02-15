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
    
    @IBOutlet weak var badges: UIImageView!
    
    private var exp = 0
    private let progress = Progress(totalUnitCount: 1000)
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 4)
        badges.image = UIImage(named: "love-heart")
        badges.alpha = 0.2
    }
    
    /// Each time user switch back here
    /// - Parameter animated: UI Purpose Only
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupcoreDataManager()
        progressView.setProgress(Float(exp), animated: false)
        print(exp)
        
    }
    
    // MARK: - Actions
    
    @IBAction func contactTapButton(_ sender: UIBarButtonItem) {
        sendEmail()
    }
    
    func setupcoreDataManager() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        coreDataManager = CoreDataManager(coreDataStack: appDelegate.coreDataStack)
        guard let coreDataManager = coreDataManager else { return }
        self.coreDataManager = coreDataManager
        
//        guard let experience = coreDataManager.game?.experience else {
//            experienceLabel.text = "0"
//            return
//        }
        
//        experienceLabel.text = experience
//        exp = Int(experience) ?? 0
        
        experienceLabel.text = "\(exp)"
        exp = Int(exp) 
        progressView.progress = Float(exp) / 1000
        print(exp)
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

