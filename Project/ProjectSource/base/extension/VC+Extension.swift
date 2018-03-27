//
//  VC+Extension.swift
//  Project
//
//  Created by WY on 2018/2/28.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import Foundation
extension UIViewController {
    func pushVC(vcIdentifier : String , userInfo:Any? = nil ) {
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"]as! String
        var clsName = vcIdentifier
        if !vcIdentifier.hasPrefix(namespace + ".") {
            clsName = namespace + "." + vcIdentifier
        }
        //UICollectionViewController
        if let cls = NSClassFromString(clsName) as? UICollectionViewController.Type{
            let vc = cls.init(collectionViewLayout: UICollectionViewFlowLayout())
            vc.userInfo = userInfo
            self.navigationController?.pushViewController(vc, animated: true)
        }else if let cls = NSClassFromString(clsName) as? UIViewController.Type{
            let vc = cls.init()
            vc.userInfo = userInfo
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            print("there is no class:\(vcIdentifier)  from string:\(vcIdentifier)")
        }
    }
    static var userInfo: Void?
    /** key parameter of viewController */
    @IBInspectable var userInfo: Any? {
        get {
            return objc_getAssociatedObject(self, &UIViewController.userInfo)
        }
        set(newValue) {
            objc_setAssociatedObject(self, &UIViewController.userInfo, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
