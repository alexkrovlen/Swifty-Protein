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

    @IBOutlet weak var touchIDButton: UIButton!
    let context = LAContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            print("touchIDButton yes")
             touchIDButton.isHidden = false
        } else {
            print("touchIDButton no")
             touchIDButton.isHidden = true
        }
    }
    

    @IBAction func loginTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "password", sender: self)
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
