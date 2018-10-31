//
//  ChangePasswordRepo.swift
//  VBank
//
//  Created by Vlad Birukov on 02.12.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ChangPasswordRepo {
    
    var controller: ChangePasswordViewController?
    
    func change(oldPassword: String, newPassword: String, controller: ChangePasswordViewController) {
        self.controller = controller
        if let token = UserDefaults.standard.value(forKey: "token") as? String {
            let authorization = String(format:"Token %@", token)
            let headers: HTTPHeaders = [
                "authorization": authorization,
                "Accept": "application/json"
            ]
            
            
            Alamofire.request("https://vbank.herokuapp.com/api/users/me/change-password/", method: .put, parameters: ["old_password": oldPassword,"new_password":newPassword], headers: headers).responseJSON { response in
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
        if body["old_password"].array != nil && body["old_password"].array?.first != nil && body["old_password"].array?.first?.string != "" && self.controller != nil {
            if self.controller != nil && self.controller?.presentedViewController == nil {
                let alert = UIAlertController(title: "Error!", message: body["old_password"].array?.first?.string ?? "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    return
                }))
                
                DispatchQueue.main.async {
                    self.controller?.indicator.isHidden = true
                    self.controller?.indicator.stopAnimating()
                    self.controller?.present(alert, animated: true, completion: nil)
                }
            }
        } else if body["new_password"].array != nil && body["new_password"].array?.first != nil && body["new_password"].array?.first?.string != "" && self.controller != nil {
            if self.controller != nil && self.controller?.presentedViewController == nil {
                let alert = UIAlertController(title: "Error!", message: body["new_password"].array?.first?.string ?? "", preferredStyle: UIAlertControllerStyle.alert)
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
            if let delegate = self.controller?.delegate {
                    DispatchQueue.main.async {
                        self.controller?.indicator.isHidden = true
                        self.controller?.indicator.stopAnimating()
                        self.controller?.dismiss(animated: false, completion: {
                    delegate.back()
                    })
                }
            } else {
                if self.controller?.presentedViewController == nil {
                    let alert = UIAlertController(title: "Error!", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                        return
                    }))

                    DispatchQueue.main.async {
                        self.controller?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
