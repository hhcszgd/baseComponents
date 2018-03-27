//
//  EditInfoVC.swift
//  Project
//
//  Created by 张凯强 on 2018/1/12.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class EditInfoVC: GDNormalVC {

    @IBOutlet var section2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.section3.text = "紧急联系人"
        self.section2.text = "其他信息"
        // Do any additional setup after loading the view.
    }
    func request() {
        let id = DDAccount.share.id ?? "0"
        NetWork.manager.requestData(router: Router.get("member/\(id)", .api, ["token": DDAccount.share.token ?? ""])).subscribe(onNext: { (dict) in
            let model = BaseModel<DDAccount>.deserialize(from: dict)
            let redColor = UIColor.colorWithHexStringSwift("ea6e61")
            let blackColor = UIColor.colorWithHexStringSwift("333333")
            if let data = model?.data {
                DDAccount.share.setPropertisOfShareBy(otherAccount: data)

                if let phone = data.mobile, phone.mobileLawful() {
                    let phoneStr = NSString.init(string: phone)
                    let prefix = phoneStr.substring(to: 3)
                    let sub = phoneStr.substring(from: 7)
                    let id = prefix + "****" + sub
                    self.phoneValue.text = id
                    self.phoneValue.textColor = blackColor
                }else {
                    self.phoneValue.text = "待补充"
                    self.phoneValue.textColor = redColor
                }
                

                if let address = data.address, address.count > 0 {
                    self.addressValue.textColor = blackColor
                    self.addressValue.text = address
                }else {
                    self.addressValue.textColor = redColor
                    self.addressValue.text = "待补充"
                }
                
                self.schoolValue.text = data.school
                self.educationValue.text = data.education
                self.otherValue.text = data.relationName
                self.relationValue.text = data.relation
                self.contactValue.text = data.relationMobile

                
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.request()
    }
    override func gdAddSubViews() {
        self.scrollTop.constant = DDNavigationBarHeight
        self.scrollBottom.constant = TabBarHeight
        self.view.layoutIfNeeded()
        self.naviBar.title = "编辑资料"
        
        
    }
    
    func createEnterAlertView(title: String?, type: EnterAlertViewStyle, selectTitle: String?, result: @escaping (String) -> ()) {
        let view = EnterAlertView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT), title: title, alertStyle: type)
        view.selectTitle = selectTitle
        view.selectFinished = result
        self.view.addSubview(view)
        let oldTransform = view.backView.transform
        view.backView.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
        UIView.animate(withDuration: 0.4, animations: {
            view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            view.backView.transform = oldTransform
        }) { (finished) in
            
        }
    }
    
    
    @IBOutlet var scrollTop: NSLayoutConstraint!
    @IBOutlet var scrollBottom: NSLayoutConstraint!
 

    
    @IBAction func phoneTapAction(_ sender: UITapGestureRecognizer) {
        let phoneVC = ChangePhoneVC()
        phoneVC.send.subscribe(onNext: { [weak self](phone) in
            self?.phoneValue.text = phone
            self?.phoneValue.textColor = UIColor.colorWithHexStringSwift("333333")
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.navigationController?.pushViewController(phoneVC, animated: true)
    }
    @IBOutlet var phoneValue: UILabel!
   
    @IBAction func addressDetailAction(_ sender: UITapGestureRecognizer) {
        let address = ContactAddress()
        self.navigationController?.pushViewController(address, animated: true)
//        if DDAccount.share.canEditBasic {
//
//        }else {
//            GDAlertView.alert("不可以修改基础数据", image: nil, time: 1, complateBlock: nil)
//        }
    }
    
    @IBOutlet var addressValue: UILabel!
    @IBAction func schoolTapAction(_ sender: UITapGestureRecognizer) {
        self.createEnterAlertView(title: "请输入您的学校", type: .school, selectTitle: self.schoolValue.text) { (title) in
            self.schoolValue.text = title
            
        }
    }
    @IBOutlet var schoolValue: UILabel!
    @IBAction func educationTapAction(_ sender: UITapGestureRecognizer) {
        self.createEnterAlertView(title: "请输入您的学历", type: .education, selectTitle: self.educationValue.text) { (title) in
            self.educationValue.text = title
        }
    }
    @IBOutlet var educationValue: UILabel!
    @IBAction func otherNameTapAction(_ sender: UITapGestureRecognizer) {
        self.createEnterAlertView(title: "请输入紧急联系人姓名", type: .relationName, selectTitle: self.otherValue.text) { (title) in
            self.otherValue.text = title
        }
    }
    
    @IBOutlet var otherValue: UILabel!
    @IBAction func relationTapAction(_ sender: UITapGestureRecognizer) {
        self.createEnterAlertView(title: "请输入你们的关系", type: .relation, selectTitle: self.relationValue.text) { (title) in
            self.relationValue.text = title
        }
    }
    @IBOutlet var section3: UILabel!
    @IBOutlet var relationValue: UILabel!
    @IBAction func contactTapAction(_ sender: UITapGestureRecognizer) {
        self.createEnterAlertView(title: "请输入紧急联系方式", type: .relationContact, selectTitle: self.contactValue.text) { (title) in
            self.contactValue.text = title
        }
    }
    @IBOutlet var contactValue: UILabel!
    
  
    
    
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
