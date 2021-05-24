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
    
    @IBOutlet weak private var wheatQuantityLabel: UILabel!
    @IBOutlet weak private var potatoeQuantityLabel: UILabel!
    @IBOutlet weak private var tomatoesQuantityLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    var coreDataManager: CoreDataManager?
    var currentGame : GameEntity?
    private var currentValue = ""
    private var vegetableChoice = ["céréales", "pomme de terre", "tomates"]
    var gardenImages = [String]()
    
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
        
        print("Tomatoe \(coreDataManager.game?.tomatoeAmount ?? "0")")
        print("Cereales \(coreDataManager.game?.wheatAmount ?? "0")")
        print("patates \(coreDataManager.game?.potatoeAmount ?? "0")")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentAlert(title: "Information", message: "Vous pouvez échanger vos pas contre \n de l'argent grâce au logo échange, ainsi que votre argent en légumes", actionTitle: "OK")
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coreDataManager?.saveCell(images: gardenImages)
    }
    
    func updateUI(total: GameEntity) {
        paceNumberLabel.text = "\(coreDataManager?.game?.paceAmount ?? "0")"
        moneyNumberLabel.text = "\(coreDataManager?.game?.moneyAmount ?? "0")"
        squareMeterNumberLabel.text = "0"
        
        wheatQuantityLabel.text = "\(coreDataManager?.game?.wheatAmount ?? "0")"
        potatoeQuantityLabel.text = "\(coreDataManager?.game?.potatoeAmount ?? "0")"
        tomatoesQuantityLabel.text = "\(coreDataManager?.game?.tomatoeAmount ?? "0")"
        gardenImages = coreDataManager?.game?.imagesCell ?? [String]()
    }
    
    private func displayAlert(tag: Int, title: String, information: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: title, message: "\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        pickerFrame.tag = tag
        alertController.view.addSubview(pickerFrame)
        
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alertController.addAction(UIAlertAction(title: "Annuler", style: .cancel))
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            information(self.currentValue)
        })
        
        present(alertController, animated: true)
    }
    
    // MARK: - Actions
    @IBAction func paceExchangeButtonTapped(_ sender: UIButton) {
        displayExchangeAlert(type: "de pas", placeHolder: "nombre de pas") { moneyNumber in
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
        displayAlert(tag: 1, title: "Que souhaites-tu acheter") { information in
            print(information as Any)
            if information == "" {  self.presentAlert(title: "Alerte", message: "Veuillez selectionner \n un élément", actionTitle: "OK") }
            guard let information = information else { return }
            self.displayExchangeAlert(type: information, placeHolder: "nombre de légumes") { [weak self] amountVegies in
                guard var moneyNumber = Int(self?.coreDataManager?.game?.moneyAmount ?? "0") else { return }
                guard let amountConverted = Int(amountVegies ?? "0") else  { return }
                
                if moneyNumber < amountConverted { self?.presentAlert(title: "Erreur", message: "Vous devez aquerrir plus d'argent", actionTitle: "Compris !")
                } else {
                    moneyNumber -= amountConverted
                    self?.coreDataManager?.saveVegetable(vegetableType: information, vegetableAmount: "\(amountConverted)", moneyAmount: "\(moneyNumber)")
                    self?.moneyNumberLabel.text = self?.coreDataManager?.game?.moneyAmount
                    switch information {
                    case "céréales":
                        self?.wheatQuantityLabel.text = self?.coreDataManager?.game?.wheatAmount
                    case "pomme de terre":
                        self?.potatoeQuantityLabel.text = self?.coreDataManager?.game?.potatoeAmount
                    case "tomates":
                        self?.tomatoesQuantityLabel.text = self?.coreDataManager?.game?.tomatoeAmount
                    default:
                        break
                    }
                }
            }
        }
    }
    
    // MARK: - Farmer slot
    
    @IBAction func slotButton1Tapped(_ sender: UIButton) {
        guard let wheat = coreDataManager?.game?.wheatAmount else {
            coreDataManager?.saveVegetable(vegetableType: "céréales", vegetableAmount: "0", moneyAmount: coreDataManager?.game?.moneyAmount ?? "0")
            return
        }
        
        guard let potatoes = coreDataManager?.game?.potatoeAmount else { coreDataManager?.saveVegetable(vegetableType: "pomme de terre", vegetableAmount: "0", moneyAmount: coreDataManager?.game?.moneyAmount ?? "0")
            return }
       
        guard let tomatoes = coreDataManager?.game?.tomatoeAmount else { coreDataManager?.saveVegetable(vegetableType: "tomates", vegetableAmount: "0", moneyAmount: coreDataManager?.game?.moneyAmount ?? "0")
            return
        }
    

        print(wheat)
        print(potatoes)
        print(tomatoes)
        displayAlert(tag: 1, title: "Que souhaitez vous planter ?") { information in
            print("Info : \(String(describing: information))")
            guard let information = information else { return }

            switch information {
            case "céréales":
                self.gardenImages.append("homeImage4Wheat")
            case "pomme de terre":
                self.gardenImages.append("homeImage5Potatoe")
            case "tomates":
                self.gardenImages.append("homeImage6Tomato")
                
            default:
                break
            }
            self.collectionView.reloadData()
        }
        print("Start planting")
    }
}

// MARK: - Picker Delegate

extension GameViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return vegetableChoice.count }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return vegetableChoice[row] }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 { currentValue = checkRow(pickerArray: vegetableChoice, row: row) }
    }
    
    func checkRow(pickerArray: [String], row: Int) -> String {
        return pickerArray[row]
    }
}

// MARK: - Collection Delegate

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gardenImages.isEmpty ? 0 : gardenImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",for: indexPath) as? VegetableCell else { return UICollectionViewCell() }
        
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        cell.vegetableImageView.image = UIImage(named: gardenImages[indexPath.row])
        return cell
    }
}


