//
//  CreatePaymentRepo.swift
//  VBank
//
//  Created by Vlad Birukov on 02.12.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CreatePaymentRepo {
    
    static let sharedInstance = CreatePaymentRepo()
    
    private init() {}
    
    var result = [(displayCard: String, card: String)]()
    var controller: CreatePaymentViewController?
    
    func getCard(controller: CreatePaymentViewController, completionHandler: @escaping () -> Void) {
        if let token = UserDefaults.standard.value(forKey: "token") as? String {
            let authorization = String(format:"Token %@", token)
            let headers: HTTPHeaders = [
                "authorization": authorization,
            ]
            
            Alamofire.request("https://vbank.herokuapp.com/api/bank-cards/", method: .get, headers: headers).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.result.removeAll()
                    self.getAcountModel(json: json)
                    completionHandler()
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
    
    func transferCashe(numberCard: String, value: String, recipient: String, controller: CreatePaymentViewController, completionHandler: @escaping () -> Void) {
        self.controller = controller
        if let token = UserDefaults.standard.value(forKey: "token") as? String {
            let authorization = String(format:"Token %@", token)
            let json = ["value": value,"recipient":recipient]
            let session = URLSession.shared

            let url = URL(string: "https://vbank.herokuapp.com/api/bank-cards/\(numberCard)/transfer/")!
            
            var request = URLRequest(url : url)
            
            request.addValue(authorization, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            request.httpMethod = "POST"
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                completionHandler()
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode >= 200 &&  httpResponse.statusCode <= 299{
                        if controller.presentedViewController == nil {
                            let alert = UIAlertController(title: "Payment", message: "Payment was successful", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                                controller.clearTextField()
                                return
                            }))
                            DispatchQueue.main.async {
                                controller.present(alert, animated: true, completion: nil)
                            }
                        }
                    } else {
                        do{
                            let str = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                            self.parseJson(body: str)
                        } catch {
                            if controller.presentedViewController == nil {
                                let alert = UIAlertController(title: "Payment", message: "Payment was unsuccessful", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                                    return
                                }))
                                DispatchQueue.main.async {
                                    controller.present(alert, animated: true, completion: nil)
                                }
                            }
                        }

                    }
                }
                
                if error != nil {
                    if controller.presentedViewController == nil {
                        let alert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
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
            })
            
            task.resume()
            
        }
    }
    
    func payEripService(value: String, recipient: String,favorite: Bool, numberCard: String, controller: CreatePaymentViewController, completionHandler: @escaping () -> Void) {
        self.controller = controller

        if let token = UserDefaults.standard.value(forKey: "token") as? String {
            let authorization = String(format:"Token %@", token)
            let json = ["value": value,"recipient": recipient, "is_favorite": String(favorite)]
            let session = URLSession.shared
            
            let url = URL(string: "https://vbank.herokuapp.com/api/bank-cards/\(numberCard)/transfer/?external=True")!
            
            var request = URLRequest(url : url)
            
            request.addValue(authorization, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            request.httpMethod = "POST"
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                completionHandler()
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode >= 200 &&  httpResponse.statusCode <= 299 {
                        if controller.presentedViewController == nil {
                            let alert = UIAlertController(title: "Payment", message: "Payment was successful", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                                controller.clearTextField()
                                return
                            }))
                            
                            DispatchQueue.main.async {
                                controller.present(alert, animated: true, completion: nil)
                            }
                        }
                    } else {
                        do{
                            let str = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                            self.parseJson(body: str)
                        } catch {
                            if controller.presentedViewController == nil {
                                let alert = UIAlertController(title: "Payment", message: "Payment was unsuccessful", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                                    return
                                }))
                                DispatchQueue.main.async {
                                    controller.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
                
                if error != nil {
                    if controller.presentedViewController == nil {
                        let alert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
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
                
            })
            
            task.resume()
            
        }
    }
    
    func payEripSaveService(value: String, recipient: String, numberCard: String, controller: PaymentSaveViewController, completionHandler: @escaping () -> Void) {
        
        if let token = UserDefaults.standard.value(forKey: "token") as? String {
            let authorization = String(format:"Token %@", token)
            let json = ["value": value,"recipient": recipient, "is_favourite": "false"]
            let session = URLSession.shared
            
            let url = URL(string: "https://vbank.herokuapp.com/api/bank-cards/\(numberCard)/transfer/?external=True")!
            
            var request = URLRequest(url : url)
            
            request.addValue(authorization, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            request.httpMethod = "POST"
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                completionHandler()
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299 {
                        if controller.presentedViewController == nil {
                            let alert = UIAlertController(title: "Payment", message: "Payment was successful", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                                return
                            }))
                            DispatchQueue.main.async {
                                controller.present(alert, animated: true, completion: nil)
                            }
                            
                        }
                    } else {
                        if controller.presentedViewController == nil {
                            let alert = UIAlertController(title: "Payment", message: "Payment was unsuccessful", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                                return
                            }))
                            DispatchQueue.main.async {
                                controller.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
                
                if error != nil {
                    if controller.presentedViewController == nil {
                        let alert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
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
                
            })
            
            task.resume()
            
        }
    }
    
    private func getAcountModel(json: JSON) {
        for (_, subJson):(String, JSON) in json["results"] {
            let displayCard = String(format: "%@ %@", subJson["number"].string ?? "", subJson["currency_code"].string ?? "")
            let card = subJson["number"].string ?? ""
            result.append((displayCard: displayCard, card: card))
        }
    }
    
    private func parseJson(body: [String: Any]) {
        if body["recipient"] != nil {
            let array = body["recipient"] as? [String] ?? [""]
            
            if self.controller?.presentedViewController == nil {
                let alert = UIAlertController(title: "Payment", message: String(format: "%@", array.first ?? ""), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    return
                }))
                DispatchQueue.main.async {
                    self.controller?.present(alert, animated: true, completion: nil)
                }
                
            }
        } else if body["non_field_errors"] != nil {
            let array = body["non_field_errors"] as? [String] ?? [""]
            
            if self.controller?.presentedViewController == nil {
                let alert = UIAlertController(title: "Payment", message: String(format: "%@", array.first ?? ""), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    return
                }))
                DispatchQueue.main.async {
                    self.controller?.present(alert, animated: true, completion: nil)
                }
                
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
