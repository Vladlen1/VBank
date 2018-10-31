//
//  SignUpViewController.swift
//  VBank
//
//  Created by Vlad Birukov on 05.11.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var firstNameTExtField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mediumNameTextField: UITextField!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var birthdayButton: UIButton!
    
    @IBOutlet weak var createAccount: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let arrayTextField: [UITextField] = [loginTextField, passwordTextField, confirmPassword, firstNameTExtField, lastNameTextField, mediumNameTextField, adressTextField, emailTextField]
        
        for textField in arrayTextField {
            textField.textContentType = UITextContentType("")
        }
    }
    
    override func  viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.settingNavigationBar()
        self.settingShadowButton()
    }
    
    private func settingNavigationBar() {
        if let navVC = self.navigationController {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.title = "Sign Up"
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
        self.createAccount.layer.shadowColor = UIColor.black.cgColor
        self.createAccount.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.createAccount.layer.shadowOpacity = 0.5
    }
    
    
    @IBAction func createAcount(_ sender: UIButton) {
        self.checkEmptyField()
    }
    
    private func checkEmptyField() {
        if self.loginTextField.text == "" || (self.loginTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            self.showToast(header: "Warning!", body: "The Login field must not be empty")
        }
        
        if self.passwordTextField.text == "" {
            self.showToast(header: "Warning!", body: "The Password field must not be empty")
        }
        
        if self.confirmPassword.text == "" {
            self.showToast(header: "Warning!", body: "The Confirm Password field must not be empty")
        }
        
        if self.passwordTextField.text != "" && self.confirmPassword.text != ""
        {
            let _ = self.checkPassword()
        }
        
        if self.firstNameTExtField.text == "" || (self.firstNameTExtField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            self.showToast(header: "Warning!", body: "The First Name field must not be empty")
        }
        
        if self.lastNameTextField.text == "" || (self.lastNameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            self.showToast(header: "Warning!", body: "The Last Name field must not be empty")
        }
        
        if self.mediumNameTextField.text == "" || (self.mediumNameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            self.showToast(header: "Warning!", body: "The Medium Name field must not be empty")
        }
        
        if self.birthdayButton.titleLabel?.text == nil {
            self.showToast(header: "Warning!", body: "The Birthday field must not be empty")
        }
        
        if self.adressTextField.text == "" || (self.adressTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            self.showToast(header: "Warning!", body: "The Address field must not be empty")
        }
        
        if self.emailTextField.text == "" || (self.emailTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            self.showToast(header: "Warning!", body: "The Email field must not be empty")
        }
        
        self.getData()

    }
    
    private func showToast(header: String, body: String) {
        if self.presentedViewController == nil {
            let alert = UIAlertController(title: header, message: body, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                return
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func getData(){
        var notEmptyField = 0
        let result = [loginTextField, passwordTextField, confirmPassword, lastNameTextField, firstNameTExtField, mediumNameTextField, adressTextField, emailTextField ]

        for i in 0..<result.count {
            if result[i]?.text != "" && !(result[i]?.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                notEmptyField += 1
            }
        }
        
        if self.birthdayButton.titleLabel?.text != "" {
            notEmptyField += 1
        }

        if notEmptyField == result.count + 1 && self.checkPassword() == true {
            let email = self.emailTextField.text ?? ""
            let password = self.passwordTextField.text ?? ""
            let login = self.loginTextField.text ?? ""
            let address = self.adressTextField.text ?? ""
            let firstName = self.firstNameTExtField.text ?? ""
            let lastName = self.lastNameTextField.text ?? ""
            let mediumName = self.mediumNameTextField.text ?? ""
            let birthday = self.birthdayButton.titleLabel?.text ?? ""
            
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd.mm.yyyy"
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-mm-dd"
            let birthdayFormat = dateFormat.string(from: dateFormater.date(from: birthday)!)
            
            let repo = SignUpRepo()
            
            self.indicator.isHidden = false
            self.indicator.startAnimating()

            repo.sighUp(firstName: firstName, middleName: mediumName, lastName: lastName, residenceAddress: address, birthday: birthdayFormat, username: email, email: login, password: password, controller: self, completionHandler:  {
                self.indicator.stopAnimating()
                self.indicator.isHidden = true
            })
        } else {
            if self.presentedViewController == nil {
                let alert = UIAlertController(title: "Warning!", message: "All fields required", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    return
                }))
                self.present(alert, animated: true, completion: nil)
                self.indicator.stopAnimating()
                self.indicator.isHidden = true
            }
        }
    }
    private func checkPassword() -> Bool {

        if self.passwordTextField.text != "" {
            let passwordRegEx = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"

            let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)

            if passwordTest.evaluate(with: self.passwordTextField.text) {
                if self.passwordTextField.text != self.confirmPassword.text {
                    if self.presentedViewController == nil {
                        let alert = UIAlertController(title: "Warning!", message: "Password does not match that entered in the password confirm field", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                            return
                        }))

                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    return true
                }
            } else {
                if self.presentedViewController == nil {

                    let alert = UIAlertController(title: "Error!", message: "Invalid password.The password must be at least 8 characters in length. Must contain at least one letter in upper case, one in lower case and one digit.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                        return
                    }))

                    self.present(alert, animated: true, completion: nil)

                }
            }
        }
        
        return false
    }
    
    @IBAction func presentPicker(_ sender: Any) {
        if let navVC = self.navigationController {
            self.view.endEditing(true)
            self.birthdayButton.isHighlighted = false
            let nextController = BirthdayViewController()
            nextController.image = self.takeScreenShot()
            nextController.resultBithday = self.birthdayButton.titleLabel?.text
            
            navVC.pushViewController(nextController, animated: false)
        }
        
    }
    
    private  func takeScreenShot ()  -> UIImage? {
        let appDelegate = UIApplication.shared.delegate!

        UIGraphicsBeginImageContextWithOptions((appDelegate.window?!.frame.size)!, (appDelegate.window?!.isOpaque)!, UIScreen.main.scale)
        appDelegate.window?!.layer.render(in: UIGraphicsGetCurrentContext(
            )!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
