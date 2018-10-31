//
//  SavePaymentRepo.swift
//  VBank
//
//  Created by Vlad Birukov on 03.12.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SavePaymentRepo {
    
    static let sharedInstance = SavePaymentRepo()
    
    private init() {}
    
    var result = [SavePaymentModel]()
    
    func getSavePayment(controller: SavePaymentViewController, completionHandler: @escaping () -> Void) {
        
        if let token = UserDefaults.standard.value(forKey: "token") as? String {
            let authorization = String(format:"Token %@", token)
            
            let headers: HTTPHeaders = [
                "authorization": authorization,
                "Accept": "application/json"
            ]
            
            
            Alamofire.request("https://vbank.herokuapp.com/api/transfers/external/?favorite=true", method: .get, headers: headers).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.result.removeAll()
                    self.getSavePayment(json: json)
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
    
    private func getSavePayment(json: JSON) {
        
        for (_, subJson):(String, JSON) in json["results"] {
            let model = SavePaymentModel()
            
            model.cardSender = subJson["sender"].string ?? ""
            model.paymentType = "ЕРИП"
            model.payee = subJson["recipient"].string ?? ""
            model.paymentAmount = String(format: "%.2f %@", subJson["value"].double ?? "", subJson["currency_code"].string ?? "")
            
            self.result.append(model)
        }
    }
}
