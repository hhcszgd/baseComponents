//
//  DDAdBankCardVC.swift
//  Project
//
//  Created by WY on 2018/1/23.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDAdBankCardVC: DDNormalVC {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var cardNum: UITextField!
    
    @IBOutlet weak var bankName: UITextField!
    
    @IBOutlet weak var mobile: UITextField!
    
    @IBOutlet weak var authCode: UITextField!
    @IBOutlet weak var noticeBtn: UIButton!
    var doneHandle : (()->())?
    @IBOutlet weak var sendCodeBtn: UIButton!
    var timer : Timer?
    var timeInterval : Int = 60
    var apiModel : DDBandBrandApiModel?
    var selectedBankBrandModel : DDBandBrandModel?
    var cover  : DDCoverView?
    @IBOutlet weak var bandBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("#f0f0f0")
        self.title = "绑定银行卡"
        self.bankName.delegate = self
        self.name.delegate = self
        self.cardNum.delegate = self
        self.mobile.delegate = self
        self.authCode.delegate = self
        
        self.sendCodeBtn.setTitleColor(UIColor.orange, for: UIControlState.disabled)
        self.sendCodeBtn.setTitleColor(UIColor.orange, for: UIControlState.normal)
        self.mobile.keyboardType = .numberPad
        self.authCode.keyboardType = .numberPad
        self.cardNum.keyboardType = .numberPad
        // Do any additional setup after loading the view.
        self.requestAPI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        mylog(self.view.bounds)
    }
    func requestAPI()  {
        DDRequestManager.share.getBankBrandList()?.responseJSON(completionHandler: { (response) in
            if let apiModel = DDDecode(DDBandBrandApiModel.self , from: response){
                self.apiModel = apiModel
            }
            mylog(response.debugDescription)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func noticeClick(_ sender: UIButton) {
        GDAlertView.alert("姓名一经填写,不能修改", image: nil , time: 2, complateBlock: nil )
        self.view.endEditing(true)
    }
    
    @IBAction func sendAuthCodeClick(_ sender: UIButton) {
        self.view.endEditing(true)
        getAutoCode()
    }
    func addTimer() {
        self.sendCodeBtn.isEnabled = false
        self.timeInterval -= 1
        self.sendCodeBtn.setTitle("\(self.timeInterval)秒后重发", for: UIControlState.disabled)
        timer = Timer.init(timeInterval: 1, target: self , selector: #selector(daojishi), userInfo: nil , repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.defaultRunLoopMode)
    }
    func removeTimer() {
        timer?.invalidate()
        timer = nil
        self.sendCodeBtn.isEnabled = true
        self.timeInterval = 60
        self.sendCodeBtn.setTitle("发送验证码", for: UIControlState.normal)
    }
    @objc func daojishi() {
        self.timeInterval -= 1
        if self.timeInterval <= 0 {
            self.removeTimer()
        }else{
//            UIView.animate(withDuration: 0.1, animations: {
                self.sendCodeBtn.setTitle("\(self.timeInterval)秒后重发", for: UIControlState.disabled)
//            })
        }
    }
    func getAutoCode() {
        if let mobileStr = self.mobile.text , mobileStr.count > 0 {
            
            if !mobile.text!.mobileLawful() {
                GDAlertView.alert("请输入正确的手机号", image: nil, time: 2, complateBlock: nil)
                return
            }
            self.addTimer()
            DDRequestManager.share.getAuthCode(mobile: mobileStr)?.responseJSON(completionHandler: { (response ) in
                switch response.result{
                case .success:
                    if let dict  = response.value as? [String : Any]{
                        guard let code = dict["status"] as? Int else{return}
                        guard let msg = dict["message"] as? String else {return}
                        if code == 200 {
                            GDAlertView.alert(msg, image: nil , time: 2, complateBlock: nil )
                        }else {
                            GDAlertView.alert(msg, image: nil , time: 2, complateBlock: nil )
                            self.removeTimer()
                        }
                    } else {
                        self.removeTimer()
                        GDAlertView.alert("数据格式有误", image: nil , time: 2, complateBlock: nil )
                        return
                    }
                    
                case .failure:
                    self.removeTimer()
                    GDAlertView.alert("操作失败", image: nil , time: 2, complateBlock: nil )
                    break
                }
                mylog(response.debugDescription)
            })
        }else{
            GDAlertView.alert("请输入手机号码", image: nil , time: 2, complateBlock: nil )
        }
    }
    
    @IBAction func bandBtnClick(_ sender: UIButton) {
        if name.text == nil || name.text!.count == 0 {
            GDAlertView.alert("姓名为空", image: nil, time: 2, complateBlock: nil)
            return
        }else if cardNum.text == nil  || cardNum.text!.count == 0 {
            GDAlertView.alert("银行卡号为空", image: nil, time: 2, complateBlock: nil)
            return
        }else if bankName.text == nil || bankName.text!.count == 0  {
            GDAlertView.alert("银行名称为空", image: nil, time: 2, complateBlock: nil)
            return
        }else if mobile.text == nil || mobile.text!.count == 0  {
            GDAlertView.alert("手机号为空", image: nil, time: 2, complateBlock: nil)
            return
        }else if authCode.text == nil || authCode.text!.count == 0  {
            GDAlertView.alert("验证码为空", image: nil, time: 2, complateBlock: nil)
            return
        }
        
        if !name.text!.userNameLawful() {
            GDAlertView.alert("请输入2到6位汉字的用户名", image: nil, time: 2, complateBlock: nil)
            return
        }
        if !((cardNum.text ?? "").bankCardCheck())  {
            GDAlertView.alert("请输入正确的银行卡号", image: nil, time: 2, complateBlock: nil)
            return
        }
        if !authCode.text!.authoCodeLawful() {
            GDAlertView.alert("请输入六位数字的验证码", image: nil, time: 2, complateBlock: nil)
            return
        }
        if !mobile.text!.mobileLawful() {
            GDAlertView.alert("请输入正确的手机号", image: nil, time: 2, complateBlock: nil)
            return
        }
        DDRequestManager.share.bandBankCard(ownName : self.name.text ?? "", cardNum: cardNum.text!, mobile: mobile.text!, bankID:  "\(self.selectedBankBrandModel?.id ?? 0 )"   , verify: self.authCode.text ?? "")?.responseJSON(completionHandler: { (response) in
            
            mylog(response.debugDescription)
            switch response.result{
            case .success:
                if let dict  = response.value as? [String : Any]{
                    guard let code = dict["status"] as? Int else{return}
                    guard let msg = dict["message"] as? String else {return}
                    if code == 200 {
                        self.doneHandle?()
                        self.navigationController?.popViewController(animated: true)
                    }else {
                        GDAlertView.alert(msg, image: nil , time: 2, complateBlock: nil )
                    }
                } else {
                    GDAlertView.alert("数据格式有误", image: nil , time: 2, complateBlock: nil )
                    return
                }
                
            case .failure:
                GDAlertView.alert("操作失败", image: nil , time: 2, complateBlock: nil )
                break
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
extension DDAdBankCardVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        return true
//        if textField ==  name{
//            if (name.text?.count ?? 0) > 6 {
//                GDAlertView.alert("请输入2到6个汉字的姓名", image: nil, time: 2, complateBlock: nil)
//                return false
//            }else {return true }
//        }else if textField ==  cardNum{
//            //^([1-9]{1})(\d{14}|\d{18})$
//            let regex = "^([1-9]{1})(\\d{14}|\\d{18})$"
//            let regextext = NSPredicate.init(format: "SELF MATCHES %@", regex)
//            let result: Bool = regextext.evaluate(with: cardNum.text ?? "")
//            return true
//        }else if textField == mobile {
//            if (mobile.text?.count ?? 0) > 11{return false }else{return true }
//        }else if textField == authCode {
//            if (authCode.text?.count ?? 0) > 6{return false }else{return true }
//        }else{return true }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == bankName {
            chooseBankClick()
            self.view.endEditing(true)
            return false
        }
        return true
    }
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        mylog(textField.placeholder)
        if textField ==  name{
            if (name.text?.count ?? 0) > 6 || (name.text?.count ?? 0) < 2{
                GDAlertView.alert("请输入2到6个汉字的姓名", image: nil, time: 2, complateBlock: nil)
            }
        }else if textField ==  cardNum{
            let result: Bool = (cardNum.text ?? "").bankCardCheck()
            if !result  {
                GDAlertView.alert("银行卡号不正确", image: nil, time: 2, complateBlock: nil)
            }
        }else if textField == mobile {
            if let lawful =  mobile.text?.mobileLawful(),lawful == false {
                GDAlertView.alert("请输入正确手机号", image: nil, time: 2, complateBlock: nil)
            }
        }else if textField == authCode {
            if (authCode.text?.count ?? 0) != 6{GDAlertView.alert("请输入6位数字的验证码", image: nil, time: 2, complateBlock: nil) }
        }else{
            
        }
    }
}
extension DDAdBankCardVC {
  
    @objc func chooseBankClick()  {
        let pickerTitle = UILabel(frame:  CGRect(x:(self.view.bounds.width - 100) / 2 , y: 0, width: 100, height: 44))
        pickerTitle.text = "选择银行"
        pickerTitle.textAlignment = .center
        //        sender.isSelected = !sender.isSelected
//        let leftButton = UIButton(frame: CGRect(x: 20, y: 10, width: 88, height: 44))
//        let rightButton = UIButton(frame: CGRect(x:self.view.bounds.width - 20 - 88 , y: 10, width: 88, height: 44))
        
//        leftButton.addTarget(self , action: #selector(leftButtonClick(sender:)), for: UIControlEvents.touchUpInside)
//        rightButton.addTarget(self, action: #selector(rightButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        cover = DDCoverView.init(superView: self.view)
        cover?.deinitHandle = {
            self.conerClick()
        }
        
//        leftButton.setTitle("取消", for: UIControlState.normal)
//        rightButton.setTitle("确定", for: UIControlState.normal)
//        leftButton.setTitleColor(UIColor.DDSubTitleColor, for: UIControlState.normal)
//        rightButton.setTitleColor(UIColor.DDSubTitleColor, for: UIControlState.normal)
        let pickerContainerH :CGFloat = 250
        let pickerContainer = DDBankContainer(frame: CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: pickerContainerH))
        pickerContainer.delegate = self
        pickerContainer.models = self.apiModel?.data
        self.cover?.addSubview(pickerContainer)
        pickerContainer.backgroundColor = .white
//        pickerContainer.addSubview(rightButton)
        pickerContainer.addSubview(pickerTitle)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            pickerContainer.frame = CGRect(x: 0 , y: self.view.bounds.height - pickerContainerH, width: self.view.bounds.width, height: pickerContainerH)
        }, completion: { (bool ) in
        })
        
    }
    
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
}


///////////

protocol DDBankChooseDelegate : NSObjectProtocol {
    
    func didSelectRowAt(indexPath : IndexPath)
    func didSelectRowAt(indexPath: IndexPath, target: UIView?)
    
    
}
extension DDBankChooseDelegate {
    func didSelectRowAt(indexPath : IndexPath){}
    func didSelectRowAt(indexPath: IndexPath, target: UIView?){}
}

extension DDAdBankCardVC : DDBankChooseDelegate {
    
    func didSelectRowAt(indexPath : IndexPath){
        mylog(indexPath)
        if let selectedBankBrandModel = self.apiModel?.data?[indexPath.row]{
            self.selectedBankBrandModel = selectedBankBrandModel
            self.bankName.text = selectedBankBrandModel.name
        }
        self.cover?.remove()
        self.cover = nil
    }
    class DDBankContainer: UIView ,UITableViewDelegate , UITableViewDataSource{
        var models : [DDBandBrandModel]?{
            didSet{
                self.tableView.reloadData()
                layoutIfNeeded()
            }
        }
        var currentSelectLevel : Int = 0 {
            didSet{
                mylog(currentSelectLevel)
            }
        }
        
        weak var delegate : DDBankChooseDelegate?
        let titleLabel = UILabel()
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                        mylog(indexPath)
            self.delegate?.didSelectRowAt(indexPath: indexPath)
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return models?.count ?? 0
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 44
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var  returnCell : DDLevelCell!
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DDLevelCell") as? DDLevelCell{
                returnCell = cell
            }else{
                let cell = DDLevelCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDLevelCell")
                returnCell = cell
            }
            if let model = models?[indexPath.row]{
                returnCell.titleLabel.text = model.name
            }
            return returnCell
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.addSubview(titleLabel)
            self.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
//            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            self.titleLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 44)
            self.tableView.frame = CGRect(x: 0, y: titleLabel.frame.maxY, width: self.bounds.width, height: self.bounds.height - titleLabel.frame.maxY - 44 )
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    

}

class DDLevelCell: UITableViewCell {
    let titleLabel = UILabel()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.DDSubTitleColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = self.contentView.bounds
    }
}
