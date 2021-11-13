//
//  LoginViewController.swift
//  SwiftyProtein
//
//  Created by Flash Jessi on 10/20/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {

    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var touchIDButton: UIButton!
    let context = LAContext()
    
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
        
        touchIDButton.backgroundColor = UIColor(white: 1, alpha: 0.6)
        
        login.layer.cornerRadius = 16
        login.backgroundColor = UIColor(white: 1, alpha: 0.6)
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            print("touchIDButton yes")
             touchIDButton.isHidden = false
            print(context.biometryType)
            if context.biometryType == .faceID {
                touchIDButton.setImage(UIImage(named: "face_id"), for: .normal)
                touchIDButton.layer.cornerRadius = 16
            } else {
                touchIDButton.setImage(UIImage(named: "touch_id"), for: .normal)
                touchIDButton.layer.cornerRadius = touchIDButton.frame.width / 2
            }
        } else {
            print("touchIDButton no")
             touchIDButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func loginTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "proteinList", sender: self)
    }
    
    @IBAction func touchID(_ sender: UIButton) {
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            let reason = "Please authorize with Touch ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
                DispatchQueue.main.async {
                    if success {
                        print("corect")
                        self?.performSegue(withIdentifier: "proteinList", sender: self)
                    } else {
                        print("not corect")
//                        let alert = UIAlertController(title: "Authentication faild", message: "Your could not be verified; please try again.", preferredStyle: .alert)
//                        let action = UIAlertAction(title: "Ok", style: .default)
//                        alert.addAction(action)
//                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } else {
            print("not access")
            touchIDButton.isHidden = true
//            let alert = UIAlertController(title: "Touch ID unavailable", message: "Your device is not configured for biometric authentication", preferredStyle: .alert)
//            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
//                self.performSegue(withIdentifier: "password", sender: nil)
//            }
//            alert.addAction(action)
//            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
