//
//  ChangePhoneVC.swift
//  Project
//
//  Created by 张凯强 on 2018/1/14.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class ChangePhoneVC: GDNormalVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet var titleTop: NSLayoutConstraint!
 
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var phoneTitle: UILabel!
    @IBOutlet var vergisionTitle: UILabel!
    @IBOutlet var phoneTextfield: CustomTextfield!
    @IBOutlet var versionTextfield: CustomTextfield!
    @IBOutlet var passwordTitle: UILabel!
    @IBOutlet var passwordTextfield: CustomTextfield!
    
    @IBOutlet var sureBtn: UIButton!
    
    @IBAction func sureBtnAction(_ sender: UIButton) {
        
        let token = DDAccount.share.token ?? ""
        let id = DDAccount.share.id ?? ""
        let paramete = ["token": token, "mobile": self.phone, "password": self.password, "verify": self.verfication]
        NetWork.manager.requestData(router: Router.put("member/\(id)/mobile", .api, paramete)).subscribe(onNext: { (dict) in
            let model = BaseModel<GDModel>.deserialize(from: dict)
            if model?.status == 200 {
                self.send.onNext(self.phone)
                self.send.onCompleted()
                self.navigationController?.popViewController(animated: true)
            }else {
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
                
            }
        }, onError: { (error) in
            GDAlertView.alert("网络错误请稍后重试", image: nil, time: 1, complateBlock: nil)
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
        
    }
    var send: PublishSubject<String> = PublishSubject<String>.init()
    
    
    @IBOutlet var prompt: UILabel!
    
    override func gdAddSubViews() {
        
        self.titleTop.constant = DDNavigationBarHeight
        self.view.layoutIfNeeded()
        self.phoneTextfield.leftViewMode = .always
        self.phoneTextfield.leftView = self.phoneCode
        self.verificationBtn.backgroundColor = UIColor.clear
        self.phoneTextfield.rx.text.orEmpty.subscribe(onNext: { (text) in
            self.phone = text
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        self.versionTextfield.rx.text.orEmpty.subscribe(onNext: { (text) in
            self.verfication = text
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        self.passwordTextfield.rx.text.orEmpty.subscribe(onNext: { (text) in
            self.password = text
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        
    }
    
    
    
    
    var phone: String = ""
    var verfication: String = ""
    var password: String = ""
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func verficationActin(btn: UIButton) {
        if !self.phone.mobileLawful() {
            GDAlertView.alert("手机号码格式不对", image: nil, time: 1, complateBlock: nil)
            return
        }
        btn.isEnabled = false
        
        self.timer = Timer.init(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        let paramete = ["mobile": self.phone, "type": 3] as! [String: Any]
        NetWork.manager.requestData(router: Router.get("verify", .api, paramete)).subscribe(onNext: { (dict) in
            let model = BaseModel<DDAccount>.deserialize(from: dict)
            if model?.status == 200 {
                if let timer = self.timer {
                    RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
                }
                
            }else {
                self.timer?.invalidate()
                self.leftTime = 60
                self.verificationBtn.isEnabled = false
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
    }
    
    
    @objc func phoneCodeAction(btn: UIButton) {
        
    }
    lazy var phoneCode: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("+86", for: .normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("333333"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.frame = CGRect.init(x: 0, y: 0, width: 50, height: 40)
        let rightlineView = UIView.init()
        rightlineView.backgroundColor = lineColor
        btn.addSubview(rightlineView)
        rightlineView.frame = CGRect.init(x: 45, y: 10, width: 1, height: 30)
        
        btn.addTarget(self, action: #selector(phoneCodeAction(btn:)), for: .touchUpInside)
        return btn
    }()
    var timer: Timer?
    var leftTime: Int = 60
    @objc func countDown() {
        let count = String(self.leftTime) + "秒后重新发送"
        
        if self.leftTime < 1 {
            self.leftTime = 60
            self.verificationBtn.isEnabled = true
            self.timer?.invalidate()
        }
        leftTime -= 1
        
        self.verificationBtn.setTitle(count, for: .disabled)
        //请求二维码的接口
        
        
    }
    
    lazy var verificationBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 122, height: 38))
        btn.setTitle("发送验证码", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ea9061"), for: .normal)
        btn.addTarget(self, action: #selector(verficationActin(btn:)), for: .touchUpInside)
        self.versionTextfield.rightViewMode = UITextFieldViewMode.always
        self.versionTextfield.rightView = btn
        return btn
    }()
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
