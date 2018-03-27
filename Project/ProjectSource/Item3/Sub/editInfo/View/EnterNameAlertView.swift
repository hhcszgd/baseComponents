//
//  EnterNameAlertView.swift
//  Project
//
//  Created by 张凯强 on 2018/1/13.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
enum EnterAlertViewStyle: String {
    case textfield = "name"
    case sex = "selectSex"
    case education = "selectEducation"
    case phone = "phone"
    case id = "id"
    case address = "address"
    case school = "school"
    case relationName = "relationName"
    case relation = "relation"
    case relationContact = "relationContact"
}
class EnterAlertView: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    init(frame: CGRect, title: String?, alertStyle: EnterAlertViewStyle) {
        super.init(frame: frame)
//        self.addGestureRecognizer(self.tap)
        self.isUserInteractionEnabled = true
        let superWidth: CGFloat = SCREENWIDTH - 50
        let superHeight: CGFloat = 154
        var totoaH: CGFloat = 15
        let backX: CGFloat = 25
        let backY: CGFloat = (SCREENHEIGHT - superHeight) /  2.0 - 60
        self.backView.frame = CGRect.init(x: backX, y: backY, width: superWidth, height: superHeight)
        //title和message同时有
        if let titleStr = title, titleStr.count > 0{
            let titleSize = titleStr.sizeSingleLine(font: self.titleLabel.font)
            self.backView.addSubview(self.titleLabel)
            let titleX: CGFloat = (superWidth - titleSize.width) / 2.0
            let titleY: CGFloat = 15
            self.titleLabel.frame = CGRect.init(x: titleX, y: titleY, width: titleSize.width, height: titleSize.height)
            self.titleLabel.text = titleStr
            
            totoaH += titleSize.height
            
        }
        totoaH += 15
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        switch alertStyle {
        case .textfield, .school, .relation, .relationName, .relationContact:
            let fieldX: CGFloat = 15
            let fieldY: CGFloat = totoaH
            let width: CGFloat = superWidth - 30
            let height: CGFloat = 35
            self.textField.frame = CGRect.init(x: fieldX, y: fieldY, width: width, height: height)
            self.backView.addSubview(self.textField)
            self.textField.delegate = self
            totoaH += 35 + 15
        case .education, .sex:
            let X: CGFloat = 15
            let Y: CGFloat = totoaH
            let width: CGFloat = superWidth - 30
            let height: CGFloat = 35
            self.backView.addSubview(self.sView)
            self.sView.frame = CGRect.init(x: X, y: Y, width: width, height: height)
            self.selectView()
            totoaH += 35 + 15
        default:
            break
        }
    
        
        
        
        
        let btnWidth: CGFloat = (superWidth - 50 - 10) / 2.0
        let btnHeight: CGFloat = 40 * SCALE

        self.cancleBtn.frame = CGRect.init(x: 25, y: totoaH, width: btnWidth, height: btnHeight)
        self.sureBtn.frame = CGRect.init(x: self.cancleBtn.max_X + 10, y: totoaH, width: btnWidth, height: btnHeight)
        self.backView.addSubview(self.cancleBtn)
        self.backView.addSubview(self.sureBtn)
        self.alertStyle = alertStyle
        
        self.textField.rx.text.orEmpty.subscribe(onNext: { [unowned self](value) in
            
            self.textValue = value

        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.bag)
    
    }
    let bag = DisposeBag()
    func textFieldDidEndEditing(_ textField: UITextField) {
       
    }
    
    
    
    ///名字格式判断
    func nameLawful(name: String) -> Bool {
        let nnn = "^[\\u4e00-\\u9fa5]{2,6}$"
        let regextext = NSPredicate.init(format: "SELF MATCHES %@", nnn)
        let result: Bool = regextext.evaluate(with: name)
        if result {
            return true
        }else {
            return false
        }
    }
    
    func schoolName(school: String) -> Bool {
        let nnn = "^[\\u4e00-\\u9fa5]{2,15}$"
        let regextext = NSPredicate.init(format: "SELF MATCHES %@", nnn)
        let result: Bool = regextext.evaluate(with: school)
        if result {
            return true
        }else {
            return false
        }
    }
    
    
    
    
    var textValue: String = "" {
        didSet{
            
        }
    }
    var selectTitle: String? {
        didSet{
            self.selectLabel.text = selectTitle
        }
    }
    
    
    
