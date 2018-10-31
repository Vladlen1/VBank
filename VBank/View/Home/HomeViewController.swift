//
//  HomeViewController.swift
//  VBank
//
//  Created by Vlad Birukov on 05.11.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import UIKit
import SideMenu

protocol BackDelegate {
    func back()
}

class HomeViewController: UIViewController, BackDelegate, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var detailTable: UITableView!
    
    let homeLabel: [(String, UIViewController)] = [("Accounts", AccountViewController()), ("Payments", PaymentViewController()), ("Exchange rates", ExchangeRateViewController())]
    let numberCell = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingSlideMenu()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.settingNavigationBar()
        self.registerTableViewCells()
    }
    
    private func registerTableViewCells() {
        self.detailTable.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "cellHome")
    }
    
    private func settingNavigationBar() {
        if let navVC = self.navigationController {
            self.title = "VBank"
            navVC.navigationBar.titleTextAttributes = [
                NSAttributedStringKey.foregroundColor : UIColor.white]
            navVC.navigationBar.barTintColor = ColorUtility.navigationBarColor()
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger"), style: .plain, target: self, action: #selector(showMenu(_:)))
            navVC.navigationBar.tintColor = UIColor.white
        }
    }
    
    private func settingSlideMenu() {
        let menuController = MenuViewController()
        menuController.delegate  = self
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: menuController)
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view, forMenu: .left)
        
        SideMenuManager.default.menuWidth = 0.7 * UIScreen.main.bounds.width
        SideMenuManager.default.menuPresentMode = .menuSlideIn

    }
    
    func back() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func showMenu(_ sender: Any) {
        self.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellHome", for: indexPath) as! HomeTableViewCell
        
        cell.setupWith(name: self.homeLabel[indexPath.row].0)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let navVC = self.navigationController {
            navVC.pushViewController(self.homeLabel[indexPath.row].1, animated: true)
        }
    }
}
