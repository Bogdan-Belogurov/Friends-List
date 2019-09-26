//
//  BaseViewController.swift
//  Friends List
//
//  Created by Bogdan Belogurov on 25/09/2019.
//  Copyright © 2019 Bogdan Belogurov. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    func showAlert(title: String? = nil, message: String? = nil) {
        DispatchQueue.main.async {
            if let currentAlert = self.presentedViewController as? UIAlertController {
                currentAlert.title = title
                return
            }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
