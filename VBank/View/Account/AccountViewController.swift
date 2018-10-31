//
//  AccountViewController.swift
//  VBank
//
//  Created by Vlad Birukov on 05.11.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let repo = AccountsRepo.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settingRefresh()
    }
    
    private func loadData(flag: Bool = true) {
        if flag == true  {
            self.indicator.isHidden = false
            self.indicator.startAnimating()
            self.repo.result.removeAll()
            self.detailTable.reloadData()
        } else {
            self.repo.result.removeAll()
        }
        
        
        self.repo.execute(controller: self, completionHandler: {
            self.detailTable.reloadData()
            self.indicator.stopAnimating()
        })
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadData()
        self.settingNavigationBar()
        self.registerTableViewCells()
    }

    private func settingNavigationBar() {
        if let navVC = self.navigationController {
            self.title = "Accounts"
            navVC.navigationBar.tintColor = UIColor.white
        }
    }
    
    private func registerTableViewCells() {
        self.detailTable.register(UINib(nibName: "AccountTableViewCell", bundle: nil), forCellReuseIdentifier: "cellAcount")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repo.result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAcount", for: indexPath) as! AccountTableViewCell
        
        cell.setupWith(model: self.repo.result[indexPath.row])
        
        return cell
    }
    
}
