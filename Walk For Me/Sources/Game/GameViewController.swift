//
//  GameViewController.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/2/11.
//

import UIKit

/// Game controller
final class GameViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak private var slotButton1: UIButton!
    @IBOutlet weak private var slotButton2: UIButton!
    @IBOutlet weak private var slotButton3: UIButton!
    @IBOutlet weak private var slotButton4: UIButton!
    
    @IBOutlet weak var buyVegiesButtonTapped: UIButton!
    
    @IBOutlet weak private var moneyNumberLabel: UILabel!
    @IBOutlet weak private var wheatQuantityLabel: UILabel!
    @IBOutlet weak private var potatoeQuantityLabel: UILabel!
    @IBOutlet weak private var tomatoesQuantityLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var askForPlantButtonTapped: UIButton!
    
    
    // MARK: - Properties
    private var coreDataManager: CoreDataManager?
    private var timer: Timer?
    private var game = Game()
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        coreDataManager = CoreDataManager(coreDataStack: appDelegate.coreDataStack)
        guard let coreDataManager = coreDataManager else { return }
        self.coreDataManager = coreDataManager
        
        
        guard let total = coreDataManager.game else { return }
        print(coreDataManager)
        moneyNumberLabel.text = coreDataManager.game?.paceAmount ?? "0"
        updateUI(total: total)
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        buyVegiesButtonTapped.layer.borderWidth = 1
        buyVegiesButtonTapped.layer.borderColor = UIColor.gray.cgColor
        buyVegiesButtonTapped.layer.cornerRadius = 5
        
        askForPlantButtonTapped.layer.borderWidth = 1
        askForPlantButtonTapped.layer.borderColor = UIColor.gray.cgColor
        askForPlantButtonTapped.layer.cornerRadius = 5
        
    }
    
    // MARK: - Load informations
    
    func updateUI(total: GameEntity) {
        moneyNumberLabel.text = coreDataManager?.game?.paceAmount ?? "0"
        
        wheatQuantityLabel.text = "\(coreDataManager?.game?.wheatAmount ?? "0")"
        potatoeQuantityLabel.text = "\(coreDataManager?.game?.potatoeAmount ?? "0")"
        tomatoesQuantityLabel.text = "\(coreDataManager?.game?.tomatoeAmount ?? "0")"
        game.gardenImages = coreDataManager?.game?.imagesCell ?? [String]()
        game.gardenImagesTime = coreDataManager?.game?.gardenTimeInterval ?? [String]()
    }
    
    private func displayAlert(tag: Int, title: String, information: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: title, message: "\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        pickerFrame.tag = tag
        alertController.view.addSubview(pickerFrame)
        
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alertController.addAction(UIAlertAction(title: "Annuler", style: .cancel) { _ in self.game.currentValue = "" })
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in information(self.game.currentValue) })
        present(alertController, animated: true)
    }
    
    // MARK: - Money Exchange
    
    @IBAction func moneyExchangeButtonTapped(_ sender: UIButton) {
        displayAlert(tag: 2, title: "Que souhaites-tu acheter ?") { information in
            guard var info = information else { fatalError() }
            if information == "" { info = Constant.wheat } else { info = information ?? "" }
            
            self.displayExchangeAlert(type: info, placeHolder: "Nombre de légumes") { [weak self] amountVegies in
                guard amountVegies != "" else {
                    self?.presentAlert(title: "Attention", message: "Vous ne souhaitez rien acheter ?", actionTitle: "C'est OK")
                    self?.game.currentValue = ""
                    return
                }
                
                guard var moneyNumber = Int(self?.coreDataManager?.game?.paceAmount ?? "0"),
                      let amountConverted = Int(amountVegies ?? "0")  else { return }
                
                guard let total = self?.calculateAmount(info: info, amountConverted: amountConverted) else { return }
                guard moneyNumber >= total else {
                    self?.presentAlert(title: "Attention", message: "Vous ne pouvez pas acheter ", actionTitle: "OK")
                    
                    return
                }
                moneyNumber -= total
                self?.coreDataManager?.saveVegetable(vegetableType: info, vegetableAmount: "\(amountConverted)", moneyAmount: "\(moneyNumber)", isPlanting: false)
                
                self?.moneyNumberLabel.text = self?.coreDataManager?.game?.paceAmount
                
                switch information {
                case "":
                    fallthrough
                case Constant.wheat:
                    self?.wheatQuantityLabel.text = self?.coreDataManager?.game?.wheatAmount
                case Constant.potatoe:
                    self?.potatoeQuantityLabel.text = self?.coreDataManager?.game?.potatoeAmount
                case Constant.tomatoe:
                    self?.tomatoesQuantityLabel.text = self?.coreDataManager?.game?.tomatoeAmount
                default:
                    break
                }
            }
            self.game.currentValue = ""
        }
    }
    
    func calculateAmount(info: String, amountConverted: Int) -> Int {
        var total = 0
        switch info {
        case Constant.wheat:
            total = amountConverted * 10
        case Constant.potatoe:
            total = amountConverted * 20
        case Constant.tomatoe:
            total = amountConverted * 30
        default:
            break
        }
        return total
    }
    
    // MARK: - Farmer slot
    
    @IBAction func slotButton1Tapped(_ sender: UIButton) {
        
        guard var wheatAmount = Int(coreDataManager?.game?.wheatAmount ?? "0") else { return }
        guard var potatoeAmount = Int(coreDataManager?.game?.potatoeAmount ?? "0") else { return }
        guard var tomatoeAmount = Int(coreDataManager?.game?.tomatoeAmount ?? "0") else { return }
        
        displayAlert(tag: 1, title: "Que souhaitez vous planter ?") { information in
            guard var info = information else { return }
            if information == "" { info = Constant.wheat } else { info = information ?? "" }
            
            self.displayExchangeAlert(type: info, placeHolder: "Nombre de légumes") { amount in
                
                guard amount != "" else {
                    self.presentAlert(title: "Attention", message: "Vous ne souhaitez rien acheter ?", actionTitle: "C'est OK")
                    self.game.currentValue = ""
                    return
                }
                
                guard let amount = Int(amount ?? "0") else { return }
                self.game.gardenImagesCount = amount
                switch information {
                case "":
                    fallthrough
                case Constant.wheat:
                    if self.checkIfOverAmount(amount: amount, product: wheatAmount, image: Constant.wheatImage) {
                        wheatAmount -= amount
                        
                        self.coreDataManager?.saveVegetable(vegetableType: Constant.wheat, vegetableAmount: "\(wheatAmount)", moneyAmount: self.coreDataManager?.game?.paceAmount ?? "0", isPlanting: true)
                        
                        self.wheatQuantityLabel.text = self.coreDataManager?.game?.wheatAmount
                    }
                case Constant.potatoe:
                    if self.checkIfOverAmount(amount: amount, product: potatoeAmount, image: Constant.potatoeImage) {
                        potatoeAmount -= amount
                        
                        self.coreDataManager?.saveVegetable(vegetableType: Constant.potatoe, vegetableAmount: "\(potatoeAmount)", moneyAmount: self.coreDataManager?.game?.paceAmount ?? "0", isPlanting: true)
                        self.potatoeQuantityLabel.text = self.coreDataManager?.game?.potatoeAmount
                    }
                case Constant.tomatoe:
                    if self.checkIfOverAmount(amount: amount, product: tomatoeAmount, image: Constant.tomatoeImage) {
                        tomatoeAmount -= amount
                        
                        self.coreDataManager?.saveVegetable(vegetableType: Constant.tomatoe, vegetableAmount: "\(tomatoeAmount)", moneyAmount: self.coreDataManager?.game?.paceAmount ?? "0", isPlanting: true)
                        self.potatoeQuantityLabel.text = self.coreDataManager?.game?.tomatoeAmount
                    }
                default:
                    break
                }
                self.game.currentValue = ""
                self.collectionView.reloadData()
            }
        }
    }
    
    func checkIfOverAmount(amount: Int, product: Int, image: String) -> Bool {
        if amount > product {
            presentAlert(title: "Attention", message: "Il t'en faut plus ", actionTitle: "OK")
            return false
        } else {
            game.gardenImages.append(contentsOf: repeatElement(image, count: amount))
            createTimer()
            coreDataManager?.saveCell(images: game.gardenImages)
            collectionView.reloadData()
            return true
        }
    }
}

