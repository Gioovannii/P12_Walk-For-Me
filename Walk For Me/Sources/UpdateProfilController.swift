//
//  UpdateProfil.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/1/16.
//

import UIKit

class UpdateProfilController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var sexChoiceButton: UIButton!
    @IBOutlet weak var weightChoiceButton: UIButton!
    
    private var sexChoice = ["Homme", "Femme"]
    private var weightChoice = [String]()
    var typeValue = ""
    
    
    // MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        for i in 40...130 {
            weightChoice.append("\(i)")
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func changeSexPressed(_ sender: Any) {
        
        displayAlert(tag: 1) { information in
            self.sexChoiceButton.setTitle(information, for: .normal)
        }
    }
    
    @IBAction private func weightButtonPressed(_ sender: Any) {
        displayAlert(tag: 2) { information  in
            self.weightChoiceButton.setTitle(information! + " kg", for: .normal)
        }
    }
    
    func displayAlert(tag: Int, information: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "Choisissez votre sexe" , message: "\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        pickerFrame.tag = tag
        alertController.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            information(self.typeValue)
        })
        
        present(alertController, animated: true)
    }
}


// MARK: - PickerView Delegate / DataSource

extension UpdateProfil: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return sexChoice.count
        } else if pickerView.tag == 2 {
            return weightChoice.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return sexChoice[row]
        } else if pickerView.tag == 2 {
            return weightChoice[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            switch row {
            case 0:
                typeValue = "Homme"
            case 1:
                typeValue = "Femme"
            default:
                typeValue = "Something"
            }
        } else if pickerView.tag == 2 {
            if row == 0 {
                typeValue = "40"
            } else if row == 1 {
                typeValue = "41"
            } else if row == 2 {
                typeValue = "42"
            } else if row == 3 {
                typeValue = "43"
            } else if row == 4 {
                typeValue = "44"
            } else if row == 5 {
                typeValue = "45"
            } else if row == 6 {
                typeValue = "46"
            } else if row == 7 {
                typeValue = "47"
            }
        }
    }
}
