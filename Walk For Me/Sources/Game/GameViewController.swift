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
    
    private var coreDataManager: CoreDataManager?
    private var currentValue = ""
    private var vegetableChoice = ["céréales", "pomme de terre", "tomates"]
    private var gardenImages = [String]()
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        coreDataManager = CoreDataManager(coreDataStack: appDelegate.coreDataStack)
        guard let coreDataManager = coreDataManager else { return }
        self.coreDataManager = coreDataManager
        
        guard let total = coreDataManager.game else { return }
        updateUI(total: total)
        
        print("Cereales \(coreDataManager.game?.wheatAmount ?? "0")")
        print("patates \(coreDataManager.game?.potatoeAmount ?? "0")")
        print("Tomatoe \(coreDataManager.game?.tomatoeAmount ?? "0")")
        
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
        
        alertController.addAction(UIAlertAction(title: "Annuler", style: .cancel) { _ in
            self.currentValue = ""
        })
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            information(self.currentValue)
        })
        
        present(alertController, animated: true)
    }
    
    // MARK: - Actions
    @IBAction func paceExchangeButtonTapped(_ sender: UIButton) {
        displayExchangeAlert(type: "pas", placeHolder: "nombre de pas") { moneyNumber in
            
            guard let moneyNumberExchange = Int(moneyNumber ?? "0") else { return }
            guard var currentMonney = Int(self.coreDataManager?.game?.moneyAmount ?? "0") else { return }
            guard var currentPaceNumber = Int(self.coreDataManager?.game?.paceAmount ?? "0") else { return }
            
            if moneyNumberExchange > currentPaceNumber { self.presentAlert(
                title: "Erreur", message: "Vous ne pouvez pas échanger plus de pas que vous en avez",
                actionTitle: "Bon ok !")}
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
        displayAlert(tag: 1, title: "Que souhaites-tu acheter ?") { information in
            guard var info = information else { return }
            if information == "" { info = "céréales"
                
            } else { info = information ?? "" }
            self.displayExchangeAlert(type: info, placeHolder: "Nombre de légumes") { [weak self] amountVegies in
                
                guard amountVegies != "" else {
                    self?.presentAlert(title: "Attention", message: "Vous ne souhaitez rien acheter ?", actionTitle: "C'est OK")
                    self?.currentValue = ""
                    return
                }
                
                guard var moneyNumber = Int(self?.coreDataManager?.game?.moneyAmount ?? "0") else { return }
                guard let amountConverted = Int(amountVegies ?? "0") else  { return }
                
                if moneyNumber < amountConverted { self?.presentAlert(title: "Erreur", message: "Vous devez aquerrir plus d'argent", actionTitle: "Compris !")
                } else {
                    if info == "" { info = "céréales" }
                    moneyNumber -= amountConverted
                    
                    self?.coreDataManager?.saveVegetable(vegetableType: info, vegetableAmount: "\(amountConverted)", moneyAmount: "\(moneyNumber)", isPlanting: false)
                    self?.moneyNumberLabel.text = self?.coreDataManager?.game?.moneyAmount
                    switch information {
                    case "":
                        fallthrough
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
                self?.currentValue = ""
            }
        }
    }
    
    // MARK: - Farmer slot
    
    @IBAction func slotButton1Tapped(_ sender: UIButton) {
        
        guard var wheatAmount = Int(coreDataManager?.game?.wheatAmount ?? "0") else { return }
        guard let potatoeAmount = Int(coreDataManager?.game?.potatoeAmount ?? "0") else { return }
        guard let tomatoeAmount = Int(coreDataManager?.game?.tomatoeAmount ?? "0") else { return }
        
        displayAlert(tag: 1, title: "Que souhaitez vous planter ?") { information in
            guard var info = information else { return }
            if information == "" { info = "céréales"} else { info = information ?? "" }
            
            self.displayExchangeAlert(type: info, placeHolder: "Nombre de légumes") { amount in
                
                guard amount != "" else {
                    self.presentAlert(title: "Attention", message: "Vous ne souhaitez rien acheter ?", actionTitle: "C'est OK")
                    self.currentValue = ""
                    return
                }
                
                guard let amount = Int(amount ?? "0") else { return }
                switch information {
                case "":
                    fallthrough
                case "céréales":
                    print("cereales \(wheatAmount)")
                    self.checkIfOverAmount(amount: amount, product: wheatAmount, image: "homeImage4Wheat")
                    wheatAmount -= amount
                    self.coreDataManager?.saveVegetable(vegetableType: "céréales", vegetableAmount: "\(wheatAmount)", moneyAmount: self.coreDataManager?.game?.moneyAmount ?? "0", isPlanting: true)
                    //let total = wheatAmount - amount
                    
                    self.wheatQuantityLabel.text = "\(String(describing: self.coreDataManager?.game?.wheatAmount))"
                case "pomme de terre":
                    self.checkIfOverAmount(amount: amount, product: potatoesAmount, image: "homeImage5Potatoe")
                case "tomates":
                    self.checkIfOverAmount(amount: amount, product: tomatoesAmount, image: "homeImage6Tomato")
                default:
                    break
                }
                self.currentValue = ""
                self.collectionView.reloadData()
            }
        }
    }
    
    func checkIfOverAmount(amount: Int, product: Int, image: String) {
        if amount > product {
            presentAlert(title: "Attention", message: "Il te faut plus ", actionTitle: "OK")
        } else {
            gardenImages.append(contentsOf: repeatElement(image, count: amount))
            coreDataManager?.saveCell(images: gardenImages)
            collectionView.reloadData()
            
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected item at \(indexPath.row)")
    }
}


