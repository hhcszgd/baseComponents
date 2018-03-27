//
//  AboutVC.swift
//  Project
//
//  Created by 张凯强 on 2018/2/11.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class AboutVC: GDNormalVC {

    @IBOutlet var top: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = lineColor
        // Do any additional setup after loading the view.
    }
    override func gdAddSubViews() {
        self.naviBar.title = "关于"
        self.top.constant = DDNavigationBarHeight + 10
        self.checkVersion()
        
    }
    

    @IBOutlet var version: UILabel!
    @IBAction func jianchaAction(_ sender: UITapGestureRecognizer) {
        if let url = self.url, let type = self.type, let version = self.versionValue {
            self.updateVerson(url: url, type: type, version: version)
        }else {
            GDAlertView.alert("没有新版本", image: nil, time: 1, complateBlock: nil)
        }
        
    }
    @IBAction func fuwuAction(_ sender: UITapGestureRecognizer) {
//        let model = DDActionModel.init()
//        model.keyParameter = BaseUrlStr.web.rawValue + "member_agreement"
//        let web : HomeWebVC = HomeWebVC()
//        web.showModel = model
//        self.navigationController?.pushViewController(web , animated: true )
        self.pushVC(vcIdentifier: "HomeWebVC", userInfo: BaseUrlStr.web.rawValue + "member_agreement")
    }
    @IBAction func jianzhiAction(_ sender: UITapGestureRecognizer) {
//        let model = DDActionModel.init()
//        model.keyParameter =  BaseUrlStr.web.rawValue + "concurrent_post_agreement"
//        let web : HomeWebVC = HomeWebVC()
//        web.showModel = model
//        self.navigationController?.pushViewController(web , animated: true )
        self.pushVC(vcIdentifier: "HomeWebVC", userInfo: BaseUrlStr.web.rawValue + "concurrent_post_agreement")
        
        
    }
    
    @IBOutlet var versionStatus: UILabel!
    
    
    
    var url: URL?
    var type: String?
    var versionValue: String?
    func checkVersion() {
        guard let ion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String  else {
            return
            
        }
        self.version.text = "玉龙传媒V" + ion
        NetWork.manager.requestData(router: Router.get("version", BaseUrlStr.api, ["app_type": 2])).subscribe(onNext: { (dict) in
            let model = BaseModel<VersionModel>.deserialize(from: dict)
            if model?.status == 200 {
                
                if ion != model?.data?.version {
                    self.versionValue = model?.data?.version
                    guard let url = URL.init(string: "https://itunes.apple.com/us/app/%e7%8e%89%e9%be%99%e4%bc%a0%e5%aa%92/id1335870775?l=zh&ls=1&mt=8") else {
                        return
                    }
                    self.url = url
                    if let type = model?.data?.uptype {
                        self.type = type
                    }
                    self.versionStatus.text = "有新版本可用"
                    
                }else {
                    self.versionStatus.text = "版本不需要更新"
                }
            }else {
                self.versionStatus.text = "版本不需要更新"
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }, onDisposed: {
            mylog("回收")
        })
       
    }
    
    
    func updateVerson(url: URL, type: String, version: String) {
        if let ion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String, ion == version {
            return
           
        }
        let title = "\n 更新新版本\(version) \n"
        let alertVC = UIAlertController.init(title: title, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let cancleAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
            
        }
        let trueAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { (action) in
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
        if type == "2"{
            alertVC.addAction(cancleAction)
        }
        
        alertVC.addAction(trueAction)
        self.present(alertVC, animated: true, completion: nil)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
