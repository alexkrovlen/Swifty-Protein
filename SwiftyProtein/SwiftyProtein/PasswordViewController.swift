//
//  PasswordViewController.swift
//  SwiftyProtein
//
//  Created by Flash Jessi on 10/21/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {

    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var password: UITextField!
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor(red: 62 / 255, green: 99 / 255, blue: 246 / 255, alpha: 0.8).cgColor,
            UIColor(red: 167 / 255, green: 55 / 255, blue: 246 / 255, alpha: 0.8).cgColor
        ]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.1)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.cornerRadius = 12
        return gradient
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradient.frame = view.bounds
        self.view.layer.insertSublayer(gradient, at: 0)
        
        login.layer.cornerRadius = 6
        login.backgroundColor = UIColor(white: 1, alpha: 0.6)
        
        password.backgroundColor = UIColor(white: 1, alpha: 0.6)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
//        self.navigationController?.navigationBar.backgroundColor = UIColor(white: 1, alpha: 0.6)
//        self.navigationController?.navigationBar.barTintColor =  UIColor(white: 1, alpha: 0.1)
//            = UIColor(white: 1, alpha: 0.6)

    }
    
    
    @IBAction func loginTap(_ sender: UIButton) {
        guard let text = password.text else { return }
        if text == "1234" {
            password.text = nil
            self.performSegue(withIdentifier: "proteinFromPassword", sender: self)
        }
    }
    

}
