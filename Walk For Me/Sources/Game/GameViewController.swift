//
//  GameViewController.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/2/11.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var slotButton1: UIButton!
    @IBOutlet weak var slotButton2: UIButton!
    @IBOutlet weak var slotButton3: UIButton!
    @IBOutlet weak var slotButton4: UIButton!
    
    @IBOutlet weak var paceNumberLabel: UILabel!
    @IBOutlet weak var moneyNumberLabel: UILabel!
    @IBOutlet weak var squareMeterNumberLabel: UILabel!
    @IBOutlet weak var tomatoesQuantityLabel: UILabel!
    @IBOutlet weak var potatoeQuantityLabel: UILabel!
    @IBOutlet weak var wheatQuantityLAbel: UILabel!
    
    var coreDataManager: CoreDataManager?
    var coreDataCount = 0
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
        
        coreDataManager = CoreDataManager(coreDataStack: sceneDelegate.coreDataStack)
        guard let coreDataManager = coreDataManager else { return }
        self.coreDataManager = coreDataManager
        
        guard coreDataCount != coreDataManager.tracks.count else { return }
        
        var total = 0
        for user in coreDataManager.tracks {
            if let pace = user.totalPace {
                guard let paceNumber = Int(pace) else { return }
                total += paceNumber
            } else {
                print("Unwrapped failed")
            }
        }
        updateUI(total: total)
        coreDataCount = coreDataManager.tracks.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentAlert(title: "Information", message: "Vous pouvez échanger vos pas contre \n de l'argent grâce au logo échange", actionTitle: "OK")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coreDataManager?.saveData(paceAmount: paceNumberLabel.text, moneyAmount: moneyNumberLabel.text)
    }
    
    func updateUI(total: Int) {
        paceNumberLabel.text = "\(total)"
        moneyNumberLabel.text = "0"
        squareMeterNumberLabel.text = "0"
        tomatoesQuantityLabel.text = "0"
        potatoeQuantityLabel.text = "0"
        wheatQuantityLAbel.text = "0"
    }
    
    // MARK: - Actions
    @IBAction func exchangeButtonTapped(_ sender: UIButton) {
        displayExchangeAlert { paceNumber in
            guard let paceNumber = Int(paceNumber ?? "0") else { return }
            guard var paceNumberLabel = Int(self.paceNumberLabel.text ?? "0") else { return }
            if paceNumber > paceNumberLabel {
                self.presentAlert(title: "Erreur", message: "Vous ne pouvez pas échanger plus de pas que vous en avez", actionTitle: "Bon ok !")}
            else {
                paceNumberLabel =  "\(Int(paceNumberLabel)! - Int(paceNumber)!)"
                
                print(paceNumber)
                self.paceNumberLabel.text = paceNumberLabel
                self.moneyNumberLabel.text = paceNumber
            }
        }
    }
    
    @IBAction func slotButton1Tapped(_ sender: UIButton) {
        print("Tapped")
    }
}
