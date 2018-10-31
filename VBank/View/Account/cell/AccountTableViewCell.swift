//
//  AccountTableViewCell.swift
//  VBank
//
//  Created by Vlad Birukov on 05.11.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    @IBOutlet weak var card: UILabel!
    @IBOutlet weak var cash: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWith(model: AccountModel) {
        self.card.text = model.numberCard
        self.cash.text = String(format: "%.2f %@", model.numberCash, model.unit)
    }
}
