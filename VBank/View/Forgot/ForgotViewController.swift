//
//  ForgotViewController.swift
//  VBank
//
//  Created by Vlad Birukov on 05.11.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import UIKit

class ForgotViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var forgotButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func  viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.settingNavigationBar()
        self.settingShadowButton()
    }

    private func settingNavigationBar() {
        if let navVC = self.navigationController {
            self.title = "Reset your password"
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
        self.forgotButton.layer.shadowColor = UIColor.black.cgColor
        self.forgotButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.forgotButton.layer.shadowOpacity = 0.5
    }
    
    
    @IBAction func send(_ sender: UIButton) {
        if let navVC = self.navigationController {
            navVC.popViewController(animated: true)
        }
    }
}