    var sex: [String] = ["男", "女"]
    var educationList: [String] = ["小学", "初中", "高中", "本科", "研究生", "博士", "博士后"]
    @objc func cancleAction(btn: UIButton) {
        self.endAnimation()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        if !self.frame.contains(point) {
            self.endAnimation()
        }
    }
//    lazy var tap: UITapGestureRecognizer = {
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(endAnimation))
//        self.isUserInteractionEnabled = true
//
//        return tap
//    }()
    @objc func endAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            self.backView.alpha = 0.0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    @objc func sureAction(btn: UIButton) {
        self.textField.resignFirstResponder()
        let id: String = DDAccount.share.id ?? "0"
        switch self.alertStyle {
        case .textfield:
            
            self.configmentUserInfo(alertTitle: "姓名不能为空", key: "name", url: "member/\(id)/basic", enterValue: self.textValue)
        case .sex:
            self.configmentUserInfo(alertTitle: "性别不能为空", key: "sex", url: "member/\(id)/basic", enterValue: self.selectLabel.text)
        case .education:
            self.configmentUserInfo(alertTitle: "学历不能为空", key: "education", url: "member/\(id)", enterValue: self.selectLabel.text)
        case .relationContact:
            self.configmentUserInfo(alertTitle: "输入不能为空", key: "emergency_contact_mobile", url: "member/\(id)", enterValue: self.textValue)
        case .relationName:
            self.configmentUserInfo(alertTitle: "输入不能为空", key: "emergency_contact_name", url: "member/\(id)", enterValue: self.textValue)
        case .relation:
            self.configmentUserInfo(alertTitle: "输入不能为空", key: "emergency_contact_relation", url: "member/\(id)", enterValue: self.textValue)
        case .address:
            self.configmentUserInfo(alertTitle: "输入不能为空", key: "address", url: "member/\(id)/basic", enterValue: self.textValue)
        case .school:
            self.configmentUserInfo(alertTitle: "输入不能为空", key: "school", url: "member/\(id)", enterValue: self.textValue)
        default:
            break
        }
        
        
    }
    
    func configmentUserInfo(alertTitle: String, key: String, url: String, enterValue: String?) {
        
        switch self.alertStyle {
        case .textfield:
            if !self.nameLawful(name: enterValue ?? "") {
                GDAlertView.alert("输入2-4位汉字", image: nil, time: 1, complateBlock: nil)
                return
            }
        case .school:
            if !self.schoolName(school: enterValue ?? "") {
                GDAlertView.alert("输入2-15位汉字", image: nil, time: 1, complateBlock: nil)
                return
            }
        case .relationName:
            if !self.nameLawful(name: enterValue ?? "") {
                GDAlertView.alert("输入2-4位汉字", image: nil, time: 1, complateBlock: nil)
                return
            }
        case .relationContact:
            if !(enterValue ?? "").mobileLawful() {
                GDAlertView.alert("手机号码格式不对", image: nil, time: 1, complateBlock: nil)
                return 
            }
            
        default:
            break
        }
        
        
        if let keyValue = enterValue, keyValue.count > 0 {
            var keyValueStr: String = keyValue
            if key == "sex" {
                keyValueStr = (keyValue == "男") ? "1" : "2"
            }
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
            }).disposed(by: self.bag)
        }else {
            GDAlertView.alert("不能为空", image: nil, time: 1, complateBlock: nil)
        }
    }
    
    
    
    var selectFinished: ((String) -> ())?
    
    lazy var textField: UITextField = {
        let field = UITextField.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        field.backgroundColor = UIColor.colorWithHexStringSwift("e6e6e6")
        
        self.addSubview(field)
        return field
    }()
    var title: String?
    var message: String?
    var alertStyle: EnterAlertViewStyle = EnterAlertViewStyle.textfield
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.alertStyle == .sex {
            return self.sex.count
        }
        if self.alertStyle == .education {
            return self.educationList.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EditSelectCell = tableView.dequeueReusableCell(withIdentifier: "EditSelectCell", for: indexPath) as! EditSelectCell
        
        if self.alertStyle == .education {
            cell.title.text = self.educationList[indexPath.row]
        }else{
            cell.title.text = self.sex[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.alertStyle == .education {
            let education = self.educationList[indexPath.row]
            self.selectLabel.text = education
            tableView.removeFromSuperview()
            self.tableView = nil
        }else {
            let sex = self.sex[indexPath.row]
            self.selectLabel.text = sex
            tableView.removeFromSuperview()
            self.tableView = nil
        }
    }
   
    @objc func selectAction(btn: UIButton)  {
        if self.tableView != nil {
            return
        }
        self.createTable()
        let rect = self.sView.convert(self.sView.bounds, to: self)
        let tableX: CGFloat = rect.origin.x
        let tableY: CGFloat = rect.origin.y + rect.size.height
        let tableW: CGFloat = rect.size.width
        var tableH: CGFloat = 0
        if self.alertStyle == .education {
            tableH = CGFloat(self.educationList.count) * CGFloat(44)
        }else{
            tableH = CGFloat(self.sex.count) * CGFloat(44)
        }
        self.addSubview(self.tableView!)
        self.tableView?.frame = CGRect.init(x: tableX, y: tableY, width: tableW, height: tableH)
        
        
    }
    func selectView() {
        self.sView.backgroundColor = UIColor.white
        self.sView.layer.borderColor = UIColor.colorWithHexStringSwift("cccccc").cgColor
        self.sView.layer.borderWidth = 1
        self.sView.addSubview(self.selectLabel)
        self.selectLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        self.sView.addSubview(self.rightBtn)
        self.rightBtn.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(self.rightBtn.snp.height)
        }
    }
    
    
    
    lazy var rightBtn: UIButton = {
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: "drop-downboxicon"), for: .normal)
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(selectAction(btn:)), for: .touchUpInside)
        return btn
    }()
    var tableView: UITableView?
    
    func createTable() {
        let table = UITableView.init(frame: CGRect.init(x: 15, y: 10, width: 10, height: 10), style: .plain)
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = UIColor.white
        table.register(UINib.init(nibName: "EditSelectCell", bundle: Bundle.main), forCellReuseIdentifier: "EditSelectCell")
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.bounces = false
        
        self.tableView = table
    }
    
    
    lazy var sView: UIView = UIView.init()
    lazy var selectLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.colorWithHexStringSwift("333333")
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = NSTextAlignment.center
        label.sizeToFit()
        return label
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.colorWithHexStringSwift("333333")
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    lazy var messageLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.colorWithHexStringSwift("333333")
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = NSTextAlignment.center
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
        return view
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    deinit {
        mylog("销毁氨基酚静安寺李开复的徕卡饥渴了多久分裂卡死了会计分录卡说了看点附近；拉睡觉了；看风景爱上了；快解放路口你")
    }

}
