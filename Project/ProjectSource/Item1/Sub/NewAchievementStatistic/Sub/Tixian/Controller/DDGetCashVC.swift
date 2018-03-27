//
//  DDGetCashVC.swift
//  Project
//
//  Created by WY on 2018/1/25.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
enum GetCashType : Int {
    case getingCash
    case noBankCard
    case getCashSuccess
    case getCashFailure
}
class DDGetCashVC: DDNormalVC {
    var apiModel : DDGetCsahApiModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "提现"
        self.view.addSubview(backgroundTextfield)
        self.backgroundTextfield.delegate = self
        self.layoutNoBankCard()
        self.layoutGetCash()
        self.layoutGetCashResult()
        self.switchStatus(status: .getingCash)
        requestApi()
        // Do any additional setup after loading the view.
    }
    func switchStatus(status : GetCashType)  {
        switch status {
        case .noBankCard:
            getCashResultContainer.isHidden = true
            getCashContainer.isHidden = true
            noBankCardContainer.isHidden = false
        case .getingCash:
            getCashResultContainer.isHidden = true
            getCashContainer.isHidden = false
            noBankCardContainer.isHidden = true
        case .getCashSuccess:
            getCashResultContainer.isHidden = false
            getCashContainer.isHidden = true
            noBankCardContainer.isHidden = true
            getCashResultReason.isHidden = true
            if getCashResultReason.isHidden {
                getCashResultConfirm.frame = CGRect(x: 60, y: getCashResultBank.frame.maxY + 30, width: getCashResultContainer.width - 60 * 2, height: 44)
            }else{
                getCashResultConfirm.frame = CGRect(x: 60, y: getCashResultReason.frame.maxY + 30, width: getCashResultContainer.width - 60 * 2, height: 44)
            }
            self.setValueToUIAfterGetCash()
            
        case .getCashFailure:
            getCashResultContainer.isHidden = false
            getCashContainer.isHidden = true
            noBankCardContainer.isHidden = true
            getCashResultReason.isHidden = false
            if getCashResultReason.isHidden {
                getCashResultConfirm.frame = CGRect(x: 60, y: getCashResultBank.frame.maxY + 30, width: getCashResultContainer.width - 60 * 2, height: 44)
            }else{
                getCashResultConfirm.frame = CGRect(x: 60, y: getCashResultReason.frame.maxY + 30, width: getCashResultContainer.width - 60 * 2, height: 44)
            }
        }
    }
    func setValueToUIAfterGetCash() {
        getCashResultMoney.text = "提现金额:¥ \(self.moneyInput.text ?? "")"
        var mutableAttributeStr = NSMutableAttributedString.init()
        mutableAttributeStr.append(NSAttributedString.init(string: "提现账户 : "))
        if let bankLogo = self.bankLogo.image{
            let logoAtt = bankLogo.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -4, width: getCashResultBank.font.lineHeight, height: getCashResultBank.font.lineHeight))
            mutableAttributeStr.append(logoAtt)
        }
        if let bankNum  = self.apiModel?.data?.number , bankNum.count >= 4{
            let num = bankNum.suffix(from:bankNum.index(bankNum.endIndex, offsetBy: -4) )
            let numAttribute = NSAttributedString.init(string: " \(self.apiModel?.data?.bank_name ?? "") 尾号 (\(num))")
            mutableAttributeStr.append(numAttribute)
//            getCashResultBank.text = "提现账户 : \(self.apiModel?.data?.bank_name ?? "") 尾号 (\(num))"
            
        }else{
            let numAttribute = NSAttributedString.init(string: "\(self.apiModel?.data?.bank_name ?? "") 尾号 (\(self.apiModel?.data?.number ?? ""))")
            mutableAttributeStr.append(numAttribute)
//            getCashResultBank.text = "提现账户 : \(self.apiModel?.data?.bank_name ?? "") 尾号 (\(self.apiModel?.data?.number ?? ""))"
        }
        getCashResultBank.attributedText = mutableAttributeStr
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func requestApi() {
        DDRequestManager.share.getCashPage(true)?.responseJSON(completionHandler: { (response) in
            if let apiModel = DDDecode(DDGetCsahApiModel.self , from: response){
                self.apiModel = apiModel
                self.setValueToUI()
            }
            
        })
    }
    
    
    
    
    let noBankCardContainer = UIView()
    let noBankNoticeLabel = UILabel()
    let bandBankButton = UIButton()
    
    let getCashContainer = UIView()
    let bankLogo = UIImageView()
    let bankName = UILabel()
    let bankNumber = UILabel()
    let arrowBtn = UIButton()
    let line = UIView()
    let getCashNum = UILabel()
    
    let line2 = UIView()
    let rmbLogo = UILabel()
    let moneyInput = UITextField()
    
    let getCashEnableNum = UILabel()
    let getCashButton = UIButton()
    
    
    let getCashResultContainer = UIView()
    let getCashResultLabel = UILabel()
    let getCashResultImage = UIImageView()
    let getCashResultMoney = UILabel()
    let getCashResultBank = UILabel()
    let getCashResultReason = UILabel()
    let getCashResultConfirm = UIButton()
    
    let backgroundTextfield = UITextField()
    let accessoryView = DDInputAccessoryView(frame: CGRect(x: 0, y: 0, width: 330, height: 88))
    
}

