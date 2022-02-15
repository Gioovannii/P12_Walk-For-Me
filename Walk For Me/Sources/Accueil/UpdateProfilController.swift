//
//  UpdateProfil.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/1/16.
//

import UIKit

/// Update controller
final class UpdateProfilController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var sexeLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    private var sexChoice = ["Homme", "Femme"]
    private var weightChoice = [String]()
    private var currentValue = ""
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        for i in 40...130 {
            weightChoice.append("\(i)")
        }
    }
    
    /// Display an alert to the user
    /// - Parameters:
    ///   - tag: Unique tag
    ///   - title: title description
    ///   - information: what we display
    private func displayAlert(tag: Int, title: String, information: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: title, message: "\n\n\n\n\n\n\n", preferredStyle: .alert)
        
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
            displayAlert(tag: 1, title: "Choisissez votre sexe") { information in
                guard let information = information else { return }
                self.sexeLabel.text = information
                tableView.reloadData()
            }
            
        case 1:
            tableView.deselectRow(at: indexPath, animated: true)
            displayAlert(tag: 2, title: "Choisissez votre poids") { information in
                if information == "Homme" || information == "Femme" {
                    self.presentAlert(title: "Erreur", message: "Veuillez utliser la roulette 🧐", actionTitle: "Compris")
                    return
                }
                guard let information = information else { return }
                self.weightLabel.text = "\(information + " kg") "
                tableView.reloadData()
            }
            
        default:
            print("default case")
            
        }
    }
    
    /// Define a picker
    /// - Parameters:
    ///   - pickerView: pickerView
    ///   - row: selected row
    ///   - component: which component
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            currentValue = checkRow(pickerArray: sexChoice, row: row)
        case 2:
            currentValue = checkRow(pickerArray: weightChoice, row: row)
        default:
            print("Default case")
        }
    }
    
    /// check the row use by the picker
    func checkRow(pickerArray: [String], row: Int) -> String {
        return pickerArray[row]
    }
}
