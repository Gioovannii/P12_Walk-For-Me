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
    var currentGame : GameEntity?
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
        
        coreDataManager = CoreDataManager(coreDataStack: sceneDelegate.coreDataStack)
        guard let coreDataManager = coreDataManager else { return }
        self.coreDataManager = coreDataManager
        
        
        guard let total = coreDataManager.game else { return }
        
        print("current game \(total?.paceAmount)")

        updateUI(total: total!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentAlert(title: "Information", message: "Vous pouvez échanger vos pas contre \n de l'argent grâce au logo échange", actionTitle: "OK")
    }
    
    func updateUI(total: GameEntity) {
        paceNumberLabel.text = "\(coreDataManager?.game?.paceAmount ?? "0")"
        moneyNumberLabel.text = "\(coreDataManager?.game?.moneyAmount ?? "0")"
        squareMeterNumberLabel.text = "0"
        tomatoesQuantityLabel.text = "0"
        potatoeQuantityLabel.text = "0"
        wheatQuantityLAbel.text = "0"
    }
    
    // MARK: - Actions
    @IBAction func exchangeButtonTapped(_ sender: UIButton) {
        displayExchangeAlert { moneyNumber in
            guard let moneyNumber = Int(moneyNumber ?? "0") else { return }
//            guard var paceNumber = Int(self.paceNumberLabel.text ?? "0") else { return }
            guard var paceNumber = Int(self.coreDataManager?.game?.paceAmount ?? "0") else { return }
            if moneyNumber > paceNumber {
                self.presentAlert(title: "Erreur", message: "Vous ne pouvez pas échanger plus de pas que vous en avez", actionTitle: "Bon ok !")}
            else {
                paceNumber -=  moneyNumber
                guard let previousMoneyNumber = Int(self.moneyNumberLabel.text ?? "0") else { return }
                self.paceNumberLabel.text = "\(paceNumber)"
                self.moneyNumberLabel.text = "\(previousMoneyNumber + moneyNumber)"
            }
            //self.coreDataManager?.game.last?.moneyAmount = "\(moneyNumber)"
            guard var paceToInt = Int((self.coreDataManager?.game?.paceAmount)!) else { return }
            paceToInt -= paceNumber
            print("PaceToInt \(paceToInt)")
            print("PacenumberLabel \(paceNumber)")

            self.coreDataManager?.saveData(moneyamount: "\(paceToInt)", paceAmount: "\(paceNumber)")
            print("new value \(String(describing: self.coreDataManager?.game?.paceAmount))")
            
        }
    }
    
    @IBAction func slotButton1Tapped(_ sender: UIButton) {
        print("Tapped")
    }
}
