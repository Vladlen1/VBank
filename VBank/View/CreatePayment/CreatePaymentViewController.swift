//
//  CreatePaymentViewController.swift
//  VBank
//
//  Created by Vlad Birukov on 05.11.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import UIKit

class CreatePaymentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var typePickerView: UIPickerView!
    @IBOutlet weak var typeCode: UILabel!
    @IBOutlet weak var typeCodeTextField: UITextField!
    @IBOutlet weak var paymentAmount: UITextField!
    @IBOutlet weak var paymentAmountLabel: UILabel!
    @IBOutlet weak var makePaymentButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!


    let typePayment = ["ЕРИП", "Transfer"]
    
    let repo = CreatePaymentRepo.sharedInstance

    var rowCard = 0
    var rowType = 0
    var favorite = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.settingNavigationBar()
        self.settingShadowButton()
        self.loadData()
        self.clearTextField()
        self.typePickerView.selectedRow(inComponent: 0)
    }

    
    private func loadData() {
        self.repo.controller = nil
        self.makePaymentButton.isHidden = true
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        
        self.repo.result.removeAll()
        self.pickerView.reloadAllComponents()
        
        self.repo.getCard(controller: self, completionHandler: {
            self.pickerView.reloadAllComponents()
            self.indicator.stopAnimating()
            self.rowCard = 0

            if self.repo.result.count > 0 {
                self.makePaymentButton.isHidden = false
            } else {
                self.makePaymentButton.isHidden = true
            }
        })
    }
    
    private func settingNavigationBar() {
        if let navVC = self.navigationController {
            self.title = "Create Payment"
            navVC.navigationBar.tintColor = UIColor.white
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return self.repo.result.count

        }
        return self.typePayment.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return self.repo.result[row].displayCard
        }
        
        return self.typePayment[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 2 {
            self.rowType = row
            
            self.typeCodeTextField.text = ""
            
            if row == 0 {
                self.typeCode.text = "Service code:"
            } else {
                self.typeCode.text = "Payee:"
            }
            self.paymentAmountLabel.text = "Payment amount:"
            
            self.paymentAmount.isHidden = false
            self.typeCodeTextField.isHidden = false
        } else {
            self.rowCard = row
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func hide() {
        self.typeCode.text = ""
        self.paymentAmountLabel.text = ""
        
        self.paymentAmount.isHidden = true
        self.typeCodeTextField.isHidden = true
    }
    
    func settingShadowButton() {
        self.makePaymentButton.layer.shadowColor = UIColor.black.cgColor
        self.makePaymentButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.makePaymentButton.layer.shadowOpacity = 0.5
    }
    
    @IBAction func makePayment(_ sender: UIButton) {
        self.checkTypeOeration()
    }
    
    private func checkTypeOeration() {
        if self.rowType == 0 {
            self.eripPayee()
        } else {
            self.transferCashe()
        }
    }
    
    private func eripPayee() {
        if self.typeCodeTextField.text != "" && self.paymentAmount.text != "" && self.repo.result.count > 0 && !((self.typeCodeTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty)!) {
            let number = Double(self.paymentAmount.text!)
            
            if number != nil && number! > 0.0{
                self.indicator.isHidden = false
                self.indicator.startAnimating()
                
                if self.presentedViewController == nil {
                    let alert = UIAlertController(title: "Payment!", message: "Do you want to save the payment?", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { action in
                        self.favorite = false
                        
                        self.makePaymentButton.isEnabled = false
                        self.repo.payEripService(value: self.paymentAmount.text!, recipient: self.typeCodeTextField.text!, favorite: self.favorite, numberCard: self.repo.result[self.rowCard].card, controller: self, completionHandler: {DispatchQueue.main.async {
                                self.makePaymentButton.isEnabled = true
                                self.indicator.stopAnimating()
                                self.indicator.isHidden = true
                            }
                        })

                    }))
                    
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
                        self.favorite = true
                        
                        self.makePaymentButton.isEnabled = false
                        
                        self.repo.payEripService(value: self.paymentAmount.text!, recipient: self.typeCodeTextField.text!, favorite: self.favorite, numberCard: self.repo.result[self.rowCard].card, controller: self, completionHandler: {DispatchQueue.main.async {
                                self.makePaymentButton.isEnabled = true
                                self.indicator.stopAnimating()
                                self.indicator.isHidden = true
                            }
                        })

                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                
                
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
    
    private func transferCashe() {
        if self.typeCodeTextField.text != "" && self.paymentAmount.text != "" && self.repo.result.count > 0 {
            let number = Double(self.paymentAmount.text!)
            
            if number != nil && number! > 0.0{
                self.indicator.isHidden = false
                self.indicator.startAnimating()
                
                self.makePaymentButton.isEnabled = false
                self.repo.transferCashe(numberCard: self.repo.result[self.rowCard].card, value: self.paymentAmount.text!, recipient: self.typeCodeTextField.text!, controller: self, completionHandler: {DispatchQueue.main.async {
                        self.makePaymentButton.isEnabled = true
                        self.indicator.stopAnimating()
                        self.indicator.isHidden = true
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
    
    func clearTextField() {
        self.typeCodeTextField.text = ""
        self.paymentAmount.text = ""
    }
}
