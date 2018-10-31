//
//  SavePaymentViewController.swift
//  VBank
//
//  Created by Vlad Birukov on 05.11.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import UIKit

class SavePaymentViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let repo = SavePaymentRepo.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settingRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.settingNavigationBar()
        self.registerTableViewCells()
        
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        
        self.repo.result.removeAll()
        self.detailTable.reloadData()
        
        self.repo.getSavePayment(controller: self, completionHandler: {
            self.indicator.stopAnimating()
            self.detailTable.reloadData()
        })
    }
    
    private func loadData(flag: Bool = true) {
        if flag == true {
            self.repo.result.removeAll()
            self.detailTable.reloadData()
        } else {
            self.repo.result.removeAll()
        }
        
        self.repo.getSavePayment(controller: self, completionHandler: {
            self.indicator.stopAnimating()
            self.detailTable.reloadData()
        })
    }
    
    private func settingNavigationBar() {
        if let navVC = self.navigationController {
            self.title = "Saved Payments"
            navVC.navigationBar.tintColor = UIColor.white
        }
    }
    
    private func settingRefresh(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(refreshOptions(sender:)),
                                 for: .valueChanged)
        self.detailTable.refreshControl = refreshControl
    }
    
    @objc private func refreshOptions(sender: UIRefreshControl) {
        sender.endRefreshing()
        
        self.loadData(flag: false)
    }
    
    private func registerTableViewCells() {
        self.detailTable.register(UINib(nibName: "SavePaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "cellSavePayment")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repo.result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSavePayment", for: indexPath) as! SavePaymentTableViewCell
        
        cell.setupWith(model: self.repo.result[indexPath.row])
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let navVC = self.navigationController {
            let nexController = PaymentSaveViewController()
            
            nexController.model = self.repo.result[indexPath.row]
            
            navVC.pushViewController(nexController, animated: true)
        }
    }

}
