//
//  HistoryPaymentRepo.swift
//  VBank
//
//  Created by Vlad Birukov on 02.12.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HistoryPaymentRepo {
    
    
    var result: [[SavePaymentModel]?] = [nil, nil , nil]
    
    func getExternalPay(controller: HistoryPaymentViewController, index: Int, fromDate: String, toDate: String, completionHandler: @escaping () -> Void) {
        
        if let token = UserDefaults.standard.value(forKey: "token") as? String {
            let authorization = String(format:"Token %@", token)
            
            let headers: HTTPHeaders = [
                "authorization": authorization,
                "Accept": "application/json"
            ]
            
            Alamofire.request("https://vbank.herokuapp.com/api/transfers/external/?from=\(fromDate)&to=\(toDate)", method: .get, headers: headers).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.getExternal(index: index, json: json)
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
    
    func getInternalPay(controller: HistoryPaymentViewController, index: Int, fromDate: String, toDate: String, completionHandler: @escaping () -> Void) {
        if let token = UserDefaults.standard.value(forKey: "token") as? String {
            let authorization = String(format:"Token %@", token)
            
            let headers: HTTPHeaders = [
                "authorization": authorization,
                "Accept": "application/json"
            ]
            
            Alamofire.request("https://vbank.herokuapp.com/api/transfers/internal/?from=\(fromDate)&to=\(toDate)", method: .get, headers: headers).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.getInternal(index: index, json: json)
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
    
    
    private func getInternal(index: Int, json: JSON) {
        if self.result[index] == nil {
            self.result[index] = [SavePaymentModel]()
        }
        
        for (_, subJson):(String, JSON) in json["results"] {
            let model = SavePaymentModel()

            model.cardSender = subJson["sender"].string ?? ""
            model.paymentType = "Transfer"
            model.payee = subJson["recipient"].string ?? ""
            model.paymentAmount = String(format: "%.2f %@", subJson["value"].double ?? "", subJson["currency_code"].string ?? "")
            
            self.result[index]?.append(model)
        }
    }
    
    private func getExternal(index: Int, json: JSON) {
        if self.result[index] == nil {
            self.result[index] = [SavePaymentModel]()
        }
    
        for (_, subJson):(String, JSON) in json["results"] {
            let model = SavePaymentModel()
            
            model.cardSender = subJson["sender"].string ?? ""
            model.paymentType = "ЕРИП"
            model.payee = subJson["recipient"].string ?? ""
            model.paymentAmount = String(format: "%.2f %@", subJson["value"].double ?? "", subJson["currency_code"].string ?? "")
            
            self.result[index]?.append(model)
        }
    }
}
