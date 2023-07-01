//
//  UIViewController+Extensions.swift
//  OnTheMap
//
//  Created by Marco Guevara on 1/07/23.
//

import UIKit

extension UIViewController {
    
    func showAlert(message: String, title: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    
    func openLink(_ url: String) {
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else {
            showAlert(message: "Cannot open link", title: "Invalid Link")
            return
        }
        UIApplication.shared.open(url, options: [:])
    }
}
