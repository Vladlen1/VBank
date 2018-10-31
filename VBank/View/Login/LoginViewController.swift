//
//  LoginViewController.swift
//  VBank
//
//  Created by Vlad Birukov on 05.11.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordRextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var indecator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UITextField!

    let loginRepo = LoginRepo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.settingNavigationBar()
        self.settingShadowButton()
        self.clearTextField()
    }
    
    private func settingNavigationBar() {
        if let navVC = self.navigationController {
            self.title = "Log In"
            navVC.navigationBar.titleTextAttributes = [
                NSAttributedStringKey.foregroundColor : UIColor.white]
            navVC.navigationBar.barTintColor = ColorUtility.navigationBarColor()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func settingShadowButton() {
        self.logInButton.layer.shadowColor = UIColor.black.cgColor
        self.logInButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.logInButton.layer.shadowOpacity = 0.5
    }
    
    
    @IBAction func goToForget(_ sender: UIButton) {
        if let navVc = self.navigationController {
            navVc.pushViewController(ForgotViewController(), animated: true)
        }
    }
    
    @IBAction func goToSignUp(_ sender: UIButton) {
        if let navVC = self.navigationController {
            navVC.pushViewController(SignUpViewController(), animated: true)
        }
    }
    
    @IBAction func goToHome(_ sender: UIButton) {
        self.errorLabel.text = ""
        
        if self.loginTextField.text != "" && self.passwordRextField.text != "" {
            self.indecator.isHidden = false
            self.indecator.startAnimating()
            self.loginRepo.login(email: self.loginTextField.text!, password: self.passwordRextField.text!, controller: self)
        } else {
            self.errorLabel.text = "Empty field email or password"
        }
    }
    
    private func clearTextField() {
        self.loginTextField.text = ""
        self.passwordRextField.text = ""
        self.errorLabel.text = ""
    }
}

