//
//  MyAreaAlertView.swift
//  Project
//
//  Created by 张凯强 on 2018/1/22.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
enum MyAreaAlertType: String {
    case alertOne = "one"
    case alertTwo = "two"
    case alertThree = "three"
}
class MyAreaAlertView: UIView {

    
    init(frame: CGRect, title: String?, type: MyAreaAlertType) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        self.alertType = type
        self.setUI(frame: frame, title: title, UIType: type)
        self.backView.isUserInteractionEnabled = true
        self.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(endAnimation))
//        self.addGestureRecognizer(tap)

    }
    var selectModel: AreaListModel?
    init(frame: CGRect, title: String?, type: MyAreaAlertType, model: AreaListModel?) {
        super.init(frame: frame)
        self.selectModel = model
        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        self.alertType = type
        self.setUI(frame: frame, title: title, UIType: type)
        self.backView.isUserInteractionEnabled = true
        self.isUserInteractionEnabled = true
        //        let tap = UITapGestureRecognizer.init(target: self, action: #selector(endAnimation))
        //        self.addGestureRecognizer(tap)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        if !self.backView.frame.contains(point) {
            self.endAnimation()
        }
    }
    var alertType: MyAreaAlertType = MyAreaAlertType.alertOne
    func setUI(frame: CGRect, title: String?, UIType: MyAreaAlertType) {
        let superWidth: CGFloat = frame.size.width - 50
        let superHeight: CGFloat = 154
        let backX: CGFloat = 25
        let backY: CGFloat = (frame.size.height - superHeight) /  2.0 - 60
        self.backView.frame = CGRect.init(x: backX, y: backY, width: superWidth, height: superHeight)
        //title和message同时有
        
        switch UIType {
        case .alertOne:
            self.setOneAlert(frame: self.backView.frame, title: title ?? "")
        case .alertTwo:
            self.setTwoAlert(frame: self.backView.frame, title: title ?? "")
        case .alertThree:
            self.setThreeAlert(frame: self.backView.frame, title: title ?? "")
        default:
            break
        }
        
        
    }
    
    
    
    
    
    
    
    
    var selectTitle: String? {
        didSet{
            self.selectLabel.text = selectTitle
        }
    }
    
    
    

    @objc func cancleAction(btn: UIButton) {
        self.actionType = 0
        self.endAnimation()
        
    }
    
    @objc func endAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            self.backView.alpha = 0.0
        }) { (finished) in
            if self.alertType == .alertTwo {
                self.finished.onNext(self.actionType)
                self.finished.onCompleted()
            }
            self.removeFromSuperview()
        }
    }
    ///取消操作是0，确定操作是1
    var actionType: Int = 0
    var selectAreaSuccess: PublishSubject<String> = PublishSubject<String>.init()
    @objc func sureAction(btn: UIButton) {
        self.actionType = 1
        let token = DDAccount.share.token ?? ""
        let id = DDAccount.share.id ?? ""
        let area = self.selectModel?.area ?? ""
        let paramete = ["token": token, "admin_area": area]
        if self.alertType == .alertOne {
            NetWork.manager.requestData(router: Router.put("member/\(id)/area", .api, paramete)).subscribe(onNext: { (dict) in
                let model = BaseModel<DDAccount>.deserialize(from: dict)
                if model?.status == 200 {
                    self.selectAreaSuccess.onNext("success")
                    self.selectAreaSuccess.onCompleted()
                    self.endAnimation()
                }else {
                    self.endAnimation()
                    GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
                }
            }, onError: { (error) in
                GDAlertView.alert("网络有问题，请稍后重试", image: nil, time: 1, complateBlock: nil)
            }, onCompleted: {
                
            }) {
                
            }
        }
        
        if self.alertType == .alertTwo {
            
            self.endAnimation()
        }
        if self.alertType == .alertThree {
            self.endAnimation()
        }
        
        
        
    }
    var finished: PublishSubject<Int> = PublishSubject<Int>.init()
    
    func configmentUserInfo(alertTitle: String, key: String, url: String, enterValue: String?) {
        if let keyValue = enterValue, keyValue.count > 0 {
            var keyValueStr: String = keyValue
            
            let token = DDAccount.share.token ?? ""
            NetWork.manager.requestData(router: Router.put(url, .api, ["token": token, key: keyValueStr])).subscribe(onNext: { [weak self](dict) in
                let model = BaseModel<DDAccount>.deserialize(from: dict)
                if model?.status == 200{
                    self?.selectFinished?(keyValueStr)
                    self?.endAnimation()
                }else {
                    self?.endAnimation()
                    GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
                }
                
                }, onError: { (error) in
                    GDAlertView.alert("设置失败", image: nil, time: 1, complateBlock: nil)
                    
                    self.endAnimation()
            }, onCompleted: {
                mylog("结束")
            }, onDisposed: {
                mylog("回收")
            })
        }else {
            GDAlertView.alert("不能为空", image: nil, time: 1, complateBlock: nil)
        }
    }
    
    
    
    var selectFinished: ((String) -> ())?
    
    
    var title: String?
    var message: String?
    

    
    lazy var selectLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.colorWithHexStringSwift("333333")
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = NSTextAlignment.center
        label.sizeToFit()
        label.sizeToFit()
        return label
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.colorWithHexStringSwift("333333")
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = NSTextAlignment.center
        label.sizeToFit()
        label.numberOfLines = 0
        return label
    }()
    lazy var messageLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.colorWithHexStringSwift("333333")
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = NSTextAlignment.center
        label.sizeToFit()
        return label
    }()
    lazy var cancleBtn : UIButton = {
        let btn = UIButton.init()
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("cccccc"), for: .normal)
        btn.addTarget(self, action: #selector(cancleAction(btn:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.layer.borderColor = UIColor.colorWithHexStringSwift("cccccc").cgColor
        btn.layer.borderWidth = 1
        
        return btn
    }()
    lazy var sureBtn : UIButton = {
        let btn = UIButton.init()
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(sureAction(btn:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.backgroundColor = UIColor.colorWithHexStringSwift("ed8202")
        return btn
    }()
    lazy var backView: UIView = {
        let view = UIView.init()
        self.addSubview(view)
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        return view
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    deinit {
        mylog("销毁")
    }

}
extension MyAreaAlertView {
    func setOneAlert(frame: CGRect, title: String) {
        self.backView.addSubview(self.titleLabel)
        self.backView.addSubview(self.messageLabel)
        self.backView.addSubview(self.selectLabel)
        self.titleLabel.text = title
        let attribute = NSMutableAttributedString.init(string: "选择后不可更改，确定选择?")
        attribute.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.colorWithHexStringSwift("ea9061")], range: NSRange.init(location: 0, length: 8))
        self.messageLabel.attributedText = attribute
        self.selectLabel.text = title
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        self.selectLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        self.messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.selectLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        self.backView.addSubview(self.cancleBtn)
        self.backView.addSubview(self.sureBtn)
        let btnWidth: CGFloat = (frame.size.width - 50 - 10) / 2.0
        self.cancleBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.messageLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(25)
            make.height.equalTo(40 * SCALE)
            make.width.equalTo(btnWidth)
        }
        self.sureBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.messageLabel.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(40 * SCALE)
            make.width.equalTo(btnWidth)
        }
        self.cancleBtn.setTitle("我再想想", for: .normal)
        self.sureBtn.setTitle("确定", for: .normal)
    }
    
}
extension MyAreaAlertView {
    func setTwoAlert(frame: CGRect, title: String) {
        self.backView.addSubview(self.titleLabel)
        self.titleLabel.text = title
        
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        
        self.backView.addSubview(self.cancleBtn)
        self.backView.addSubview(self.sureBtn)
        let btnWidth: CGFloat = (frame.size.width - 50 - 10) / 2.0
        self.cancleBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(25)
            make.height.equalTo(40 * SCALE)
            make.width.equalTo(btnWidth)
        }
        self.sureBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(25)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(40 * SCALE)
            make.width.equalTo(btnWidth)
        }
        self.cancleBtn.setTitle("不补充", for: .normal)
        self.sureBtn.setTitle("去补充", for: .normal)
    }
}
extension MyAreaAlertView {
    func setThreeAlert(frame: CGRect, title: String) {
        self.backView.addSubview(self.titleLabel)
        self.titleLabel.text = title
        
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        
        self.backView.addSubview(self.sureBtn)
        
        self.sureBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(25)
            make.right.equalToSuperview().offset(-25)
            make.left.equalToSuperview().offset(25)
            make.height.equalTo(40 * SCALE)
        }
        self.sureBtn.setTitle("确定", for: .normal)
    }
}
