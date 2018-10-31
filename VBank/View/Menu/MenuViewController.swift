//
//  MenuViewController.swift
//  VBank
//
//  Created by Vlad Birukov on 05.11.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var detailTable: UITableView!
    
    var delegate: BackDelegate?
    let menuLabel = ["Change email", "Change password", "Logout"]
    let numberCell = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.settingNavigationBar()
    }

    private func settingNavigationBar() {
        if self.navigationController != nil {
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    func registerTableViewCells() {
        self.detailTable.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "cellMenu")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMenu", for: indexPath) as! MenuTableViewCell
        
        cell.setupWith(name: self.menuLabel[indexPath.row])
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 2 {
            
            if indexPath.row == 0 {
                let controller = ChangeEmailViewController()
                controller.delegate = delegate
                
                self.present(BaseNavigationController.init(rootViewController: controller), animated: true, completion: nil)
            } else {
                let controller = ChangePasswordViewController()
                
                controller.delegate = delegate
                
                self.present(BaseNavigationController.init(rootViewController: controller), animated: true, completion: nil)
            }
            
        } else {
            let logoutRepo = LoginRepo()
            
            logoutRepo.logout()
            
            self.dismiss(animated: false, completion: {
                if self.delegate != nil {
                    self.delegate!.back()
                }
            })
        }
    }
}
