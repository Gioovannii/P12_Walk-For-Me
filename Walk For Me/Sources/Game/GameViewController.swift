//
//  GameViewController.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/2/11.
//

import UIKit

final class GameViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak private var slotButton1: UIButton!
    @IBOutlet weak private var slotButton2: UIButton!
    @IBOutlet weak private var slotButton3: UIButton!
    @IBOutlet weak private var slotButton4: UIButton!
    
    @IBOutlet weak private var paceNumberLabel: UILabel!
    @IBOutlet weak private var moneyNumberLabel: UILabel!
    @IBOutlet weak private var squareMeterNumberLabel: UILabel!
    @IBOutlet weak private var tomatoesQuantityLabel: UILabel!
    @IBOutlet weak private var potatoeQuantityLabel: UILabel!
    @IBOutlet weak private var wheatQuantityLAbel: UILabel!
    
    private let vegetableChoice = ["Céréales", "Pomme de terre", "Tomates"]
    // MARK: - Properties
    var coreDataManager: CoreDataManager?
    var currentGame : GameEntity?
    private var currentValue = ""
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
        
        coreDataManager = CoreDataManager(coreDataStack: sceneDelegate.coreDataStack)
        guard let coreDataManager = coreDataManager else { return }
        self.coreDataManager = coreDataManager
        
        guard let total = coreDataManager.game else { return }
        updateUI(total: total)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentAlert(title: "Information", message: "Vous pouvez échanger vos pas contre \n de l'argent grâce au logo échange, ainsi que votre argent en legumes", actionTitle: "OK")
    }
    
    func updateUI(total: GameEntity) {
        paceNumberLabel.text = "\(coreDataManager?.game?.paceAmount ?? "0")"
        moneyNumberLabel.text = "\(coreDataManager?.game?.moneyAmount ?? "0")"
        squareMeterNumberLabel.text = "0"
        tomatoesQuantityLabel.text = "0"
        potatoeQuantityLabel.text = "0"
        wheatQuantityLAbel.text = "0"
    }
    
    
    private func displayAlert(tag: Int, title: String, information: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: title, message: "\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        pickerFrame.tag = tag
        alertController.view.addSubview(pickerFrame)
        
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            information(self.currentValue)
        })
        
        present(alertController, animated: true)
    }
    
    // MARK: - Actions
    @IBAction func paceExchangeButtonTapped(_ sender: UIButton) {
        displayExchangeAlert { moneyNumber in
            // We need 3 things current monney / current pace and money to exchange
            guard let moneyNumberExchange = Int(moneyNumber ?? "0") else { return }
            guard var currentMonney = Int(self.coreDataManager?.game?.moneyAmount ?? "0") else { return }
            guard var currentPaceNumber = Int(self.coreDataManager?.game?.paceAmount ?? "0") else { return }
            // Check if exchange more than needed
            if moneyNumberExchange > currentPaceNumber {
                self.presentAlert(title: "Erreur", message: "Vous ne pouvez pas échanger plus de pas que vous en avez", actionTitle: "Bon ok !")}
            else {
                guard let previousMoneyNumber = Int(self.coreDataManager?.game?.moneyAmount ?? "0") else { return }
                currentPaceNumber -=  moneyNumberExchange
                currentMonney += moneyNumberExchange
                
                self.paceNumberLabel.text = "\(currentPaceNumber)"
                self.moneyNumberLabel.text = "\(previousMoneyNumber + moneyNumberExchange)"
                
                self.coreDataManager?.saveData(paceAmount: "\(currentPaceNumber)", moneyAmount: "\(previousMoneyNumber + moneyNumberExchange)")
            }
        }
    }
    
    @IBAction func moneyExchangeButtonTapped(_ sender: UIButton) {
        print("Let's exchange")
        
        displayAlert(tag: 1, title: "Choisis") { information in
           print(information)
        }
    }
    
    
    
    @IBAction func slotButton1Tapped(_ sender: UIButton) {
        print("Start planting")
    }
}

extension GameViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vegetableChoice.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return vegetableChoice[row]
    }
}
