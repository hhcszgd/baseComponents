//
//  UINavigationController+extention.swift
//  Project
//
//  Created by WY on 2018/3/14.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

extension UINavigationController{
@discardableResult
    func popToSpecifyVC(_ vcType : UIViewController.Type , animate:Bool = true ) -> UIViewController? {
        for vc  in self.viewControllers{
            if vc.isKind(of: vcType){
                self.popToViewController(vc , animated: animate)
                return vc
            }
        }
        return nil
    }

}
