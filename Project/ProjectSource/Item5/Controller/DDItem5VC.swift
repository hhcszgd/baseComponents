//
//  DDItem5VC.swift
//  ZDLao
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit

class DDItem5VC: HomeWebVC {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let showModel : DDActionModel = DDActionModel()
//        showModel.keyParameter = "http://wap.bjyltf.cc/shop/create"
        /*
         http://wap.bjyltf.cc/shop/create?type=yewu&token=123
         http://wap.bjyltf.cc/shop/create?type=dianpu&token=123
         */
        //http://wap.bjyltf.com/index
//        showModel.keyParameter = DomainType.wap.rawValue +  "index"
        self.userInfo = DomainType.wap.rawValue +  "index"
//        showModel.keyParameter = "http://172.16.2.43:8020/mwap/index.html"
//        self.showModel = showModel
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.scrollView.bounces = false
        var  webViewY : CGFloat = 64
        if DDDevice.type == .iphoneX {webViewY = 44}else{webViewY = 20}
        var webViewH = UIScreen.main.bounds.height - webViewY
        if self.isFirstVCInNavigationVC{
            if DDDevice.type == .iphoneX {webViewH -= 83}else{
                webViewH -= 44
            }
        }else{
            if DDDevice.type == .iphoneX {webViewH -= 34}
        }
        
        self.webView.frame = CGRect(x: 0.0, y: webViewY, width: UIScreen.main.bounds.width, height: webViewH)
        self.naviBar.isHidden = true 
//        self.navigationController?.setNavigationBarHidden(<#T##hidden: Bool##Bool#>, animated: <#T##Bool#>)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
