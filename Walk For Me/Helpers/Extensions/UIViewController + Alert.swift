//
//  UIViewController + Alert.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/2/4.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel))

        alert.view.layer.cornerRadius = 70
        alert.view.tintColor = UIColor(red: 0.690, green: 0.469, blue: 0.777, alpha: 1.0)
        alert.view.backgroundColor = UIColor(red: 0.290, green: 0.412, blue: 0.714, alpha: 1.0)
        
        present(alert, animated: true)
    }}
