//
//  PaymentSaveViewController.swift
//  VBank
//
//  Created by Vlad Birukov on 03.12.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import UIKit

class PaymentSaveViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var cardSenderLabel: UILabel!
    @IBOutlet weak var serviceCode: UILabel!
    @IBOutlet weak var paymentAmount: UITextField!
    @IBOutlet weak var makePaymentButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    var model: SavePaymentModel?
    
    let repo = CreatePaymentRepo.sharedInstance

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.settingNavigationBar()
        self.settingShadowButton()
        self.settingView()
    }
    
    private func settingView() {
        if model != nil {
            self.cardSenderLabel.text = model?.cardSender
            self.serviceCode.text = String(format: "%@", model!.payee)
        }
    }

    
    private func settingNavigationBar() {
        if let navVC = self.navigationController {
            self.title = "Create Payment"
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
        self.makePaymentButton.layer.shadowColor = UIColor.black.cgColor
        self.makePaymentButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.makePaymentButton.layer.shadowOpacity = 0.5
    }
    
    @IBAction func makePayment(_ sender: UIButton) {
        self.eripPayee()
    }
    
    private func eripPayee() {
        if self.paymentAmount.text != "" {
            let number = Double(self.paymentAmount.text!)
            
            if number != nil && number! > 0.0 && self.model != nil {
                self.indicator.isHidden = false
                self.indicator.startAnimating()
                
                self.makePaymentButton.isEnabled = false
                self.repo.payEripSaveService(value: self.paymentAmount.text!, recipient:  (self.model?.payee)!, numberCard: (self.model?.cardSender)!, controller: self, completionHandler: {DispatchQueue.main.async {
                    self.makePaymentButton.isEnabled = true
                    self.indicator.stopAnimating()
                    self.indicator.isHidden = true
                    self.paymentAmount.text = ""
                    }
                })
                
            } else {
                if self.presentedViewController == nil {
                    let alert = UIAlertController(title: "Error!", message: "Invalid payment amount", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                        return
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
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
    
}
