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
 
    var sexChoice = ["Homme", "Femme"]
    var weightChoice = [String]()
    var pickerView = UIPickerView()
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

    @IBAction func changeSexPressed(_ sender: Any) {
        
    }
    
    @IBAction func weightButtonPressed(_ sender: Any) {
        
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


