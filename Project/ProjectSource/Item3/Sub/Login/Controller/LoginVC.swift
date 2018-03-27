//
//  LoginVC.swift
//  Project
//
//  Created by 张凯强 on 2018/1/2.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//
let UUID: String = UIDevice.current.identifierForVendor?.uuidString ?? ""
import UIKit
import RxSwift
class LoginVC: GDNormalVC, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet var backScrollView: UIScrollView!
    
    @IBOutlet var logoTop: NSLayoutConstraint!
    @IBOutlet var registerBtn: UIButton!
    @IBOutlet var forgetPassword: UIButton!
    @IBOutlet var lognBtn: UIButton!
    @IBOutlet var loginName: UITextField!
    @IBOutlet var loginPassword: UITextField!
    @IBOutlet var logoImage: UIImageView!
    
    override func gdAddSubViews() {
        if DDDevice.type == .iPhone4 {
            self.backScrollView.isScrollEnabled = true
        }
        
        
        self.logoTop.constant = DDNavigationBarHeight - 10
        let lineView = UIView.init()
        lineView.backgroundColor = UIColor.colorWithHexStringSwift("ea9061")
        self.loginName.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.height.equalTo(1)
        }
        
        let subLineView = UIView.init()
        subLineView.backgroundColor = UIColor.colorWithHexStringSwift("ea9061")
        self.loginPassword.addSubview(subLineView)
        subLineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.height.equalTo(1)
        }
        
        self.view.layoutIfNeeded()
        
        
        self.loginName.leftViewMode = UITextFieldViewMode.always
        self.loginName.leftView = self.phoneCode
      
        
        
        self.loginPassword.leftViewMode = UITextFieldViewMode.always
        self.loginPassword.leftView = self.leftView
        self.loginPassword.rightViewMode = UITextFieldViewMode.always
        self.loginPassword.rightView = self.showButton
        self.loginPassword.isSecureTextEntry = true
        let placeColor = UIColor.colorWithHexStringSwift("ea9061")
        self.loginName.setValue(placeColor, forKeyPath: "_placeholderLabel.textColor")
        self.loginPassword.setValue(placeColor, forKeyPath: "_placeholderLabel.textColor")
        self.naviBar.naviagationBackImage.isHidden = true
        
        self.loginName.rx.text.orEmpty.subscribe(onNext: { (text) in
            self.userName = text
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
        self.loginPassword.rx.text.orEmpty.subscribe(onNext: { (text) in
            self.password = text
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
        
        self.loginName.delegate = self
        self.loginPassword.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.loginName.keyboardType = UIKeyboardType.numberPad
        
        
        
    }
    
    @IBAction func keyBoardHidden(_ sender: UITapGestureRecognizer) {
        self.loginName.resignFirstResponder()
        self.loginPassword.resignFirstResponder()
    }
    
    
    @objc func keyboardWillShow(notification: Notification) {
        
        if let keyBoardFrameValue = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? AnyObject, let keyBoardFrame = keyBoardFrameValue.cgRectValue {
            let keyboardHeight: CGFloat = keyBoardFrame.height
            let keyboardY: CGFloat = SCREENHEIGHT - keyboardHeight
            if self.registerBtn.max_Y > keyboardY {
                
                let move: CGFloat = self.registerBtn.max_Y - keyboardY
                self.backScrollView.setContentOffset(CGPoint.init(x: 0, y: move), animated: true)
                
                
            }
            
        }
    }
    @objc func keyboardWillHidden(notification: Notification) {
        
        self.backScrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    
    }
    let bag = DisposeBag()
    var userName: String = ""
    var password: String = ""
    lazy var leftView: UIView = {
        let view = UIView.init()
        view.frame = CGRect.init(x: 0, y: 0, width: 5, height: 40)
        self.loginPassword.leftView = view
        
        return view
    }()
    @objc func phoneCodeAction(btn: UIButton) {
        
    }
    lazy var phoneCode: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("+86", for: .normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ea9061"), for: .normal)
        let lineview = UIView.init()
        btn.addSubview(lineview)
        lineview.backgroundColor = UIColor.colorWithHexStringSwift("ea9061")
        lineview.frame = CGRect.init(x: 45, y: 10, width: 1, height: 30)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.frame = CGRect.init(x: 0, y: 0, width: 50, height: 40)
        btn.addTarget(self, action: #selector(phoneCodeAction(btn:)), for: .touchUpInside)
        return btn
    }()
    lazy var showButton: UIButton = {
        let showBtn = UIButton.init(type: UIButtonType.custom)
        showBtn.setImage(UIImage.init(named: "passwordisnotvisible"), for: .normal)
        showBtn.setImage(UIImage.init(named: "thepasswordisvisible"), for: .selected)
        showBtn.addTarget(self, action: #selector(showBtnAction(btn:)), for: .touchUpInside)
        showBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        return showBtn
        
    }()
    
    @objc func showBtnAction(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        self.loginPassword.isSecureTextEntry = !btn.isSelected
    }

    @IBAction func loginBtnAction(_ sender: UIButton) {
         let jpushID = DDStorgeManager.standard.string(forKey: "JPUSHID") ?? "123456"
        let paramete = ["mobile": self.userName, "password": self.password, "equipment_number": UUID, "equipment_type": "2", "push_id": jpushID]
        NetWork.manager.requestData(router: Router.post("member/login", .api, paramete)).subscribe(onNext: { (dict) in
            let model = BaseModel<DDAccount>.deserialize(from: dict)
            if model?.status == 200 {
                if let account = model?.data {
                    
                    DDAccount.share.setPropertisOfShareBy(otherAccount: account)
                    
                    NotificationCenter.default.post(name: NSNotification.Name.init("loginSuccess"), object: nil)
                }
            }else {
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
            }
        }, onError: { (error) in
            GDAlertView.alert("登录失败，请重新登录", image: nil, time: 1, complateBlock: nil)
            
        }, onCompleted: nil, onDisposed: nil)
    }
    @IBAction func forgetPasswordAction(_ sender: UIButton) {
        let vc = ForgetPasswordVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func registerAction(_ sender: UIButton) {
        let vc = RegisterVC()
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
