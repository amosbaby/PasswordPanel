//
//  LoginViewController.swift
//  AmosPasswordStore
//
//  Created by amos on 2016/11/4.
//  Copyright © 2016年 amos. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {

    var password:[Int] = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI(){
        let width = kScreenWidth
        let y = (kScreenHeight - width) * 0.2
        let gpView =  GesturePasswordView(frame: CGRect(x: 0, y: y, width: width, height: width),controller:self)
        
        self.view.addSubview(gpView)
    }
    
    
    /// 保存登录密码
    func savePassword(){
        
        UserDefaults.standard.setValue(self.password, forKeyPath: "password")
        
    }
    
    /// 从本地取出密码
    func getPassword(){
        
        if let pwd = UserDefaults.standard.value(forKey: "password"){
            self.password = pwd as! [Int]
        }
        
    }
}
