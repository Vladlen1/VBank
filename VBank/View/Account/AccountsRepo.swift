//
//  AccountsRepo.swift
//  VBank
//
//  Created by Vlad Birukov on 02.12.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AccountsRepo {
    
    static let sharedInstance = AccountsRepo()
    
    private init() {}
    
    var result = [AccountModel]()
    
    func execute(controller: AccountViewController, completionHandler: @escaping () -> Void) {
        if let token = UserDefaults.standard.value(forKey: "token") as? String {
            let authorization = String(format:"Token %@", token)
            let headers: HTTPHeaders = [
                "authorization": authorization,
                "Accept": "application/json"
            ]
            
            
            Alamofire.request("https://vbank.herokuapp.com/api/bank-accounts/", method: .get, headers: headers).responseJSON { response in
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
    
    private func getAcountModel(json: JSON) {
        for (_, subJson):(String, JSON) in json["results"] {
            let model = AccountModel()
            
            model.numberCard = subJson["number"].string ?? ""
            model.numberCash = subJson["balance"].double ?? 0.0
            model.unit = subJson["currency"].string ?? ""
            
            self.result.append(model)
        }
    }
}
