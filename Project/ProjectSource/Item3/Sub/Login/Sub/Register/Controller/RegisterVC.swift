//
//  RegisterVC.swift
//  Project
//
//  Created by 张凯强 on 2018/1/2.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class RegisterVC: GDNormalVC, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        if DDDevice.type == .iPhone4 {
            self.backScrollView.isScrollEnabled = true
        }
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var top: NSLayoutConstraint!
    
    override func gdAddSubViews() {
        self.top.constant = DDNavigationBarHeight - 10
        self.naviBar.naviagationBackImage.isHidden = true
        self.registerPasswordRightBtn.backgroundColor = UIColor.clear
        self.verificationBtn.backgroundColor = UIColor.clear
        
        self.lineView(textField: self.registerName)
        self.lineView(textField: self.registerVergion)
        self.lineView(textField: self.jobNumber)
        self.lineView(textField: self.password)
        self.view.layoutIfNeeded()
        self.registerName.leftView = self.phoneCode
        self.registerName.leftViewMode = UITextFieldViewMode.always
        self.registerVergion.leftViewMode = .always
        self.registerVergion.leftView = self.createView()
        self.registerVergion.rightViewMode = .always
        self.registerVergion.rightView = self.verificationBtn
        self.jobNumber.leftViewMode = .always
        self.jobNumber.leftView = self.createView()
        self.password.leftViewMode = .always
        self.password.leftView = self.createView()
        self.judgeBtn.backgroundColor = UIColor.clear
        self.registerName.rx.text.orEmpty.subscribe(onNext: { (text) in
            self.phone = text
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
        self.registerVergion.rx.text.orEmpty.subscribe(onNext: { (text) in
            self.vergion = text
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
        self.jobNumber.rx.text.orEmpty.subscribe(onNext: { (text) in
            self.jobNumberStr = text
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
        self.password.rx.text.orEmpty.subscribe(onNext: { (text) in
            self.passwordStr = text
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
        
        self.registerName.keyboardType = .numberPad
        self.registerVergion.keyboardType = .numberPad
        self.registerName.delegate = self
        self.registerVergion.delegate = self
        self.jobNumber.delegate = self
        self.password.delegate = self
//        self.jobName.text = "姓名："
//        self.jobMobile.text = "电话："
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    let bag = DisposeBag()
    var phone: String = ""
    var vergion: String = ""
    var jobNumberStr: String = ""
    var passwordStr: String = ""

    
    
    
    @IBAction func keyboardHidden(_ sender: UITapGestureRecognizer) {
        self.registerName.resignFirstResponder()
        self.registerVergion.resignFirstResponder()
        self.jobNumber.resignFirstResponder()
        self.password.resignFirstResponder()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyBoardY: CGFloat = SCREENHEIGHT - (self.keyBoardHeight)
        if self.registerVergion.isFirstResponder {
            let Y: CGFloat = self.jobNumber.convert(self.jobNumber.bounds, to: self.view).origin.y + self.jobNumber.bounds.size.height
            if Y > keyBoardY {
                let move = Y - keyBoardY
                mylog(move)
                self.backScrollView.setContentOffset(CGPoint.init(x: 0, y: move), animated: true)
            }
            
            
        }
        
        if self.jobNumber.isFirstResponder {
            let Y: CGFloat = self.password.convert(self.password.bounds, to: self.view).origin.y + self.password.bounds.size.height
            if Y > keyBoardY {
                let move = Y - self.keyBoardHeight
                self.backScrollView.setContentOffset(CGPoint.init(x: 0, y: move), animated: true)
            }
        }
        
        if self.password.isFirstResponder {
            let Y: CGFloat = self.password.convert(self.password.bounds, to: self.view).origin.y + self.password.bounds.size.height
            if Y > keyBoardY {
                let move = Y - self.keyBoardHeight
                self.backScrollView.setContentOffset(CGPoint.init(x: 0, y: move), animated: true)
            }
        }
        
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    var keyBoardHeight: CGFloat = 280
    @objc func keyboardWillShow(notification: Notification) {
        
        if let keyBoardFrameValue = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? AnyObject, let keyBoardFrame = keyBoardFrameValue.cgRectValue {
            let keyboardHeight: CGFloat = keyBoardFrame.height
            self.keyBoardHeight = keyboardHeight
//            let keyboardY: CGFloat = SCREENHEIGHT - keyboardHeight
//            if self.registerBtn.max_Y > keyboardY {
//
//                let move: CGFloat = self.registerBtn.max_Y - keyboardY
//                self.backScrollView.setContentOffset(CGPoint.init(x: 0, y: move), animated: true)
//
//
//            }
            
        }
    }
    @objc func keyboardWillHidden(notification: Notification) {
        
        self.backScrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        
    }
    
    
    @objc func verficationActin(btn: UIButton) {
        if !self.phone.mobileLawful() {
            GDAlertView.alert("手机号码格式不对", image: nil, time: 1, complateBlock: nil)
            return
        }
        
        
        btn.isEnabled = false
        self.timer = Timer.init(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        
       
        
        let paramete = ["mobile": self.phone, "type": 1] as! [String: Any]
        NetWork.manager.requestData(router: Router.get("verify", .api, paramete)).subscribe(onNext: { (dict) in
            let model = BaseModel<DDAccount>.deserialize(from: dict)
            if model?.status == 200 {
                if let timer = self.timer {
                    RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
                }
                
                
            }else {
                self.verificationBtn.isEnabled = true
                self.leftTime = 60
                self.timer?.invalidate()
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
            }
        }, onError: { (error) in
            self.verificationBtn.isEnabled = true
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
    }
    
    func createView() -> UIView {
        let view = UIView.init()
        view.frame = CGRect.init(x: 0, y: 0, width: 5, height: 20)
        return view
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
    
    @IBOutlet var jobName: UILabel!
    @IBOutlet var jobMobile: UILabel!
    @objc func judgeJobNumberAction(btn: UIButton) {
        let token: String = DDAccount.share.token ?? ""
        if self.jobNumberStr.count <= 0 {
            GDAlertView.alert("工号不能为空", image: nil, time: 1, complateBlock: nil)
            return
        }
        let paramete: [String: Any] = ["token": token]
        let id = self.jobNumberStr
        NetWork.manager.requestData(router: Router.get("member/\(id)/parent", .api, paramete)).subscribe(onNext: { [weak self](dict) in
            let model = BaseModel<DDAccount>.deserialize(from: dict)
            if model?.status == 200 {
                if let data = model?.data {
                    self?.jobName.text = "姓名：" + (data.name ?? "")
                    self?.jobMobile.text = "电话：" + (data.mobile ?? "")
                }
            }else {
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    
    func lineView(textField: UITextField) {
        let view = UIView.init()
        view.backgroundColor = lineColor
        textField.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    func leftView(textField: UITextField, leftImageStr: String) {
        let image = UIImageView.init()
        image.contentMode = UIViewContentMode.center
        image.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        image.image = UIImage.init(named: leftImageStr)
        textField.leftViewMode = UITextFieldViewMode.always
        textField.leftView = image
    }
    lazy var verificationBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 122, height: 38))
        btn.setTitle("发送验证码", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ea9061"), for: .normal)
        btn.addTarget(self, action: #selector(verficationActin(btn:)), for: .touchUpInside)
        self.registerVergion.rightViewMode = UITextFieldViewMode.always
        self.registerVergion.rightView = btn
        return btn
    }()
    
    
    lazy var judgeBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 38))
        btn.setTitle("检验工号", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ea9061"), for: .normal)
        btn.addTarget(self, action: #selector(judgeJobNumberAction(btn:)), for: .touchUpInside)
        self.jobNumber.rightViewMode = UITextFieldViewMode.always
        self.jobNumber.rightView = btn
        return btn
    }()
    
    
    lazy var registerPasswordRightBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        btn.setImage(UIImage.init(named: "hidden_password"), for: .normal)
        btn.setImage(UIImage.init(named: "show_the_password"), for: .selected)
        btn.addTarget(self, action: #selector(showBtnAction(btn:)), for: .touchUpInside)
        return btn
    }()
    @objc func showBtnAction(btn: UIButton) {
        btn.isSelected = !btn.isSelected
    }
    @IBOutlet var backScrollView: UIScrollView!
    
    @IBOutlet var registerName: UITextField!
    
    @IBOutlet var registerVergion: UITextField!
    
    @IBOutlet var jobNumber: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var selctBtn: UIButton!
    
    @IBAction func selectAction(_ sender: UIButton) {
        
    }
    @IBOutlet var propmtLabel: UILabel!
    
    @IBOutlet var protocolBtn: UIButton!
    
    @IBAction func jianzhi(_ sender: UIButton) {
//        let model = DDActionModel.init()
//        model.keyParameter =  BaseUrlStr.web.rawValue + "concurrent_post_agreement"
//        let web : HomeWebVC = HomeWebVC()
//        web.showModel = model
//        self.navigationController?.pushViewController(web , animated: true )
        
        
        self.pushVC(vcIdentifier: "HomeWebVC", userInfo: BaseUrlStr.web.rawValue + "concurrent_post_agreement")
        
    }
    
    @IBAction func protocolAction(_ sender: UIButton) {
//        let model = DDActionModel.init()
//        model.keyParameter = BaseUrlStr.web.rawValue + "member_agreement"
//        let web : HomeWebVC = HomeWebVC()
//        web.showModel = model
//        self.navigationController?.pushViewController(web , animated: true )
        self.pushVC(vcIdentifier: "HomeWebVC", userInfo: BaseUrlStr.web.rawValue + "member_agreement")
        
    }
    
    @IBOutlet var registerBtn: UIButton!
    
    
    @IBAction func regitsterAction(_ sender: UIButton) {
        let onebool = (self.passwordStr.count >= 6) && (self.passwordStr.count <= 12)
        
        if !onebool {
            GDAlertView.alert("密码格式不对", image: nil, time: 1, complateBlock: nil)
            return
        }
         let jpushID = DDStorgeManager.standard.string(forKey: "JPUSHID") ?? "123456"
        
        let paramete = ["mobile": self.phone, "verify": self.vergion, "parent_id": self.jobNumberStr, "password": self.passwordStr, "equipment_number": UUID, "equipment_type": "2", "push_id": jpushID]
        
        NetWork.manager.requestData(router: Router.post("member", .api, paramete)).subscribe(onNext: { (dict) in
            let model = BaseModel<DDAccount>.deserialize(from: dict)
            if model?.status == 200 {
                if let account = model?.data {
                    DDAccount.share.setPropertisOfShareBy(otherAccount: account)
                }
                NotificationCenter.default.post(name: NSNotification.Name.init("loginSuccess"), object: nil)
                
            }else {
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
            }
        }, onError: { (error) in
            GDAlertView.alert("注册失败", image: nil, time: 1, complateBlock: nil)
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
        
    }
    @IBOutlet var loginBtn: UIButton!
    
    @IBAction func loginAction(_ sender: UIButton) {
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func uploadPushid() {
        if let jpushID = DDStorgeManager.standard.string(forKey: "JPUSHID"), jpushID != "upload" {
            let id = DDAccount.share.id ?? ""
            let token = DDAccount.share.token ?? ""
            let parameter = ["token": token, "push_id": jpushID]
            NetWork.manager.requestData(router: Router.put("member/\(id)", .api,parameter )).subscribe(onNext: { (dict) in
                let model = BaseModel<GDModel>.deserialize(from: dict)
                if model?.status == 200 {
                    DDStorgeManager.standard.setValue("upload", forKey: "JPUSHID")
                }
            }, onError: { (error) in
                
            }, onCompleted: {
                
            }, onDisposed: {
                
            })
        }
        
    }
    deinit {
        mylog("销毁")
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
