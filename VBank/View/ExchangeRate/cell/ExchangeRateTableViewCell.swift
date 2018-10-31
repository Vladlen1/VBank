//
//  ExchangeRateTableViewCell.swift
//  VBank
//
//  Created by Vlad Birukov on 05.11.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import UIKit

class ExchangeRateTableViewCell: UITableViewCell {
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var saleLabel: UILabel!
    @IBOutlet weak var purchaseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWith(model: ExchangeRatesModel) {
        self.unitLabel.text = model.unitCashe
        
        self.saleLabel.text = String(format: "sale: %.4f",  model.sale)
        self.purchaseLabel.text = String(format: "purchase: %.4f", model.purchase)
        
    }
}
