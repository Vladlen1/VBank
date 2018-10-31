//
//  ChangeEmailViewController.swift
//  VBank
//
//  Created by Vlad Birukov on 05.11.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import UIKit

class ChangeEmailViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var newEmailTextField: UITextField!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
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
            self.title = "Change email"
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
        
        
        self.checkData()
    }
    
    @objc func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func checkData() {
        if self.newEmailTextField.text != "" {
            self.indicator.isHidden = false
            self.indicator.startAnimating()
                
            let repo = ChangeEmailRepo()
                
            repo.changEmail(nemEmail: self.newEmailTextField.text!, controller: self)
        } else {
            if self.presentedViewController == nil {
                let alert = UIAlertController(title: "Warning!", message: "New email field required", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    return
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
