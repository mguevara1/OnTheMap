//
//  ViewController.swift
//  OnTheMap
//
//  Created by Marco Guevara on 1/07/23.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var emailFieldIsEmpty = true
    var passwordFieldIsEmpty = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        activityIndicator.isHidden = true
    }

    @IBAction func loginButtonAction(_ sender: UIButton) {
        
        login()
    }
    
    @IBAction func signupButtonAction(_ sender: UIButton) {
        
        UIApplication.shared.open(Endpoints.udacitySignUp.url, options: [:], completionHandler: nil)
    }
    
    func disableUI() {
        
        loginButton.isEnabled = false
        loginButton.alpha = 0.25
        emailTextField.isEnabled = false
        passwordTextField.isEnabled = false
        signupButton.isEnabled = false
    }
    
    func enableUI() {
        
        loginButton.isEnabled = true
        loginButton.alpha = 1.0
        emailTextField.isEnabled = true
        passwordTextField.isEnabled = true
        signupButton.isEnabled = true
    }
    
    func login() {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        disableUI()
        ApiClient.login(email: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.enableUI()
            
            if success {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                var errorMessage = error?.localizedDescription
                if errorMessage == "The data couldn’t be read because it is missing." {
                    errorMessage = "Please enter valid credentials"
                }
                self.showAlert(message: errorMessage ?? "Please try again", title: "Login Error")
            }
        }
    }
}
