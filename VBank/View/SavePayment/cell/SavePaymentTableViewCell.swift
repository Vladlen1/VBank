//
//  SavePaymentTableViewCell.swift
//  VBank
//
//  Created by Vlad Birukov on 05.11.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import UIKit

class SavePaymentTableViewCell: UITableViewCell {
    @IBOutlet weak var cardSender: UILabel!
    @IBOutlet weak var paymentType: UILabel!
    @IBOutlet weak var payee: UILabel!
    @IBOutlet weak var paymentAmount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupWith(model: SavePaymentModel) {
        
        self.cardSender.text = String(format: "Card sender: %@", model.cardSender)
        self.paymentType.text = String(format: "Payment type: %@", model.paymentType)
        self.payee.text = String(format: "Payee: %@", model.payee)
        self.paymentAmount.text = String(format: "Payment amount: %@", model.paymentAmount)
    }
    
}
