//
//  HistoryPaymentViewController.swift
//  VBank
//
//  Created by Vlad Birukov on 05.11.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import UIKit

class HistoryPaymentViewController: UIViewController, UITableViewDataSource,UITableViewDelegate  {
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var indexHistory = 0
    let historyLabelText = [("Last 10 days", -10), ("Last 30 days", -30), ("Last 90 days", -90)]
    
    
    let repo = HistoryPaymentRepo()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.settingNavigationBar()
        self.registerTableViewCells()
        
        self.repo.result = [nil, nil , nil]
        self.detailTable.reloadData()
        self.loadData()
    }
    
    private func loadData() {
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        
        let calendar = Calendar.current
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let dateTo = dateFormat.string(from: Date()).replacingOccurrences(of: " ", with: "T")
        let dateFrom = dateFormat.string(from: (calendar.date(byAdding: .day, value: self.historyLabelText[self.indexHistory].1, to: Date(), wrappingComponents: false))!).replacingOccurrences(of: " ", with: "T")
        
        self.repo.getExternalPay(controller: self, index: self.indexHistory,fromDate: dateFrom, toDate: dateTo, completionHandler: {
            self.repo.getInternalPay(controller: self, index: self.indexHistory,fromDate: dateFrom, toDate: dateTo, completionHandler: {
                self.indicator.stopAnimating()
                self.detailTable.reloadData()
            })

        })
        
    }
    
    private func settingNavigationBar() {
        if let navVC = self.navigationController {
            self.title = "History Payments"
            navVC.navigationBar.tintColor = UIColor.white
        }
    }
    
    private func registerTableViewCells() {
        self.detailTable.register(UINib(nibName: "SavePaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "cellSavePayment")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.repo.result[self.indexHistory] != nil {
            return self.repo.result[self.indexHistory]!.count

        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSavePayment", for: indexPath) as! SavePaymentTableViewCell

        if self.repo.result[indexHistory] != nil && indexPath.row < (self.repo.result[indexHistory]?.count)! {
            cell.setupWith(model: self.repo.result[indexHistory]![indexPath.row])
        }
        
        return cell
    }
    
    @IBAction func last(_ sender: UIButton) {
        if self.indexHistory == 0 {
            self.indexHistory = 2
            self.historyLabel.text = self.historyLabelText[self.indexHistory].0
        } else {
            self.indexHistory -= 1
            self.historyLabel.text = self.historyLabelText[self.indexHistory].0
        }
        
        if self.repo.result[self.indexHistory] == nil {
            self.indicator.isHidden = false
            self.indicator.startAnimating()
            
            self.loadData()
        } else {
            self.detailTable.reloadData()

        }
        
    }
    
    @IBAction func next(_ sender: UIButton) {
        if self.indexHistory == 2 {
            self.indexHistory = 0
            self.historyLabel.text = self.historyLabelText[self.indexHistory].0
        } else {
            self.indexHistory += 1
            self.historyLabel.text = self.historyLabelText[self.indexHistory].0
        }
        
        if self.repo.result[self.indexHistory] == nil {
            self.indicator.isHidden = false
            self.indicator.startAnimating()
            
            self.loadData()
        } else {
            self.detailTable.reloadData()

        }
    }
}
