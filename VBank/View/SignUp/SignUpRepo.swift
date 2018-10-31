//
//  SignUpRepo.swift
//  VBank
//
//  Created by Vlad Birukov on 01.12.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SignUpRepo {
    
    var controller: SignUpViewController?
    
    func sighUp(firstName: String, middleName: String, lastName: String, residenceAddress: String, birthday: String, username: String, email: String, password: String, controller: SignUpViewController, completionHandler: @escaping () -> Void) {
        self.controller = controller
        Alamofire.request("https://vbank.herokuapp.com/api/users/",
                          method: .post,
                          parameters: ["first_name": firstName,
                                       "middle_name": middleName,
                                       "last_name": lastName,
                                       "residence_address": residenceAddress,
                                       "birthday": birthday,
                                       "username": username,
                                       "email": username,
                                       "password": password]).responseJSON {
                                        response in
                                        
            
                                        
                                        if response.response != nil && response.response!.statusCode >= 200 && response.response!.statusCode <= 299 {
                                            if controller.presentedViewController == nil {
                                                let alert = UIAlertController(title: "Registration", message: "Registration was successfully waiting for your account confirmation", preferredStyle: UIAlertControllerStyle.alert)
                                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                                                    DispatchQueue.main.async {
                                                        if self.controller?.navigationController != nil {
                                                            self.controller?.indicator.isHidden = true
                                                            self.controller?.indicator.stopAnimating()
                                                            self.controller?.navigationController?.popViewController(animated: false)
                                                        }
                                                    }
                                                    return
                                                }))
                                                controller.present(alert, animated: true, completion: nil)
                                            }
                                        } else {
                                            switch response.result {
                                            case .success(let value):
                                                let json = JSON(value)
                                                self.parseJson(body: json)
                                            case .failure(let error):
                                                if controller.presentedViewController == nil {
                                                    let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                                                        return
                                                    }))
                                                    
                                                    DispatchQueue.main.async {
                                                        controller.indicator.isHidden = true
                                                        controller.indicator.stopAnimating()
                                                        controller.present(alert, animated: true, completion: nil)
                                                    }
                                                    
                                                }
                                            }
                                        }
                                        }
        
    }
    
    private func parseJson(body: JSON) {
        if body["username"].array != nil && body["username"].array?.first != nil && body["username"].array?.first?.string != "" && self.controller != nil {
            if self.controller != nil && self.controller?.presentedViewController == nil {
                var text = body["username"].array?.first?.string ?? ""
                
                if text == "A user with that username already exists." {
                    text = "A user with that email already exists."
                }
                
                let alert = UIAlertController(title: "Error!", message: text, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    return
                }))
                
                DispatchQueue.main.async {
                    self.controller?.indicator.isHidden = true
                    self.controller?.indicator.stopAnimating()
                    self.controller?.present(alert, animated: true, completion: nil)
                }
            }
        } else if body["password"].array != nil && body["password"].array?.first != nil && body["password"].array?.first?.string != "" && self.controller != nil {
            if self.controller != nil && self.controller?.presentedViewController == nil {
                let alert = UIAlertController(title: "Error!", message: body["password"].array?.first?.string ?? "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    return
                }))
                
                DispatchQueue.main.async {
                    self.controller?.indicator.isHidden = true
                    self.controller?.indicator.stopAnimating()
                    self.controller?.present(alert, animated: true, completion: nil)
                }
            }
    
        } else if body["first_name"].array != nil && body["first_name"].array?.first != nil && body["first_name"].array?.first?.string != "" && self.controller != nil {
            if self.controller != nil && self.controller?.presentedViewController == nil {
                let alert = UIAlertController(title: "Error!", message: body["first_name"].array?.first?.string ?? "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    return
                }))
                
                DispatchQueue.main.async {
                    self.controller?.indicator.isHidden = true
                    self.controller?.indicator.stopAnimating()
                    self.controller?.present(alert, animated: true, completion: nil)
                }
            }
            
        } else if body["last_name"].array != nil && body["last_name"].array?.first != nil && body["last_name"].array?.first?.string != "" && self.controller != nil {
            if self.controller != nil && self.controller?.presentedViewController == nil {
                let alert = UIAlertController(title: "Error!", message: body["last_name"].array?.first?.string ?? "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    return
                }))
                
                DispatchQueue.main.async {
                    self.controller?.indicator.isHidden = true
                    self.controller?.indicator.stopAnimating()
                    self.controller?.present(alert, animated: true, completion: nil)
                }
            }
            
        } else if body["middle_name"].array != nil && body["middle_name"].array?.first != nil && body["middle_name"].array?.first?.string != "" && self.controller != nil {
            if self.controller != nil && self.controller?.presentedViewController == nil {
                let alert = UIAlertController(title: "Error!", message: body["middle_name"].array?.first?.string ?? "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    return
                }))
                
                DispatchQueue.main.async {
                    self.controller?.indicator.isHidden = true
                    self.controller?.indicator.stopAnimating()
                    self.controller?.present(alert, animated: true, completion: nil)
                }
            }
        
        } else if body["birthday"].array != nil && body["birthday"].array?.first != nil && body["birthday"].array?.first?.string != "" && self.controller != nil {
            if self.controller != nil && self.controller?.presentedViewController == nil {
                let alert = UIAlertController(title: "Error!", message: body["birthday"].array?.first?.string ?? "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    return
                }))
                
                DispatchQueue.main.async {
                    self.controller?.indicator.isHidden = true
                    self.controller?.indicator.stopAnimating()
                    self.controller?.present(alert, animated: true, completion: nil)
                }
            }
            
        } else if body["residence_address"].array != nil && body["residence_address"].array?.first != nil && body["residence_address"].array?.first?.string != "" && self.controller != nil {
            if self.controller != nil && self.controller?.presentedViewController == nil {
                let alert = UIAlertController(title: "Error!", message: body["residence_address"].array?.first?.string ?? "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    return
                }))
                
                DispatchQueue.main.async {
                    self.controller?.indicator.isHidden = true
                    self.controller?.indicator.stopAnimating()
                    self.controller?.present(alert, animated: true, completion: nil)
                }
            }
            
        } else if body["email"].array != nil && body["email"].array?.first != nil && body["email"].array?.first?.string != "" && self.controller != nil {
            if self.controller != nil && self.controller?.presentedViewController == nil {
                let alert = UIAlertController(title: "Error!", message: body["email"].array?.first?.string ?? "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    return
                }))
                
                DispatchQueue.main.async {
                    self.controller?.indicator.isHidden = true
                    self.controller?.indicator.stopAnimating()
                    self.controller?.present(alert, animated: true, completion: nil)
                }
            }
    
        } else if body["non_field_errors"].array != nil && body["non_field_errors"].array?.first != nil && body["non_field_errors"].array?.first?.string != "" && self.controller != nil {
            if self.controller != nil && self.controller?.presentedViewController == nil {
                let alert = UIAlertController(title: "Error!", message: body["non_field_errors"].array?.first?.string ?? "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    return
                }))
                
                DispatchQueue.main.async {
                    self.controller?.indicator.isHidden = true
                    self.controller?.indicator.stopAnimating()
                    self.controller?.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            if self.controller != nil {
                if self.controller?.presentedViewController == nil {
                    let alert = UIAlertController(title: "Registration", message: "Registration was successfully waiting for your account confirmation", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                        DispatchQueue.main.async {
                            if self.controller?.navigationController != nil {
                                self.controller?.indicator.isHidden = true
                                self.controller?.indicator.stopAnimating()
                                self.controller?.navigationController?.popViewController(animated: false)
                            }
                        }
                        return
                    }))
                    self.controller?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
