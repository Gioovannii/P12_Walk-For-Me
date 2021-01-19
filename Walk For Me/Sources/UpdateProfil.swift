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
    
  
}