extension DDGetCashVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        mylog(textField.text)
        mylog(range )
        mylog(string )
        if textField == backgroundTextfield {
            if range.length == 0{//写
                if let text = textField.text {
                    self.accessoryView.inputString = text + string
                }
            }else if range.length == 1{//删
                if let text = textField.text {
                    var text = text
                    text.removeLast()
                    self.accessoryView.inputString = text
                }
            }
        }else if textField == moneyInput{
            
            if range.length == 0{//写
                if let inputValue  = textField.text{
                    if inputValue.contains(".") && string == "."{return false }
                    if let doutRange =  inputValue.range(of: "."){
                        let sub = inputValue.suffix(from:inputValue.index(doutRange.lowerBound, offsetBy: 0) )
                        let str = String(sub)
                        if str.count > 2{
                            return false
                        }
                    }
                    let result  = inputValue + string
                    self.judgeEnouph(Str: result )
                }
            }else if range.length == 1{//删
                if let text = textField.text {
                    var text = text
                    text.removeLast()
                    let result = text
                    self.judgeEnouph(Str: result )
                }
            }
        }
        
        
        return true
    }
    func judgeEnouph(Str : String ){
        
        if let banlance = self.apiModel?.data?.balance{
            let nsBanlance = NSString.init(string: banlance)
            let banlanceFloat = nsBanlance.floatValue
            
            let nsStr  = NSString.init(string: Str)
            let strFloat = nsStr.floatValue
            if Str.hasSuffix(".") || Str.hasPrefix(".") || strFloat == 0{
                self.getCashButton.isEnabled = false
                self.getCashButton.backgroundColor = UIColor.lightGray
                return
            }else{
                
                //                self.getCashButton.isEnabled = true
                //                self.getCashButton.backgroundColor = UIColor.orange
            }
            
            if banlanceFloat < strFloat {//有小数点不好判断
                self.getCashEnableNum.text = "输入金额超过提现金额"
                self.getCashButton.isEnabled = false
                self.getCashEnableNum.textColor  = .red
                self.getCashButton.backgroundColor = UIColor.lightGray
            }else{
                self.getCashEnableNum.text = "可提现额度 : \(banlance)"
                self.getCashEnableNum.textColor  = UIColor.DDSubTitleColor
                self.getCashButton.isEnabled = true
                self.getCashButton.backgroundColor = UIColor.orange
            }
        }
        
    }
    
    @objc func getCashButtonClick(sender:UIButton) {
        if self.backgroundTextfield.canBecomeFirstResponder{
            self.backgroundTextfield.becomeFirstResponder()
        }
    }
}
import SDWebImage
extension DDGetCashVC {
    
