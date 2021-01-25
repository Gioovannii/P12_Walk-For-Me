//
//  UIViewController.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/1/24.
//

import UIKit

extension UpdateProfil {
    func displayAlert(tag: Int, title: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "Choisissez votre sexe" , message: "\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        pickerFrame.tag = tag
        alertController.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.sexChoiceButton.titleLabel?.text = self.typeValue + " kg"
        })
        
        present(alertController, animated: true) {
            self.sexChoiceButton.titleLabel?.text = self.typeValue
        }
    }
}
