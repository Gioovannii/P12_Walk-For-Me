//
//  UpdateProfil.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/1/16.
//

import UIKit

class UpdateProfil: UITableViewController {
    
     // MARK: - Outlets

    @IBOutlet weak var sexChoiceButton: UIButton!
    @IBOutlet weak var weightChoiceButton: UIButton!
    
    private var sexChoice = ["Homme", "Femme"]
    private var weightChoice = [String]()
    private var typeValue = ""
   
    
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
        let alert = UIAlertController(title: "Choisissez votre poids", message: "\n\n\n\n\n\n\n", preferredStyle: .alert)
        

        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        pickerFrame.tag = 1
        alert.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("You select " + self.typeValue)
            self.sexChoiceButton.titleLabel?.text = self.typeValue
        }))
        
        present(alert, animated: true)
        }
    }


// MARK: - PickerView Delegate / DataSource

extension UpdateProfil: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weightChoice.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return weightChoice[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
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
