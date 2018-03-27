//
//  TrueOrderVC.swift
//  Project
//
//  Created by 张凯强 on 2018/3/15.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class TrueOrderVC: DDNormalVC {
    @IBOutlet var bottom: NSLayoutConstraint!
    @IBOutlet var top: NSLayoutConstraint!
    
    @IBOutlet var backScroll: UIScrollView!
    @IBOutlet var timeValue: UILabel!
    @IBOutlet var areaValue: UILabel!
    @IBAction func selelctedAreaAction(_ sender: UIButton) {
        self.pushVC(vcIdentifier: "DDSelectedAreaVC", userInfo: "0")
    }
    @IBOutlet var advertiseValue: UILabel!
    @IBOutlet var timeLengthValue: UILabel!
    @IBOutlet var rateValue: UILabel!
    @IBOutlet var partnerValue: UITextField!
    @IBAction func checkPhoneAction(_ sender: UIButton) {
        if !mobileLawful(mobileNum: self.phone) {
            GDAlertView.alert("手机号格式错误", image: nil, time: 1, complateBlock: nil)
        }
        let token = DDAccount.share.token ?? ""
        let paramete: [String: Any] = ["token": token, "member_type": "2" ]
        let id = self.phone
        NetWork.manager.requestData(router: Router.get("member/\(id)/parent", .api, paramete)).subscribe(onNext: { [weak self](dict) in
            let model = BaseModel<DDAccount>.deserialize(from: dict)
            if model?.status == 200 {
                if let data = model?.data {
                    sender.setTitle(data.name, for: .normal)
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
        self.partnerValue.resignFirstResponder()
        
    }
    var areaid: String = ""
    var selectArea: AreaSelectView?
    @IBAction func selectUsAreaAction(_ sender: UIButton) {
        self.partnerValue.resignFirstResponder()
        let frame = CGRect.init(x: 0, y: SCREENHEIGHT - 400 - TabBarHeight, width: SCREENWIDTH, height: 400)
        let view = AreaSelectView.init(frame: frame, title: "jj", type: 100, url: "area", subFrame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        self.view.addSubview(view)
        
        view.finished.subscribe(onNext: { [weak self](address, id) in
            sender.setTitle(address, for: .normal)
            self?.areaid = id
            view.removeFromSuperview()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        
        
    }
    
    
    
    

    var dict: [String: String] = [String: String]()
    @IBOutlet var sucaiValue: UILabel!
    @IBOutlet var dayCountValue: UILabel!
    @IBOutlet var priceValue: UILabel!
    @IBOutlet var totalPriceValue: UILabel!
    @IBAction func payTypePromptAction(_ sender: UIButton) {
        self.payTypePromptView()
    }
    @IBOutlet var payTypeBtn: UIButton!
    @IBAction func payTypeBtnAction(_ sender: UIButton) {
        self.selectPayType()
    }
    @IBOutlet var truePayLabel: UILabel!
    @IBOutlet var backView: UIView!
    
    @IBAction func sureAction(_ sender: UIButton) {
        if !mobileLawful(mobileNum: self.phone) {
            GDAlertView.alert("手机格式不对", image: nil, time: 1, complateBlock: nil)
            return
        }
        if !((self.payTypeBtn.currentTitle == "全额支付") || (self.payTypeBtn.currentTitle == "定金支付")) {
            GDAlertView.alert("请选择支付方式", image: nil, time: 1, complateBlock: nil)
            return
        }
        if self.areaid.count <= 0 {
            GDAlertView.alert("请选择所在地区", image: nil, time: 1, complateBlock: nil)
            return
        }
        var payType: String = "1"
        if (self.payTypeBtn.currentTitle == "全额支付") {
            payType = "1"
        }else {
            payType = "2"
        }
        
        let truePrice = String.init(format: "%0.2f", self.truePay)
        self.dict["truePrice"] = truePrice
        let salesman_mobile = self.phone
        let advert_id = self.dict["advert_id"]!
        let rate = self.dict["rate"]!
        let advert_time = self.dict["advert_time"]!
        let payment_type = payType
        let total_day = self.dict["total_day"]!
        let area = self.dict["area"]!
        let start_at = self.dict["start_at"]!
        let end_at = self.dict["end_at"]!
        let company_area_id = self.areaid
        let token = DDAccount.share.token ?? ""
        let paramete = ["salesman_mobile": salesman_mobile, "advert_id": advert_id, "rate": rate, "advert_time": advert_time, "payment_type": payment_type, "total_day": total_day, "area": area, "start_at": start_at, "end_at": end_at, "company_area_id": company_area_id, "token": token]
        let id = DDAccount.share.id ?? ""
        NetWork.manager.requestData(router: Router.post("member/\(id)/order", .api, paramete)).subscribe(onNext: { (dict) in
            if let model = BaseModel<OrderCodeModel>.deserialize(from: dict) {
                if model.status == 200 {
                    if let orderCode = model.data?.order_code, let orderID = model.data?.order_id {
                        self.pushVC(vcIdentifier: "PayVC", userInfo: ["orderID": orderID, "orderCode": orderCode])
                    }else {
                        GDAlertView.alert("数据格式不对", image: nil, time: 1, complateBlock: nil)
                    }
                    
                }else {
                    GDAlertView.alert(model.message, image: nil, time: 1, complateBlock: nil)
                }
            }else {
                
            }
            
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
    }
    @IBOutlet var size: UILabel!
    @IBOutlet var format: UILabel!
    @IBOutlet var sepc: UILabel!
    var ration: Float = 0
    var totalPrice: Float = 0
    var truePay: Float = 0
    ///底层的阴影
    var cover: DDCoverView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.top.constant = DDNavigationBarHeight
        self.bottom.constant = TabBarHeight
        self.view.layoutIfNeeded()
        self.title = "查询结果"
        if let dict = self.userInfo as? [String: String] {
            self.timeValue.text = dict["time"]
            self.areaValue.text = dict["areaName"]
            self.advertiseValue.text = dict["advertise"]
            self.timeLengthValue.text = dict["advert_time"]
            self.rateValue.text = dict["rate"]! + "次/天"
            self.dayCountValue.text = dict["total_day"]! + "天"
            self.priceValue.text = dict["dayPrice"]! + "元/天"
            self.totalPriceValue.text = dict["totalPrice"]! + "元"
            self.truePayLabel.text = dict["totalPrice"]! + "元"
            
            self.size.text = dict["sepc"]
            self.format.text = dict["format"]
            self.sepc.text = dict["size"]
            if let ration = dict["ratio"], let ra = Float(ration) {
                self.ration = ra / 100.0
            }
            if let price = dict["totalPrice"] as? String, let priceFloat = Float(price) {
                self.totalPrice = priceFloat
                self.truePay = priceFloat
            }
            self.dict = dict
            
            
        }
        let rxText = self.partnerValue.rx.text.orEmpty
        rxText.subscribe(onNext: { (value) in
            self.phone = value
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo {
            //获取键盘的高度
            guard let boardHeightValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
            let boardRect = boardHeightValue.cgRectValue
            ///获取键盘的弹出动画时间
            UIView.animate(withDuration: TimeInterval.init(0.25), animations: {
                self.backView.frame = CGRect.init(x: 0, y: -boardRect.height, width: self.backView.width, height: self.backView.height)
            })
            
        }
        
        
    }
    @objc func keyboardWillHide(notification: Notification) {
        if let userInfo = notification.userInfo {
            
            ///获取键盘的弹出动画时间
            UIView.animate(withDuration: TimeInterval.init(0.25), animations: {
                self.backView.frame = CGRect.init(x: 0, y: 0, width: self.backView.width, height: self.backView.height)
            })
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "查询结果"
    }
    
    
    
    var phone: String = ""
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
extension TrueOrderVC {
    
    ///弹出框消失
    @objc func conerClick()  {
        //        self.levelSelectButton.isSelected = false
        if let corverView = self.cover{
            for (_ ,view) in corverView.subviews.enumerated(){
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    view.frame = CGRect(x: 0 , y: self.view.bounds.height, width: self.view.bounds.width , height: 250)
                    corverView.alpha = 0
                }, completion: { (bool ) in
                    corverView.remove()
                    self.cover = nil
                })
            }
        }
    }
    ///选择支付类型
    func selectPayType() {
        cover = DDCoverView.init(superView: self.view)
        cover?.deinitHandle = {
            self.conerClick()
        }
        let pickerContainer = PayTypeView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 80))
        self.cover?.addSubview(pickerContainer)

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            pickerContainer.frame = CGRect(x: 0 , y: SCREENHEIGHT - 80 - TabBarHeight, width: self.view.bounds.width, height: 80)
        }, completion: { (bool ) in
        })
        
        pickerContainer.type.subscribe(onNext: { (value) in
            self.payTypeBtn.setTitle((value == "0") ? "定金支付":"全额支付", for: .normal)
            if value == "0" {
                self.truePay = self.totalPrice * self.ration
                self.truePayLabel.text = String.init(format: "%0.2f", self.truePay) + "元"
                
            }else {
                self.truePay = self.totalPrice
                self.truePayLabel.text = String.init(format: "%0.2f", self.totalPrice) + "元"
            }
            self.conerClick()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    ///定金支付和全额支付的解释
    func payTypePromptView() {
        cover = DDCoverView.init(superView: self.view)
        cover?.deinitHandle = {
            self.conerClick()
        }
        let x: CGFloat = (SCREENWIDTH - 275) / 2.0
        let y: CGFloat = (SCREENHEIGHT - 195) / 2.0
        let pickerContainer = PayTypePromptView.init(frame: CGRect.init(x: x, y: 0, width: 275, height: 195))
        self.cover?.addSubview(pickerContainer)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            pickerContainer.frame = CGRect(x: x , y: y, width: 275, height: 195)
        }, completion: { (bool ) in
        })
        pickerContainer.action.subscribe(onNext: { [weak self](_) in
            self?.conerClick()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        
        
        
    }
    
    
    
}

class PayTypeView: UIView
{
    
    let type: PublishSubject<String> = PublishSubject<String>.init()
    ///定金支付
    @IBOutlet var btn1: UIButton!
    ///全额支付
    @IBOutlet var btn2: UIButton!
    ///定金支付action
    @IBAction func btn1Action(_ sender: UIButton) {
        self.type.onNext("0")
        self.type.onCompleted()
    }
    ///全额支付action
    @IBAction func btn2Action(_ sender: UIButton) {
        self.type.onNext("1")
        self.type.onCompleted()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let containerView = Bundle.main.loadNibNamed("PayTypeView", owner: self, options: nil)?.first as! UIView
        self.contentView = containerView
        self.addSubview(containerView)
    }
    var contentView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



