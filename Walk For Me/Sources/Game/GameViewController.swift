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
        
        for entity in coreDataManager.game {
            print(entity.paceAmount as Any)
        }
        guard let total = coreDataManager.game.last else { return }
        updateUI(total: total)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentAlert(title: "Information", message: "Vous pouvez échanger vos pas contre \n de l'argent grâce au logo échange", actionTitle: "OK")
    }
    
    func updateUI(total: GameEntity) {
        for i in coreDataManager!.game {
            print(i)
        }
        paceNumberLabel.text = "\(coreDataManager?.game.last?.paceAmount ?? "0")"
        moneyNumberLabel.text = "\(coreDataManager?.game.last?.moneyAmount ?? "0")"
        squareMeterNumberLabel.text = "0"
        tomatoesQuantityLabel.text = "0"
        potatoeQuantityLabel.text = "0"
        wheatQuantityLAbel.text = "0"
    }
    
    // MARK: - Actions
    @IBAction func exchangeButtonTapped(_ sender: UIButton) {
        displayExchangeAlert { moneyNumber in
            guard let moneyNumber = Int(moneyNumber ?? "0") else { return }
            guard var paceNumberLabel = Int(self.paceNumberLabel.text ?? "0") else { return }
            if moneyNumber > paceNumberLabel {
                self.presentAlert(title: "Erreur", message: "Vous ne pouvez pas échanger plus de pas que vous en avez", actionTitle: "Bon ok !")}
            else {
                paceNumberLabel -=  moneyNumber
                self.paceNumberLabel.text = "\(paceNumberLabel)"
                self.moneyNumberLabel.text = "\(moneyNumber)"
            }
            //self.coreDataManager?.savePace(paceAmount: "\(paceNumberLabel)")
            self.coreDataManager?.game.last?.moneyAmount = "\(moneyNumber)"
            guard var paceToInt = Int((self.coreDataManager?.game.last?.paceAmount)!) else { return }
            paceToInt -= paceNumberLabel
            self.coreDataManager?.saveMoney(moneyamount: "\(paceToInt)", paceAmount: "\(paceNumberLabel)")
            print("new value \(self.coreDataManager?.game.last?.paceAmount)")
        }
    }
    
    @IBAction func slotButton1Tapped(_ sender: UIButton) {
        print("Tapped")
    }
}
