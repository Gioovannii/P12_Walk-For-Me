//
//  UpdateProfil.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/1/16.
//

import UIKit

class UpdateProfilController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var sexeLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    private var sexChoice = ["Homme", "Femme"]
    private var weightChoice = [String]()
    private var currentValue = ""
    
    
    // MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        for i in 40...130 {
            weightChoice.append("\(i)")
        }
    }
    
    private func displayAlert(tag: Int, information: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "Choisissez votre sexe" , message: "\n\n\n\n\n\n\n", preferredStyle: .alert)
        
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
}

// MARK: - PickerView Delegate / DataSource

extension UpdateProfilController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == 1 ? sexChoice.count : weightChoice.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == 1 ? sexChoice[row] : weightChoice[row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            tableView.deselectRow(at: indexPath, animated: true)
            displayAlert(tag: 1) { information in
                self.sexeLabel.text = information
                tableView.reloadData()
            }
        case 1:
            displayAlert(tag: 2) { information in
                guard let information = information else { return }
                self.weightLabel.text = "\(information + " kg") "
                tableView.reloadData()
            }
        default:
            print("default case")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      
        if pickerView.tag == 1 {
            currentValue = checkRow(pickerArray: sexChoice, row: row)

        } else if pickerView.tag == 2 { currentValue = checkRow(pickerArray: weightChoice, row: row) }
    }
    
    func checkRow(pickerArray: [String], row: Int) -> String {
        return pickerArray[row]
    }
}
