//
//  BirthdayViewController.swift
//  VBank
//
//  Created by Vlad Birukov on 07.12.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import UIKit

class BirthdayViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var resultBithday: String?
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGesture()
        
        if self.image != nil {
            self.backgroundImage.image = self.image
        }
        
        let calendar = Calendar.current
        let data = calendar.date(byAdding: .year, value: -18, to: Date())

        
        self.datePicker.maximumDate = data
        
        if self.resultBithday == nil {
            let data = calendar.date(byAdding: .month, value: -168, to: Date())
            self.dateFormat(date: data!)
        } else {
            self.datePicker.setDate(self.stringToDate(string: self.resultBithday!), animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        if self.navigationController != nil {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    @IBAction func backward(_ sender: Any) {
        if let navVC = self.navigationController {
            navVC.popViewController(animated: false)
        }
    }
    
    @IBAction func changeDate(_ sender: Any) {
        self.dateFormat(date: self.datePicker.date)
    }
    
    @IBAction func saveDate(_ sender: Any) {
        if let navVC = self.navigationController {
            let parentController = navVC.viewControllers[1] as? SignUpViewController
            
            if parentController != nil {
                parentController?.birthdayButton.setTitle(self.resultBithday, for: .normal)
            }
            
            navVC.popViewController(animated: false)
        }
    }
    
    private func dateFormat(date: Date) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd.MM.yyyy"
        
        self.resultBithday = dateFormat.string(from: date)
    }
    
    private func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.backgroundView.addGestureRecognizer(tap)
        self.backgroundView.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if let navVC = self.navigationController {
            navVC.popViewController(animated: false)
        }
    }
    
    private func stringToDate(string: String) -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd.MM.yyyy"
        
        return dateFormat.date(from: string)!
    }
}