// MARK: - Timer

extension GameViewController {
    @objc func updateTimer() {
        if let fireDateDescription = timer?.fireDate.description { print("*\(fireDateDescription)") }
    }
    
    func createTimer() {
        
        let utcTime = DateFormatter.getDateToString(from: Date())
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: false)
        
        timer.tolerance = 0.1
        self.timer = timer
        
        game.gardenImagesTime.append(contentsOf: repeatElement(utcTime, count: game.gardenImagesCount))
        coreDataManager?.saveTimeInterval(gardenTimeInterval: game.gardenImagesTime)
    }
}

// MARK: - Picker Data Source / Delegate

extension GameViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 { return game.vegetableChoice.count } else { return game.vegetableChoiceMoney.count }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 { return game.vegetableChoice[row] } else { return game.vegetableChoiceMoney[row] }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 { game.currentValue = checkRow(pickerArray: game.vegetableChoice, row: row) } else {
            game.currentValue = checkRow(pickerArray: game.vegetableChoice, row: row)
        }
    }
}

func checkRow(pickerArray: [String], row: Int) -> String { return pickerArray[row] }

// MARK: - Collection DataSource / Delegate

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.gardenImages.isEmpty ? 0 : game.gardenImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",for: indexPath) as? VegetableCell else { return UICollectionViewCell() }
        
        let currentImageDate = DateFormatter.getDateFromString(date: game.gardenImagesTime[indexPath.row])
        let currentDate = abs(Double(currentImageDate.timeIntervalSinceNow))
        let timeInSecond = currentDate.intFromTimeInterval()
        
        switch game.gardenImages[indexPath.row] {
        case Constant.wheatImage:
            if timeInSecond > 1 {
                cell.layer.borderColor = UIColor.green.cgColor
                }
        case Constant.potatoeImage:
            if timeInSecond > 2 {
                cell.layer.borderColor = UIColor.green.cgColor
                }
        case Constant.tomatoe:
            if timeInSecond > 3 {
                cell.layer.borderColor = UIColor.green.cgColor
                }
        default:
            break
        }
    
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        cell.vegetableImageView.image = UIImage(named: game.gardenImages[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dateSaved = DateFormatter.getDateFromString(date: game.gardenImagesTime[indexPath.row])
        let timeInSecondsSinceNow = abs(Double(dateSaved.timeIntervalSinceNow))
        let time = timeInSecondsSinceNow.intFromTimeInterval()
        let currentImageType = game.gardenImages[indexPath.row]
        checkimages(currentImageType: currentImageType, currentTime: time, row: indexPath.row, indexPath: indexPath)
    }
    
    func checkimages(currentImageType: String, currentTime: Int, row: Int, indexPath: IndexPath) {
        /// Time for each vegetable
        let targetWheat = 1
        let targetPotatoe = 2
        let targetTomatoe = 3
        
        switch currentImageType {
        case Constant.wheatImage:
            if currentTime >= targetWheat {
                game.gardenImages.remove(at: row)
                game.gardenImagesTime.remove(at: row)
                coreDataManager?.removeImageAndTime(index: row)
                coreDataManager?.saveExperience(xp: 10)
                collectionView.reloadData()
            } else {
                presentAlert(title: "Attention", message: "vous devez attendre encore \(targetWheat - currentTime) min pour collecter", actionTitle: "Compris")}
            
        case Constant.potatoeImage:
            if currentTime >= targetPotatoe {
                game.gardenImages.remove(at: row)
                game.gardenImagesTime.remove(at: row)
                coreDataManager?.removeImageAndTime(index: row)
                coreDataManager?.saveExperience(xp: 20)
                collectionView.reloadData()
            } else {
                presentAlert(title: "Attention", message: "vous devez attendre encore \(targetPotatoe - currentTime) min pour collecter", actionTitle: "Compris")}
        case Constant.tomatoeImage:
            if currentTime >= targetTomatoe {
                game.gardenImages.remove(at: row)
                game.gardenImagesTime.remove(at: row)
                coreDataManager?.removeImageAndTime(index: row)
                coreDataManager?.saveExperience(xp: 30)
                collectionView.reloadData()
            } else {
                presentAlert(title: "Attention", message: "vous devez attendre encore \(targetTomatoe - currentTime) min pour collecter", actionTitle: "Compris")}
        default:
            return
        }
    }
}


