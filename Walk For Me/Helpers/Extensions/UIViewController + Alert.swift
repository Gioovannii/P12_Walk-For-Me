//
//  UIViewController + Alert.swift
//  Walk For Me
//
//  Created by Giovanni Gaffé on 2021/2/4.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel))

        alert.view.layer.cornerRadius = 70
        alert.view.tintColor = Constant.Color.pink
        alert.view.backgroundColor = UIColor(red: 0.290, green: 0.412, blue: 0.714, alpha: 1.0)

        present(alert, animated: true)
    }
    
    func displayExchangeAlert(handlerExchangeName: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: "Combien de pas veut tu échanger", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "nombre de pas"
        }
        let action = UIAlertAction(title: "Echanger maintenant", style: .default, handler: { _ in
            guard let textField = alert.textFields else { return }
            handlerExchangeName(textField[0].text)
        })
        alert.view.layer.cornerRadius = 70
        alert.view.tintColor = Constant.Color.pink
        alert.view.backgroundColor = UIColor(red: 0.290, green: 0.412, blue: 0.714, alpha: 1.0)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}
