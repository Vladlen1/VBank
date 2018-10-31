//
//  EchangeRateRepo.swift
//  VBank
//
//  Created by Vlad Birukov on 01.12.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class EchangeRepo {
    
    static let sharedInstance = EchangeRepo()
    
    private init() {}
    
    var result = [ExchangeRatesModel]()
    
    
    func execute(controller: ExchangeRateViewController, completionHandler: @escaping () -> Void){
        Alamofire.request("https://vbank.herokuapp.com/api/exchange-rates/").responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.result.removeAll()
                self.getExchangeRate(json: json)
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

    private func getExchangeRate(json: JSON) {
        for (_, subJson):(String, JSON) in json["results"] {
            let exchangeRateModel = ExchangeRatesModel()
            exchangeRateModel.unitCashe = subJson["code"].string ?? ""
            exchangeRateModel.purchase = subJson["purchase_rate"].double ?? 0.0
            exchangeRateModel.sale = subJson["sale_rate"].double ?? 0.0

            self.result.append(exchangeRateModel)
        }
        
    }
}
