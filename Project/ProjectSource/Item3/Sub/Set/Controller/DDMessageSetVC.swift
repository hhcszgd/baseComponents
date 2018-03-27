//
//  DDMessageSetVC.swift
//  Project
//
//  Created by WY on 2018/2/1.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import UserNotifications
private let borderMargin : CGFloat = 10
private let rowH  : CGFloat = 44
class DDMessageSetVC: DDNormalVC {
    let notification = DDRowView.init(frame: CGRect(x: 0 , y: 0 , width: SCREENWIDTH - borderMargin*2 , height: rowH))
//    let sound =  DDRowView.init(frame: CGRect(x: 0 , y: 0 , width: SCREENWIDTH - borderMargin*2 , height: rowH))
//    let shake = DDRowView.init(frame: CGRect(x: 0 , y: 0 , width: SCREENWIDTH - borderMargin*2 , height: rowH))
    
    
    let notificationSwitch = UISwitch.init()
    let soundSwitch = UISwitch.init()
    let shakeSwitch = UISwitch.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息设置"
        self.view.backgroundColor = UIColor.DDLightGray1
        self.view.addSubview(notification)
//        self.view.addSubview(sound)
//        self.view.addSubview(shake)
        
        notification.titleLabel.text = "是否推送"
//        sound.titleLabel.text = "声音"
//        shake.titleLabel.text = "震动"
        
        notification.center = CGPoint(x: self.view.bounds.width/2, y: DDNavigationBarHeight + notification.bounds.height / 2 + 20)
//        sound.center = CGPoint(x: self.view.bounds.width/2, y: notification.frame.maxY + sound.bounds.height / 2 + 2)
//        shake.center = CGPoint(x: self.view.bounds.width/2, y: sound.frame.maxY + shake.bounds.height / 2 + 2)
        
        notificationSwitch.center = CGPoint(x: notification.bounds.width - notificationSwitch.bounds.width / 2 - 10, y: notification.bounds.height / 2)
        
//        soundSwitch.center = CGPoint(x: sound.bounds.width - soundSwitch.bounds.width / 2 - 10, y: sound.bounds.height / 2)
//
//        shakeSwitch.center = CGPoint(x: shake.bounds.width - shakeSwitch.bounds.width / 2 - 10, y: shake.bounds.height / 2)
        
        notification.diyView = notificationSwitch
//        sound.diyView = soundSwitch
//        shake.diyView = shakeSwitch
        notificationSwitch.addTarget(self , action: #selector(switchAction(sender:)), for: UIControlEvents.valueChanged)
//        soundSwitch.addTarget(self , action: #selector(switchAction(sender:)), for: UIControlEvents.valueChanged)
//        shakeSwitch.addTarget(self , action: #selector(switchAction(sender:)), for: UIControlEvents.valueChanged)
        requestSwitchStatus()
        // Do any additional setup after loading the view.
    }
    func requestSwitchStatus() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
                DispatchQueue.main.async {
                    if notificationSettings.authorizationStatus == .authorized{
                        DDRequestManager.share.getNotificationStatus()?.responseJSON(completionHandler: { (response) in
                            mylog(response.debugDescription)
                            if let apiModel = DDDecode(DDNotificationStatusApi.self , from: response){
                                mylog(apiModel.data.push_shock)
                                self.notificationSwitch.isOn = apiModel.data.push_status == "1" ? true : false
//                                self.soundSwitch.isOn = apiModel.data.push_voice == "1" ? true : false
//                                self.shakeSwitch.isOn = apiModel.data.push_shock == "1" ? true : false
                            }
                        })
                    }else{
                        self.notificationSwitch.isOn =  false
//                        self.soundSwitch.isOn =  false
//                        self.shakeSwitch.isOn =  false
                        GDAlertView.alert("通知不可用,请在设置中开启", image: nil, time: 2, complateBlock: nil )
                    }
                    if notificationSettings.soundSetting == .enabled{}
                    
                }
            }
        } else {
            // Fallback on earlier versions
            DDRequestManager.share.getNotificationStatus()?.responseJSON(completionHandler: { (response) in
                mylog(response.debugDescription)
                if let apiModel = DDDecode(DDNotificationStatusApi.self , from: response){
                    mylog(apiModel.data.push_shock)
                    self.notificationSwitch.isOn = apiModel.data.push_status == "1" ? true : false
//                    self.soundSwitch.isOn = apiModel.data.push_voice == "1" ? true : false
//                    self.shakeSwitch.isOn = apiModel.data.push_shock == "1" ? true : false
                }
            })
        }

    }
    @objc func commitSwitchStatus()  {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
                if notificationSettings.authorizationStatus == .authorized{
                    let notificationStatus = self.notificationSwitch.isOn ? "1" : "2"
                    let soundStatus = "2"//self.soundSwitch.isOn ? "1" : "2"
                    let shakeStatus = "2"//self.shakeSwitch.isOn ? "1" : "2"
                    DDRequestManager.share.setNotificationStatus(push_status: notificationStatus, push_shock: shakeStatus, push_voice: soundStatus)

                }else{
                    GDAlertView.alert("通知不可用,请在设置中开启", image: nil, time: 2, complateBlock: nil )
                }
                
            }
            
        }else{
            let notificationStatus = self.notificationSwitch.isOn ? "1" : "2"
            let soundStatus = "2"//self.soundSwitch.isOn ? "1" : "2"
            let shakeStatus = "2"//self.shakeSwitch.isOn ? "1" : "2"
            DDRequestManager.share.setNotificationStatus(push_status: notificationStatus, push_shock: shakeStatus, push_voice: soundStatus)
            
        }
        
    }
   @objc  func switchAction(sender : UISwitch)  {
//        sender.isOn
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
                DispatchQueue.main.async {
                    if notificationSettings.authorizationStatus == .authorized{
                            switch sender {
                            case self.notificationSwitch:
                                if sender.isOn == false {
//                                    self.soundSwitch.isOn = false ;
//                                    self.shakeSwitch.isOn = false ;
                                }
                            case self.soundSwitch:
                                if sender.isOn == true  {
                                    self.notificationSwitch.isOn = true  ;
                                }
                            case self.shakeSwitch:
                                if sender.isOn == true  {
                                    self.notificationSwitch.isOn = true  ;
                                }
                            default:
                                break
                            }
                            self.commitSwitchStatus()
                    }else{
                        sender.setOn(false, animated: true )
                        GDAlertView.alert("通知不可用,请在设置中开启", image: nil, time: 2, complateBlock: nil )
                    }
                }
                
            }
        } else {
            // Fallback on earlier versions
            switch sender {
            case notificationSwitch:
                if sender.isOn == false {
//                    soundSwitch.isOn = false ;
//                    shakeSwitch.isOn = false ;
                }
//            case soundSwitch:
//                if sender.isOn == true  {
//                    notificationSwitch.isOn = true  ;
//                }
//            case shakeSwitch:
//                if sender.isOn == true  {
//                    notificationSwitch.isOn = true  ;
//                }
            default:
                break
            }
            commitSwitchStatus()
        }
    
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
class DDNotificationStatusApi: NSObject , Codable {
    var message = ""
    var status : Int = -1
    var data : DDNotificationStatusData = DDNotificationStatusData()
}
class DDNotificationStatusData: NSObject , Codable {
    var push_shock : String? = ""
    var push_status  = ""
    var push_voice : String? = ""
}
