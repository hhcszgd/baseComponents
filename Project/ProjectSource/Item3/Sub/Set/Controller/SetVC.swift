//
//  SetVC.swift
//  Project
//
//  Created by 张凯强 on 2018/1/19.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
private let borderMargin : CGFloat = 10
private let rowH  : CGFloat = 44
class SetVC: GDNormalVC {
    var telephone: String = "400-988-1818"
    let setwithPassword = DDRowView.init(frame: CGRect(x: 0 , y: 0 , width: SCREENWIDTH - borderMargin*2 , height: rowH))
    
    let changePw = DDRowView.init(frame: CGRect(x: 0 , y: 0 , width: SCREENWIDTH - borderMargin*2 , height: rowH))
    let msgSet = DDRowView.init(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH - borderMargin*2 , height: rowH))
    let connectUs = DDRowView.init(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH - borderMargin*2 , height: rowH))
    let clearDisk = DDRowView.init(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH - borderMargin*2 , height: rowH))
    let loginOut = DDRowView.init(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH - borderMargin*2 , height: rowH))
    override func viewDidLoad() {
        super.viewDidLoad()
        let token = DDAccount.share.token ?? ""
        let paramete = ["token": token]
        NetWork.manager.requestData(router: Router.get("system/telephone", .api, paramete)).subscribe(onNext: { (dict) in
            if let data = dict["data"] as? [String: AnyObject] {
                if let telephone = data["telephone"] as? String {
                    self.telephone = telephone
                    self.setValue(title: "联系我们", subTitle: telephone , arrowHidden : true , to: self.connectUs)
                }
            }
            
            
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("#f0f0f0")
        self.naviBar.backgroundColor = .white 
        self._configSubviews()
        // Do any additional setup after loading the view.
    }
    func _configSubviews()  {
        self.view.addSubview(setwithPassword)
        self.view.addSubview(changePw)
        self.view.addSubview(msgSet)
        self.view.addSubview(connectUs)
        self.view.addSubview(clearDisk)
        self.view.addSubview(loginOut)
        setwithPassword.addTarget(self , action: #selector(rowActionClick(sender:)), for: UIControlEvents.touchUpInside)
        changePw.addTarget(self , action: #selector(rowActionClick(sender:)), for: UIControlEvents.touchUpInside)
        msgSet.addTarget(self , action: #selector(rowActionClick(sender:)), for: UIControlEvents.touchUpInside)
        connectUs.addTarget(self , action: #selector(rowActionClick(sender:)), for: UIControlEvents.touchUpInside)
        clearDisk.addTarget(self , action: #selector(rowActionClick(sender:)), for: UIControlEvents.touchUpInside)
        loginOut.addTarget(self , action: #selector(rowActionClick(sender:)), for: UIControlEvents.touchUpInside)
        changePw.center = CGPoint(x: SCREENWIDTH/2, y: DDNavigationBarHeight + 30 + rowH/2)
        setwithPassword.center = CGPoint.init(x: SCREENWIDTH / 2, y: changePw.max_Y + 2 + rowH/2)
        
        msgSet.center = CGPoint(x: SCREENWIDTH/2, y: setwithPassword.frame.maxY + 2 + rowH/2)
        connectUs.center = CGPoint(x: SCREENWIDTH/2, y: msgSet.frame.maxY + 22 + rowH/2)
        clearDisk.center = CGPoint(x: SCREENWIDTH/2, y: connectUs.frame.maxY + 2 + rowH/2)
        loginOut.center = CGPoint(x: SCREENWIDTH/2, y: clearDisk.frame.maxY + 22 + rowH/2)
        setValue(title: "提现密码", subTitle: nil, arrowHidden: false, to: setwithPassword)
        setValue(title: "更改密码", subTitle: nil , arrowHidden : false , to: changePw)
        setValue(title: "消息设置", subTitle: nil , arrowHidden : false , to: msgSet)
        setValue(title: "联系我们", subTitle: self.telephone , arrowHidden : true , to: connectUs)
        var cach = CGFloat (SDImageCache.shared().getSize()) / 1024 / 1024
        cach = cach < 1 ? 0 : cach
        let cachFormate = String.init(format: "%.02f", cach )
        setValue(title: "空间清理", subTitle: cachFormate + "MB" , arrowHidden : false , to: clearDisk)
        setValue(title: "退出账号", subTitle: nil , arrowHidden : true , to: loginOut)
    }
    func setValue(title : String , subTitle:String? , arrowHidden : Bool = true ,to : DDRowView) {
        to.titleLabel.text = title
        to.subTitleLabel.text = subTitle
        to.additionalImageView.isHidden = arrowHidden
    }
    @objc func rowActionClick(sender : DDRowView) {
        switch sender {
        case setwithPassword:
            self.navigationController?.pushViewController(SetWithDrawalVC(), animated: true)
        case changePw:
            mylog(sender.titleLabel.text)
            self.navigationController?.pushViewController(ChanagePasswordVC(), animated: true )
        case msgSet:
            mylog(sender.titleLabel.text)
            self.navigationController?.pushViewController(DDMessageSetVC(), animated: true )
            
        case connectUs:
            
            UIApplication.shared.openURL(URL(string: "telprompt:\(self.telephone)")!)
            mylog(sender.titleLabel.text)
        case clearDisk:
            SDImageCache.shared().clearDisk()
            SDImageCache.shared().clearMemory()
            SDImageCache.shared().cleanDisk()
            let cach = SDImageCache.shared().getSize() / 1024 / 1024
            setValue(title: "空间清理", subTitle: "0MB" , arrowHidden : false , to: clearDisk)
        case loginOut:
            mylog(sender.titleLabel.text)
            let token: String = DDAccount.share.token ?? ""
            let parameter = ["token": token, "equipment_number": UUID]
            NetWork.manager.requestData(router: Router.post("member/logout", .api, parameter)).subscribe(onNext: { (dict) in
                let data = BaseModel<GDModel>.deserialize(from: dict)
                if data?.status == 200 {
                    DDAccount.share.deleteAccountFromDisk()
                    GDAlertView.alert("退出成功", image: nil , time: 2, complateBlock: {
                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                            appDelegate.configRootVC()
                        }
                    })
                }else {
                    GDAlertView.alert("退出失败请重试", image: nil, time: 1, complateBlock: nil)
                }
            }, onError: { (error) in
                GDAlertView.alert("退出失败请重试", image: nil, time: 1, complateBlock: nil)
            }, onCompleted: {
                
            }, onDisposed: {
                
            })
        default:
            break
        }
    }
    override func gdAddSubViews() {
         self.naviBar.title = "设置"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
