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
   
}
