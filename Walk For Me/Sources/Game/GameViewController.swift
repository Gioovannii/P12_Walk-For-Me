//
//  GameViewController.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/2/11.
//

import UIKit

@available(iOS 13.0, *)
class GameViewController: UIViewController {
    
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
    
    @IBOutlet weak var viewFarmer: UIView!
    
    var coreDataManager: CoreDataManager?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
        coreDataManager = CoreDataManager(coreDataStack: sceneDelegate.coreDataStack)
        guard let coredataManager = coreDataManager else { return }
        
        var total = 0
        for user in coredataManager.users {
            if let pace = user.pace {
                guard let paceNumber = Int(pace) else { return }
                total += paceNumber
                print(total)
            } else {
                print("Unwrapped failed")
            }
        }
   
        paceNumberLabel.text = "\(total)"
        moneyNumberLabel.text = "0"
        squareMeterNumberLabel.text = "0"
        tomatoesQuantityLabel.text = "0"
        potatoeQuantityLabel.text = "0"
        wheatQuantityLAbel.text = "0"
    }
    
    
    @IBAction func slotButton1Tapped(_ sender: Any) {
        print("Tapped")
    }
}
