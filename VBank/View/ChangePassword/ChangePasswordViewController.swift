//
//  ChangePasswordViewController.swift
//  VBank
//
//  Created by Vlad Birukov on 05.11.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var changeButton: UIButton!
    
    var delegate: BackDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.settingNavigationBar()
        self.settingShadowButton()
    }
    
    private func settingNavigationBar() {
        if let navVC = self.navigationController {
            self.title = "Change password"
            navVC.navigationBar.titleTextAttributes = [
                NSAttributedStringKey.foregroundColor : UIColor.white]
            navVC.navigationBar.barTintColor = ColorUtility.navigationBarColor()
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close_gray_icon"), style: .plain, target: self, action: #selector(dismiss(_:)))
            navVC.navigationBar.tintColor = UIColor.white
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
        self.changeButton.layer.shadowColor = UIColor.black.cgColor
        self.changeButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.changeButton.layer.shadowOpacity = 0.5
    }
    
    @IBAction func change(_ sender: UIButton) {
        self.checkCorrectlyData()
    }
    
    @objc func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func checkCorrectlyData() {
        if self.passwordTextField.text != "" && self.confirmNewPasswordTextField.text != "" && self.newPasswordTextField.text != "" {
            self.checkPassword()
        } else {
            if self.presentedViewController == nil {
                let alert = UIAlertController(title: "Warning!", message: "All fields required", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    return
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func checkPassword() {
        let oldPasswordValid = self.validatePassword(password: self.passwordTextField.text)
        let newPasswordValid = self.validatePassword(password: self.newPasswordTextField.text)
        
        if oldPasswordValid == true && newPasswordValid == true {
            if self.newPasswordTextField.text == self.confirmNewPasswordTextField.text && self.passwordTextField.text != nil && self.newPasswordTextField.text != nil {
                if self.newPasswordTextField.text != self.passwordTextField.text {
                    self.indicator.isHidden = false
                    self.indicator.startAnimating()
                    
                    let repo = ChangPasswordRepo()
                    
                    repo.change(oldPassword: self.passwordTextField.text!, newPassword: self.newPasswordTextField.text!, controller: self)
                } else {
                    if self.presentedViewController == nil {
                        let alert = UIAlertController(title: "Error!", message: "New password must be different from old password.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                            return
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            } else  {
                if self.presentedViewController == nil {
                    let alert = UIAlertController(title: "Error!", message: "New password does not match with confirm new password.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                        return
                    }))

                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else if oldPasswordValid == false {
            if self.presentedViewController == nil {
                let alert = UIAlertController(title: "Error!", message: "Invalid old password. The password must be at least 8 characters in length. Must contain at least one letter in upper case, one in lower case and one digit.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    return
                }))

                self.present(alert, animated: true, completion: nil)
            }
        } else if newPasswordValid == false {
            if self.presentedViewController == nil {
                let alert = UIAlertController(title: "Error!", message: "Invalid new password. The password must be at least 8 characters in length. Must contain at least one letter in upper case, one in lower case and one digit.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    return
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            if self.presentedViewController == nil {
                let alert = UIAlertController(title: "Error!", message: "Invalid old password and new password. The password must be at least 8 characters in length. Must contain at least one letter in upper case, one in lower case and one digit.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    return
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func validatePassword(password: String?) -> Bool {
        if let password = password {
            let passwordRegEx = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
            
            let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
            
            if passwordTest.evaluate(with: password) {
                return true
            }
        }
        return false
    }
}