    func setValueToUI(){
        if let id = self.apiModel?.data?.id {
            self.switchStatus(status: GetCashType.getingCash)
            
            if let url  = URL(string:self.apiModel?.data?.bank_logo ?? "") {
                bankLogo.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
            }else{
                bankLogo.image = DDPlaceholderImage
            }
            
            if let banlance = self.apiModel?.data?.balance{
                self.getCashEnableNum.text = "可提现额度 : \(banlance)"
            }
            
            if let bankName  = self.apiModel?.data?.bank_name{
                self.bankName.text = bankName
            }
            if let bankNum  = self.apiModel?.data?.number , bankNum.count >= 4{
                let num = bankNum.suffix(from:bankNum.index(bankNum.endIndex, offsetBy: -4) )
                self.bankNumber.text = "尾号 (\(num))"
            }else{
                self.bankNumber.text = "尾号 (\(self.apiModel?.data?.number ?? ""))"
            }
            
            
        }else{
            self.switchStatus(status: GetCashType.noBankCard)
        }
    }
    
    func layoutGetCashResult() {
        self.view.addSubview(getCashResultContainer)
        getCashResultContainer.addSubview(getCashResultLabel)
        getCashResultContainer.addSubview(getCashResultImage)
        getCashResultContainer.addSubview(getCashResultMoney)
        getCashResultContainer.addSubview(getCashResultBank)
        getCashResultContainer.addSubview(getCashResultReason)
        getCashResultContainer.addSubview(getCashResultConfirm)
        let containerMargin : CGFloat = 10
        getCashResultContainer.frame = CGRect(x: containerMargin, y:DDNavigationBarHeight + containerMargin, width: self.view.bounds.width - containerMargin  * 2, height: 400)
        getCashResultContainer.layer.borderWidth = 2
        getCashResultContainer.layer.borderColor = UIColor.DDLightGray.cgColor
        
        getCashResultLabel.text = "提现成功"
        getCashResultLabel.textAlignment = .center
        getCashResultLabel.font = GDFont.systemFont(ofSize: 20)
        getCashResultLabel.textColor = .orange
        getCashResultLabel.frame = CGRect(x:  0, y: 20, width: getCashResultContainer.bounds.width, height: 44)
        getCashResultImage.frame = CGRect(x: (getCashResultContainer.bounds.width - 80) / 2, y: getCashResultLabel.frame.maxY, width: 80, height: 80)
        getCashResultImage.image = UIImage(named:"checkmarkicon")
        getCashResultMoney.text = "提现金额:¥ 150"
        getCashResultMoney.frame = CGRect(x: 20, y: getCashResultImage.frame.maxY + 40, width: getCashResultContainer.width - 40, height: 40)
        
        getCashResultBank.text = "提现账户 : 建设银行 尾号 (0234)"
        getCashResultBank.frame = CGRect(x: 20, y: getCashResultMoney.frame.maxY , width: getCashResultContainer.width - 40, height: 40)
        getCashResultBank.adjustsFontSizeToFitWidth = true 
        getCashResultReason.text = "提现失败 失败原因 网络问题"
        getCashResultReason.frame = CGRect(x: 40, y: getCashResultBank.frame.maxY , width: getCashResultContainer.width - 40, height: 40)
        
        getCashResultConfirm.backgroundColor = .orange
        getCashResultConfirm.setTitle("确 定", for: UIControlState.normal)
        getCashResultConfirm.addTarget(self , action: #selector(confirmAfterGetCashSuccess), for: UIControlEvents.touchUpInside)
        if getCashResultReason.isHidden {
            getCashResultConfirm.frame = CGRect(x: 60, y: getCashResultBank.frame.maxY + 30, width: getCashResultContainer.width - 60 * 2, height: 44)
        }else{
            getCashResultConfirm.frame = CGRect(x: 60, y: getCashResultReason.frame.maxY + 30, width: getCashResultContainer.width - 60 * 2, height: 44)
        }
        
    }
    @objc func confirmAfterGetCashSuccess() {
        self.navigationController?.popViewController(animated: true)
    }
    func layoutGetCash() {
        self.view.addSubview(getCashContainer)
        getCashContainer.addSubview(bankLogo)
        getCashContainer.addSubview(bankName)
        getCashContainer.addSubview(bankNumber)
        getCashContainer.addSubview(arrowBtn)
        getCashContainer.addSubview(line)
        
        getCashContainer.addSubview(getCashNum)
        getCashContainer.addSubview(line2)
        getCashContainer.addSubview(rmbLogo)
        getCashContainer.addSubview(moneyInput)
        moneyInput.delegate = self
        getCashContainer.addSubview(getCashEnableNum)
        getCashContainer.addSubview(getCashButton)
        
        let containerMargin : CGFloat = 10
        getCashContainer.frame = CGRect(x: containerMargin, y:DDNavigationBarHeight + containerMargin, width: self.view.bounds.width - containerMargin  * 2, height: 400)
        getCashContainer.layer.borderWidth = 2
        getCashContainer.layer.borderColor = UIColor.DDLightGray.cgColor
        
        bankLogo.frame = CGRect(x: containerMargin, y: containerMargin, width: 64, height: 64)
        bankLogo.layer.cornerRadius = bankLogo.bounds.width/2
        bankLogo.layer.masksToBounds = true
        bankName.frame = CGRect(x: bankLogo.frame.maxX + 10, y: bankLogo.frame.minY, width: getCashContainer.bounds.width
            - (bankLogo.frame.maxX + 10), height: 30)
        bankName.textColor = UIColor.DDSubTitleColor
        bankNumber.frame = CGRect(x: bankName.frame.minX, y: bankLogo.frame.midY, width: bankName.frame.width, height: bankName.frame.height)
        bankNumber.textColor = UIColor.DDSubTitleColor
        arrowBtn.frame = CGRect(x: getCashContainer.bounds.width - 44 - containerMargin, y: bankLogo.frame.midY - 44/2, width: 44, height: 44)
        
        line.frame = CGRect(x: 0, y: bankLogo.frame.maxY + containerMargin, width: getCashContainer.bounds.width, height: 2)
        line.backgroundColor = UIColor.DDLightGray
        getCashNum.frame = CGRect(x: bankLogo.frame.minX, y: line.frame.maxY + 10, width: getCashContainer.bounds.width - bankLogo.frame.minX, height: 44)
        getCashNum.text = "提现金额"
        getCashNum.textColor = UIColor.DDTitleColor
        line2.frame = CGRect(x: 30, y: getCashNum.frame.maxY + 64, width: getCashContainer.bounds.width - 30 * 2, height: 2)
        line2.backgroundColor = UIColor.DDLightGray
        rmbLogo.frame = CGRect(x: line2.frame.minX, y: line2.frame.minY - 44, width: 44, height: 44)
        moneyInput.frame = CGRect(x: rmbLogo.frame.maxX, y: rmbLogo.frame.minY, width: line.bounds.width - rmbLogo.frame.maxX, height: 44)
        getCashEnableNum.frame = CGRect(x: line2.frame.minX, y: line2.frame.maxY, width: line2.frame.width, height: 44)
        getCashEnableNum.textColor = UIColor.DDSubTitleColor
        getCashButton.frame = CGRect(x: 60, y: getCashContainer.bounds.height - 44 - 10, width: getCashContainer.width - 60 * 2, height: 44)
        bankName.text = "建设银行"
        bankNumber.text = "尾号 (2348)"
        
        arrowBtn.setImage(UIImage(named:"enterthearrow"), for: UIControlState.normal)
        arrowBtn.addTarget(self , action: #selector(chooseBankCard), for: UIControlEvents.touchUpInside)
        rmbLogo.text = "¥"
        rmbLogo.font = GDFont.systemFont(ofSize: 30)
        moneyInput.placeholder = "请输入提现金额"
        moneyInput.font = GDFont.systemFont(ofSize: 26)
        getCashEnableNum.text = "可提现额度 : "
        getCashButton.setTitle("确认提现", for: UIControlState.normal)
        getCashButton.backgroundColor = .lightGray
        getCashButton.isEnabled = false
//        bankLogo.image = UIImage(named:"installbusinessicons")
        moneyInput.keyboardType = .decimalPad
        
        backgroundTextfield.keyboardType = .numberPad
        backgroundTextfield.clearsOnBeginEditing = true
        backgroundTextfield.inputAccessoryView = accessoryView
        accessoryView.passwordComplateHandle = {password in
            mylog(password)
            self.view.endEditing(true )
            // perform request api
            DDRequestManager.share.getCashAction(bank_id: self.apiModel?.data?.id ?? "", price: self.moneyInput.text ?? "", payment_password: password)?.responseJSON(completionHandler: { (response ) in
                mylog(response.debugDescription)
                
                switch response.result {
                case  .success:
                    if let dict = response.value as? [String : Any]{
                        if let code = dict["status"] as? Int , code == 200{
                            self.switchStatus(status: GetCashType.getCashSuccess)
                            NotificationCenter.default.post(name: NSNotification.Name.init("GetCashSuccess"), object: nil )
                        }else{
                            if let msg = dict["message"] as? String{
                                GDAlertView.alert(msg, image: nil , time: 2, complateBlock: nil )
                            }
                        }
                    }
                case .failure:
                    GDAlertView.alert("请求失败", image: nil , time: 2, complateBlock: nil )
                }
            })
        }
        accessoryView.cancleHandle = {
            self.view.endEditing(true )
        }
        accessoryView.forgetHandle = {
            self.view.endEditing(true )
            self.pushVC(vcIdentifier: "SetWithDrawalVC")
//            self.navigationController?.pushViewController(SetWithDrawalVC(), animated: true )
        }
        getCashButton.addTarget(self , action: #selector(getCashButtonClick(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func chooseBankCard() {
        mylog("choose bank card")
        let chooseBankVC = DDChooseBankListVC()
        chooseBankVC.doneHandle = { model in
            self.apiModel?.data?.id = model.id
            self.apiModel?.data?.bank_name = model.bank_name
            self.apiModel?.data?.bank_logo = model.bank_logo
            self.apiModel?.data?.number = model.number
            self.setValueToUI()
//            mylog(model.bank_name)
        }
        self.navigationController?.pushViewController(chooseBankVC, animated: true )
    }
    class DDInputAccessoryView: UIView {
        var inputString = ""{
            didSet{
                mylog(inputString)
                for ( index ,label)  in bottomContaienr.subviews.enumerated() {
                    if let label = label as? UILabel{
                        if  index < inputString.count{
                            label.text = "*"
                        }else{label.text = nil }
                    }
                }
                if inputString.count == bottomContaienr.subviews.count{
                    let str = inputString
                    self.passwordComplateHandle?(str)
                    inputString = ""
                    self.clear()
                }
            }
        }
        let titleLabel = UILabel()
        let bottomContaienr = UIView()
        let cancleBtn = UIButton()
        let forgetBtn = UIButton()
        var passwordComplateHandle : ((String)->())?
        var cancleHandle : (()->())?
        var forgetHandle : (()->())?
        override init(frame: CGRect) {
            super.init(frame: frame )
            self.addSubview(titleLabel)
            self.addSubview(bottomContaienr)
            self.addSubview(cancleBtn)
            self.addSubview(forgetBtn)
            self.backgroundColor = UIColor.colorWithHexStringSwift("#f7f7f7")
            titleLabel.text = "请输入提现密码"
            titleLabel.textAlignment = .center
            titleLabel.textColor = UIColor.DDTitleColor
            forgetBtn.setTitle("忘记密码", for: UIControlState.normal)
            cancleBtn.setTitle("取消", for: UIControlState.normal)
            forgetBtn.addTarget(self , action: #selector(forgetAction), for: UIControlEvents.touchUpInside)
            
            cancleBtn.addTarget(self , action: #selector(cancleAction), for: UIControlEvents.touchUpInside)
            forgetBtn.setTitleColor(UIColor.DDSubTitleColor, for: UIControlState.normal)
            cancleBtn.setTitleColor(UIColor.DDSubTitleColor, for: UIControlState.normal)
            bottomContaienr.backgroundColor = UIColor.colorWithHexStringSwift("#f0f0f0")
            for _  in 0..<6 {
                let label = UILabel()
                bottomContaienr.addSubview(label)
                label.backgroundColor = .white
                label.textAlignment = .center
            }
        }
        
        
        @objc func forgetAction(){
            self.clear()
            self.forgetHandle?()
        }
        
        @objc func cancleAction(){
            self.clear()
            self.cancleHandle?()
        }
        func clear(){
            for ( index ,label)  in bottomContaienr.subviews.enumerated() {
                if let label = label as? UILabel{
                    label.text = nil
                }
            }
        }
        override func layoutSubviews() {
            super.layoutSubviews()

            let size = self.bounds.size
            cancleBtn.frame = CGRect(x: 0, y: 0, width: 44, height: size.height/2)
            forgetBtn.frame = CGRect(x: self.bounds.width - 88, y: 0, width: 88, height: size.height/2)
            titleLabel.frame = CGRect(x: forgetBtn.frame.width, y: 0, width: self.bounds.width - forgetBtn.frame.width * 2, height: size.height/2)
            bottomContaienr.frame = CGRect(x: 0, y: size.height/2, width: size.width, height: size.height/2)
            
            let toTopBorder : CGFloat = 3
            let gerdWH =  (size.height/2 - toTopBorder * 2 )
            let gerdMargin : CGFloat = 2
            let toLeftBorder : CGFloat = ( size.width - gerdWH  * 6 - gerdMargin * 5) / 2
            for (index , label) in bottomContaienr.subviews.enumerated() {
                label.frame = CGRect(x: toLeftBorder + CGFloat(index) * (gerdWH + gerdMargin), y: toTopBorder, width: gerdWH, height: gerdWH)
            }
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    func layoutNoBankCard() {
        self.view.addSubview(noBankCardContainer)
        noBankCardContainer.addSubview(noBankNoticeLabel)
        noBankCardContainer.addSubview(bandBankButton)
        mylog(self.view.bounds)
        self.noBankCardContainer.frame = self.view.bounds
        self.noBankNoticeLabel.frame = CGRect(x: 0, y: noBankCardContainer.bounds.height/2 - 20 - 44, width: noBankCardContainer.bounds.width, height: 44)
        
        self.bandBankButton.frame = CGRect(x: 60, y: noBankCardContainer.bounds.height/2 + 20, width: noBankCardContainer.bounds.width - 120, height: 44)
        noBankNoticeLabel.textColor = UIColor.DDSubTitleColor
        noBankNoticeLabel.text = "您还没有绑定银行卡,请先绑定银行卡"
        noBankNoticeLabel.textAlignment = .center
        
        bandBankButton.setTitle("绑定银行卡", for: UIControlState.normal)
        bandBankButton.backgroundColor = UIColor.orange
        bandBankButton.addTarget(self , action: #selector(gotoBandBankCard), for: UIControlEvents.touchUpInside)
    }
    @objc func gotoBandBankCard()  {
        let vc = DDAdBankCardVC()
        vc.doneHandle = {
            self.requestApi()
        }
        self.navigationController?.pushViewController(vc, animated: true )
    }

}
