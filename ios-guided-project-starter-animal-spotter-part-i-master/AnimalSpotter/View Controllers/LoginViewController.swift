//
//  LoginViewController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 4/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var signInButton: UIButton!
    
    var apiController: APIController?
    var loginType = LoginType.signUp

    override func viewDidLoad() {
        super.viewDidLoad()

        signInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
            signInButton.tintColor = .white
            signInButton.layer.cornerRadius = 8.0
    }
    
    // MARK: - Action Handlers
    
    @IBAction func buttonTapped(_ sender: UIButton) {
       
        //Create a user
        guard let username = usernameTextField.text,
            let password = passwordTextField.text,
              !username.isEmpty,
               !password.isEmpty else{return}
        
        let user = User(username: username, password: password)
        
        if loginType == .signUp {
           signUp(with: user)
        } else {
            signIn(with: user)
        }
        
    }
    
    func signUp(with user: User) {
        apiController?.signUp(with: user, completion: { (error) in
            if let error = error{
                NSLog("Error signing up \(error)")
            } else {
                let alert = UIAlertController(title: "Sign Up Success", message: "Sign in now please", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                
                alert.addAction(okAction)
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: {
                        self.loginType = .signIn
                        self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                        self.signInButton.setTitle("Sign in", for: .normal)
                    })
                }
                
            }
            
        })
        
    }
    
    func signIn(with user: User){
        apiController?.signIn(with: user, completion: { (error) in
            if let error = error {
                NSLog("Error\(error)")
                
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    
    
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        // switch UI between login types
        
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
}
