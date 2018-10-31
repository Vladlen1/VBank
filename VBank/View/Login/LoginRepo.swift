//
//  LoginRepo.swift
//  VBank
//
//  Created by Vlad Birukov on 01.12.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class LoginRepo {
    
    var controller: LoginViewController?
    
    func logout() {
        if let token = UserDefaults.standard.value(forKey: "token") as? String {
            let authorization = String(format:"Token %@", token)
            let headers: HTTPHeaders = [
                "authorization": authorization,
                "Accept": "application/json"
            ]
            
            Alamofire.request("https://vbank.herokuapp.com/api/auth/logout/",method: .delete, headers: headers).responseJSON { response in
            }
        }
        
    }
    
    func login(email: String, password: String, controller: LoginViewController) {
        self.controller = controller
        
        Alamofire.request("https://vbank.herokuapp.com/api/auth/login-client/", method: .post, parameters: ["username": email,
                                        "password": password]).responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            let json = JSON(value)
                            let header = response.response?.allHeaderFields as? [String: Any]
                            self.parseJson(header: header, body: json)
                        case .failure(let error):
                            if controller.presentedViewController == nil {
                                let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                                            return
                                        }))
                                
                                DispatchQueue.main.async {
                                    controller.indecator.isHidden = true
                                    controller.indecator.stopAnimating()
                                    controller.present(alert, animated: true, completion: nil)
                                }

                            }
                        }
        }
    }
    
    private func parseJson(header: [String: Any]?, body: JSON) {
        if body["non_field_errors"].array != nil && body["non_field_errors"].array?.first != nil && body["non_field_errors"].array?.first?.string != "" {
            if self.controller != nil && self.controller?.presentedViewController == nil {
                var alertText = ""
                let text = body["non_field_errors"].array?.first?.string ?? ""
                
                if text == "Invalid username or password." {
                    alertText = String(format: "%@ %@", "Invalid email or password", ". The password must be at least 8 characters in length. Must contain at least one letter in upper case, one in lower case and one digit.")
                } else {
                    alertText = text
                }
                
                let alert = UIAlertController(title: "Error!", message: alertText, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    return
                }))
                
                DispatchQueue.main.async {
                    self.controller?.indecator.isHidden = true
                    self.controller?.indecator.stopAnimating()
                    self.controller?.present(alert, animated: true, completion: nil)
                }
            }
        } else if body["email"].array != nil && body["email"].array?.first != nil && body["email"].array?.first?.string != "" {
            if self.controller != nil && self.controller?.presentedViewController == nil {
                let alert = UIAlertController(title: "Error!", message: body["email"].array?.first?.string ?? "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    return
                }))
                
                DispatchQueue.main.async {
                    self.controller?.indecator.isHidden = true
                    self.controller?.indecator.stopAnimating()
                    self.controller?.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            let token = header?["X-Token"] as? String
            
            if token != nil {
                UserDefaults.standard.setValue(token, forKey: "token")
                
                if self.controller != nil {
                    DispatchQueue.main.async {
                        self.controller?.indecator.stopAnimating()
                        self.controller?.present(BaseNavigationController.init(rootViewController: HomeViewController()) , animated: true, completion: nil)
                    }
                }
            } else {
                if self.controller != nil && self.controller?.presentedViewController == nil {
                    let alert = UIAlertController(title: "Error!", message: String(format: "%@", "Invalid email or password. The password must be at least 8 characters in length. Must contain at least one letter in upper case, one in lower case and one digit."), preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                        return
                    }))
                    
                    DispatchQueue.main.async {
                        self.controller?.indecator.isHidden = true
                        self.controller?.indecator.stopAnimating()
                        self.controller?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    private func getToken(json: [String: Any]) {
        let token = json["X-Token"] as? String
        
        if token != nil {
            UserDefaults.standard.setValue(token, forKey: "token")
            
            if self.controller != nil {
                DispatchQueue.main.async {
                    self.controller?.indecator.stopAnimating()
                    self.controller?.present(BaseNavigationController.init(rootViewController: HomeViewController()) , animated: true, completion: nil)
                }
            }
        } else {
            if self.controller != nil {
                DispatchQueue.main.async {
                    self.controller?.indecator.stopAnimating()
                    self.controller?.errorLabel.text = "Incorrect email or password"
                }
            }
        }

    }
}
