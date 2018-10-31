//
//  PaymentViewController.swift
//  VBank
//
//  Created by Vlad Birukov on 05.11.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var detailTable: UITableView!
    
    let paymentLabel :[(String, UIViewController)] = [("Create", CreatePaymentViewController()), ("Saved", SavePaymentViewController()), ("History", HistoryPaymentViewController())]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.settingNavigationBar()
        self.registerTableViewCells()
    }
    
    private func settingNavigationBar() {
        if let navVC = self.navigationController {
            self.title = "Payments"
            navVC.navigationBar.tintColor = UIColor.white
        }
    }
    
    private func registerTableViewCells() {
        self.detailTable.register(UINib(nibName: "PaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "cellPayment")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentLabel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPayment", for: indexPath) as! PaymentTableViewCell
        
        cell.setupWith(name: self.paymentLabel[indexPath.row].0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let navVC = self.navigationController {
            navVC.pushViewController(self.paymentLabel[indexPath.row].1, animated: true)
        }
    }
}
