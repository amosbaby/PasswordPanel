//
//  UIView+Frame.swift
//  AmosPasswordStore
//
//  Created by amos on 2016/11/4.
//  Copyright © 2016年 amos. All rights reserved.
//



import UIKit
//屏幕的宽
let kScreenWidth  = UIScreen.main.bounds.width

//屏幕的高
let kScreenHeight  = UIScreen.main.bounds.height
extension UIView{
    
    var size:CGSize {
         get{
            return self.frame.size
        }
         set{
            self.frame.size = newValue
        }
    }
    
    var origin: CGPoint {
         get{
            return self.frame.origin
        }
         set{
            self.frame.origin = newValue
        }
    }
    
    
    var width:CGFloat{
         get{
            return self.size.width
        }
        set{
            self.size.width = newValue
        }
    }
    
    var height:CGFloat{
         get{
            return self.size.height
        }
        set{
            self.size.height = newValue
        }
    }
    
    var x:CGFloat{
        get{
            return self.origin.x
        }
        set{
            self.origin.x = newValue
        }
    }
    
    var y:CGFloat{
        get{
            return self.origin.y
        }
        set{
            self.origin.y = newValue
        }
    }
}
