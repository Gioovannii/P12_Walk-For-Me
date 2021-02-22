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
        
        alert.view.tintColor = UIColor.purple
        alert.view.backgroundColor = UIColor.cyan
        alert.view.layer.cornerRadius = 70
        
        present(alert, animated: true)
    }}
