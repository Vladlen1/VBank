//
//  ChangeEmailRepo.swift
//  VBank
//
//  Created by Vlad Birukov on 02.12.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ChangeEmailRepo {
    
    var controller: ChangeEmailViewController?
    
    func changEmail(nemEmail: String, controller: ChangeEmailViewController) {
        self.controller = controller
        
        if let token = UserDefaults.standard.value(forKey: "token") as? String {
            let authorization = String(format:"Token %@", token)
            let headers: HTTPHeaders = [
                "authorization": authorization,
                "Accept": "application/json"
            ]
            
            
            Alamofire.request("https://vbank.herokuapp.com/api/users/me/", method: .put, parameters: ["email": nemEmail], headers: headers).responseJSON { response in
                
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
       if body["email"].array != nil && body["email"].array?.first != nil && body["email"].array?.first?.string != "" && self.controller != nil {
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
       } else {
            if let delegate = self.controller?.delegate {
                DispatchQueue.main.async {
                    self.controller?.dismiss(animated: false, completion: {
                            delegate.back()
                    })
                    }
                
            } else {
                if self.controller?.presentedViewController == nil {
                        let alert = UIAlertController(title: "Error!", message: "Wrong email", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                            return
                        }))

                        DispatchQueue.main.async {
                            self.controller?.indicator.stopAnimating()
                            self.controller?.indicator.isHidden = true
                            self.controller?.present(alert, animated: true, completion: nil)
                        }

                }
            }
        }
    }
}
