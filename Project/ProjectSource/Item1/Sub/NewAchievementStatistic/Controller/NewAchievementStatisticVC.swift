//
//  NewAchievementStatisticVC.swift
//  Project
//
//  Created by WY on 2018/1/22.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
class NewAchievementStatisticVC: DDNormalVC {
    var apiModel = NewAchienementApiModel()
    let container0 = UIView()
    let backImgView = UIImageView()
    let balanceTitle = UILabel()
    let balanceNum = UILabel()
    let container1 = UIView()
    let tiXian = UIButton()
    let mingXi = UIButton()
    let bankCard = UIButton()
    
    let container2 = UIView()
    let dynamicTitle = UILabel()
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    let noMsgNoticeLabel = UILabel()
    
    let container3 = UIView()
    let businessLabel = UILabel()
    let installLabel = UILabel()
    let chooseTime = DDTimeSelectButton()
    let timeLabel = UILabel()
    let shopsCount = UILabel()
    let screensCount = UILabel()
    var cover  : GDCoverView?
    var selectedDate : String = "全部"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "业绩统计"
        configSubview()
        // Do any additional setup after loading the view.
        
        newRequestApi(requestType:.initialize)
        NotificationCenter.default.addObserver(self , selector: #selector(getCashSuccess), name: NSNotification.Name.init("GetCashSuccess"), object: nil)
    }
    @objc func getCashSuccess() {
        selectedDate = "共计"
        self.chooseTime.label.text = "共计"
        newRequestApi(requestType:.initialize)
        self.adjustChooseTimeTitle()
    }
    func configSubview() {
        self.addSubviews()
        configSubviewsFrameBeforeRqeuest()
        _layoutSubviews()
    }
    func newRequestApi(requestType:DDLoadType, create_at: String? = nil )  {
        DDRequestManager.share.achievementStatistic(create_at: create_at , true )?.responseJSON(completionHandler: { (response ) in
            
            if requestType == .initialize{
                if let apiModel = DDDecode(NewAchienementApiModel.self , from: response){
                    self.apiModel = apiModel
                    self.setValueToUIAfterRequest()
                    mylog(apiModel)
                }
            }else{
                if let dict = response.value as? [String:Any]{
                    if let status = dict["status"] as? Int , status == 200{
                        if let dataDict  = dict["data"] as? [String:String] {
                             self.apiModel.data?.screen_number = dataDict["screen_number"]
                              self.apiModel.data?.shop_number = dataDict["shop_number"]
                            self.setValueToUIAfterRequest()
                        }
                    }else{
                        if let msg  = dict["message"] as? String {
                            GDAlertView.alert(msg , image: nil , time: 2, complateBlock: nil )
                        }
                    }
                }

            }
            
            
//            if let apiModel = DDDecode(NewAchienementApiModel.self , from: response){
//                if requestType == .initialize{
//                    self.apiModel = apiModel
//                }else{
////                    self.apiModel.data?.count_price = apiModel.data?.count_price
////                    self.apiModel.data?.lower_price = apiModel.data?.lower_price
////                    self.apiModel.data?.price = apiModel.data?.price
//                    self.apiModel.data?.screen_number = apiModel.data?.screen_number
//                    self.apiModel.data?.shop_number = apiModel.data?.shop_number
//                }
//                self.setValueToUIAfterRequest()
//                mylog(apiModel)
//            }
        })
    }
//    func requestApi(requestType:DDLoadType, create_at: String? = nil )  {
//        DDRequestManager.share.achievementStatistic(create_at: create_at , true )?.responseJSON(completionHandler: { (response ) in
//            if let apiModel = DDDecode(DDAchienementApiModel.self , from: response){
//                if requestType == .initialize{
//                    self.apiModel = apiModel
//                }else{
//                    self.apiModel.data.count_price = apiModel.data.count_price
//                    self.apiModel.data.lower_price = apiModel.data.lower_price
//                    self.apiModel.data.price = apiModel.data.price
//                    self.apiModel.data.screen_number = apiModel.data.screen_number
//                    self.apiModel.data.shop_number = apiModel.data.shop_number
//                }
//                self.setValueToUI()
//                mylog(apiModel)
//            }
//        })
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func toWebView() {
        self.pushVC(vcIdentifier: "GDBaseWebVC" , userInfo :  DomainType.wap.rawValue + "reward_rule")
//        let model = DDActionModel.init()
//        model.keyParameter = DomainType.wap.rawValue + "reward_rule"
//        let web : GDBaseWebVC = GDBaseWebVC()
//        web.showModel = model
//        self.navigationController?.pushViewController(web , animated: true )
    }

    func setValueToUIAfterRequest() {
        balanceNum.text = self.apiModel.data?.balance == nil ? "0" : "\(self.apiModel.data!.balance!)"
        let shops = "安装店铺 (家) : " + "\(self.apiModel.data?.shop_number ?? "0")"
        self.shopsCount.attributedText = shops.setColor(color: UIColor.orange, keyWord: self.apiModel.data?.shop_number ?? "0"
        )
        let screens = "安装屏幕 (台) : " + "\(self.apiModel.data?.screen_number ?? "0")"
        self.screensCount.attributedText = screens.setColor(color: UIColor.orange, keyWord: self.apiModel.data?.screen_number ?? "0")
        let container3ToBottom : CGFloat = 10
        let msgMaxH = self.view.bounds.height - container1.frame.maxY - container3.bounds.height - 44 - 44 - container3ToBottom

//        self.apiModel.data.message = [NewAchienementMsgModel]()//self.testMessageModel()
        if self.apiModel.data?.message != nil && self.apiModel.data!.message!.count > 0 {
            let rowH :CGFloat = 40
            var container2H = CGFloat(self.apiModel.data!.message!.count) * rowH
             container2H =  min(container2H, msgMaxH)
            tableView.isHidden = false
            let container2OldFrame = container2.frame
            container2.frame = CGRect(x: container2OldFrame.origin.x, y: container2OldFrame.origin.y, width: container2OldFrame.size.width, height: container2H)
            tableView.frame = container2.bounds
            container3.center = CGPoint(x:self.view.bounds.width/2 ,y : container2.frame.maxY + 44 + container3.bounds.height/2)
            tableView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                self.tableView.isScrollEnabled = self.tableView.contentSize.height > self.tableView.bounds.height ? true : false
                mylog("contentSizeHeight : \(self.tableView.contentSize.height) . boundsHeight:\(self.tableView.bounds.height)")
            })
        }else{
            tableView.isHidden = true
            let rowH :CGFloat = 40
            var container2H = 2 * rowH
            container2H =  min(container2H, msgMaxH)
            let container2OldFrame = container2.frame
            container2.frame = CGRect(x: container2OldFrame.origin.x, y: container2OldFrame.origin.y, width: container2OldFrame.size.width, height: container2H)
            noMsgNoticeLabel.frame = container2.bounds
            tableView.frame = container2.bounds
            container3.center = CGPoint(x:self.view.bounds.width/2 ,y : container2.frame.maxY + 44 + container3.bounds.height/2)
            
            
            
//            container2.isHidden = true
//            container3.center = CGPoint(x:self.view.bounds.width/2 ,y : container1.frame.maxY + 44 + container3.bounds.height/2)
        }
        
    }
    func testMessageModel() -> [NewAchienementMsgModel] {
        var models = [NewAchienementMsgModel]()
        for index  in 0...9 {
            let model = NewAchienementMsgModel.init()
            model.title = "title\(index)"
            model.create_at = "create_at\(index)"
            models.append(model)
        }
        return models
    }
    func _layoutSubviews()  {

        
//        chooseTime.sizeToFit()
//        let chooseTimeW = chooseTime.title.sizeSingleLine(font: chooseTime.label.font).width + 20
//        chooseTime.frame = CGRect(x:container2.bounds.width - chooseTimeW - container2Margin, y: container2Margin, width: chooseTimeW, height: 40)
//
//        timeLabel.frame = CGRect(x:chooseTime.frame.minX - 99 - container2Margin, y: container2Margin, width: 99, height: 40)
      
    }
    func addSubviews()  {
        self.view.addSubview(container0)
        container0.addSubview(backImgView)
       container0.addSubview(balanceTitle)
        container0.addSubview(balanceNum)
        
        self.view.addSubview(container1)
        container1.addSubview(tiXian)
        container1.addSubview(mingXi)
        container1.addSubview(bankCard)
        tiXian.addTarget(self , action: #selector(aboutMoneyButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        mingXi.addTarget(self , action: #selector(aboutMoneyButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        bankCard.addTarget(self , action: #selector(aboutMoneyButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(container2)
        container2.addSubview(dynamicTitle)
        container2.addSubview(installLabel)
        container2.addSubview(noMsgNoticeLabel)
        container2.addSubview(tableView)
        
        
        self.view.addSubview(container3)
        container3.addSubview(shopsCount)
        container3.addSubview(screensCount)
        container3.addSubview(businessLabel)
        container3.addSubview(installLabel)
        container3.addSubview(timeLabel)
        container3.addSubview(chooseTime)
        
//        container2.layer.borderColor = UIColor.DDLightGray.cgColor
//        container2.layer.borderWidth = 1
//
//        container3.layer.borderColor = UIColor.DDLightGray.cgColor
//        container3.layer.borderWidth = 1
        backImgView.image = UIImage(named:"businesscardbackground")

        timeLabel.textColor = UIColor.DDSubTitleColor
        chooseTime.addTarget(self , action: #selector(chooseTimeClick(sender:)), for: .touchUpInside)
        self.balanceTitle.text = "余额 (元) :"
        tiXian.setImage(UIImage(named:"bringoutsmallicons"), for: .normal)
        mingXi.setImage(UIImage(named:"smallicons"), for: .normal)
        bankCard.setImage(UIImage(named:"bankcardsmallicon"), for: .normal)
        tiXian.setTitleColor(UIColor.orange, for: .normal)
        mingXi.setTitleColor(UIColor.orange, for: .normal)
        bankCard.setTitleColor(UIColor.orange, for: .normal)
        
        tiXian.setTitle("  提现", for: .normal)
        mingXi.setTitle("  明细", for: .normal)
        bankCard.setTitle("  银行卡", for: .normal)
        dynamicTitle.text = "最新动态"
        businessLabel.text = "业务详情"
        installLabel.text = "安装业务"
        timeLabel.text = "时间区间"
        shopsCount.text = "安装店铺 (家) :"
        screensCount.text = "安装屏幕 (台) :"
        chooseTime.label.text = "总计"
        balanceNum.textAlignment = .center
        balanceTitle.textAlignment = .center
        balanceNum.textColor = .white
        balanceTitle.textColor = .white
        balanceNum.font = GDFont.boldSystemFont(ofSize: 33)
//        chooseTime.backgroundColor = UIColor.DDLightGray
        shopsCount.textColor = UIColor.DDTitleColor
        screensCount.textColor = UIColor.DDTitleColor
        installLabel.textColor = UIColor.DDTitleColor
        businessLabel.textColor = UIColor.DDTitleColor
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        noMsgNoticeLabel.text = "您还没有最新动态"
        noMsgNoticeLabel.textAlignment = .center
        noMsgNoticeLabel.textColor = UIColor.DDSubTitleColor
        tableView.showsVerticalScrollIndicator = false
    }
    func configSubviewsFrameBeforeRqeuest()  {
        let containerToLeft : CGFloat = 10
        container0.frame = CGRect(x: containerToLeft, y: DDNavigationBarHeight, width: self.view.bounds.width - containerToLeft * 2, height: 94 * SCALE)
        backImgView.frame = container0.bounds
        balanceTitle.frame = CGRect(x: 0, y: 10, width: container0.bounds.width, height: 20)
        balanceNum.frame = CGRect(x: 0, y: balanceTitle.frame.maxY, width: container0.bounds.width, height: container0.bounds.height - balanceTitle.frame.maxY)
        
        container1.frame = CGRect(x: containerToLeft, y: container0.frame.maxY + 10, width: self.view.bounds.width - containerToLeft * 2, height: 56)
        container1.layer.borderColor = UIColor.DDLightGray.cgColor
        container1.layer.borderWidth = 1
        let firstBtnX : CGFloat = 10
        let btnW = (container1.frame.width - firstBtnX * 4)/3
        let btnY : CGFloat  = 3
        let btnH = container1.frame.height -  btnY * 2
        tiXian.frame  = CGRect(x: firstBtnX, y: btnY, width: btnW, height: btnH)
        mingXi.frame  = CGRect(x: tiXian.frame.maxX + firstBtnX, y: btnY, width: btnW, height: btnH)
        bankCard.frame  = CGRect(x:  mingXi.frame.maxX + firstBtnX, y: btnY, width: btnW, height: btnH)
        
        container2.frame = CGRect(x: containerToLeft, y: container1.frame.maxY + 44, width: self.view.bounds.width - containerToLeft * 2, height: 100)
        tableView.frame = container2.bounds
        dynamicTitle.frame = CGRect(x: 0, y: -44, width: container2.bounds.width, height: 44)
        container2.layer.borderColor = UIColor.DDLightGray.cgColor
        container2.layer.borderWidth = 1
        
        container3.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width - containerToLeft * 2, height: 111)
        container3.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height - container3.bounds.height - 44)
        
        container3.layer.borderColor = UIColor.DDLightGray.cgColor
        container3.layer.borderWidth = 1
        businessLabel.frame = CGRect(x: 0, y: -44, width: container3.bounds.width, height: 44)
        chooseTime.sizeToFit()
        let chooseTimeW = chooseTime.title.sizeSingleLine(font: chooseTime.label.font).width + 20
        chooseTime.frame = CGRect(x:container3.bounds.width - chooseTimeW - 10, y: 0, width: chooseTimeW, height: 44)
        timeLabel.sizeToFit()
        timeLabel.frame = CGRect(x:chooseTime.frame.minX - timeLabel.bounds.width - 10, y: 0, width: timeLabel.bounds.width, height: 44)
        installLabel.frame = CGRect(x: 10, y: 0, width: container3.bounds.width/3, height: 44)
        shopsCount.frame = CGRect(x: 15, y: installLabel.frame.maxY + 6, width: container3.bounds.width - 15, height: (container3.bounds.height - installLabel.frame.maxY - 10) / 2)
        screensCount.frame = CGRect(x: shopsCount.frame.minX, y: shopsCount.frame.maxY , width: container3.bounds.width - 15, height: (container3.bounds.height - installLabel.frame.maxY - 10) / 2)
        
        
    }

}


class DDTimeSelectButton: UIControl {
    let arrow1 = UIImageView()
    let arrow2 = UIImageView()
    let label = UILabel()
    var title : String = "总计"{
        didSet{
            self.label.text = title
            layoutIfNeeded()
        }
    }
    override var isSelected: Bool{
        didSet{
            if isSelected {
                arrow1.image = UIImage(named:"pullupicon")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                    self.arrow2.isHidden = false
                })
            }else{
                arrow1.image = UIImage(named:"drop_downicon")
                arrow2.isHidden = true
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(arrow1)
        self.addSubview(arrow2)
        self.addSubview(label)
        self.backgroundColor = .white
        label.text = "总计"
        label.textColor = UIColor.DDSubTitleColor
        arrow1.bounds = CGRect(x: 0, y: 0, width: 16, height: 10)
        arrow2.bounds = CGRect(x: 0, y: 0, width: 16, height: 10)
        arrow1.image = UIImage(named:"drop_downicon")
        arrow2.image = UIImage(named:"arrowdownicon")
        arrow2.isHidden = true
        label.font = GDFont.systemFont(ofSize: 12)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let arrowW : CGFloat = 16
        let arrowH : CGFloat = 10
        let margin : CGFloat = 5
        label.sizeToFit()
        let labelCenterX : CGFloat = self.bounds.width/2 - arrowW/2 - margin
        label.center = CGPoint(x: labelCenterX, y: self.bounds.height/2)
        arrow1.frame = CGRect(x: label.frame.maxX + margin  , y: (self.bounds.height - arrowH) / 2, width: arrowW, height: arrowH)
        arrow2.frame = CGRect(x: self.bounds.width/2 - arrowW/2, y: (self.bounds.height - arrowH) + 3, width: arrowW, height: arrowH)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension NewAchievementStatisticVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushVC(vcIdentifier: "MingXiVC")
//        let mingXi = MingXiVC()
//        self.navigationController?.pushViewController(mingXi, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiModel.data?.message?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = self.apiModel.data?.message?[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "systemCell"){
            cell.textLabel?.text = msg?.title
            cell.detailTextLabel?.text = msg?.create_at
            return cell
        }else{
            let cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "systemCell")
            cell.imageView?.image = UIImage(named:"dynamicsmallicons")
            cell.textLabel?.text = msg?.title
            cell.detailTextLabel?.text = msg?.create_at
            cell.textLabel?.textColor = UIColor.DDSubTitleColor
            cell.selectionStyle = .none
            return cell
        }
    }
}
extension NewAchievementStatisticVC {
    @objc func aboutMoneyButtonClick(sender:UIButton){
        mylog(sender.title(for: UIControlState.normal))
        switch sender {
        case tiXian:
            if let payMentPswEnable  = self.apiModel.data?.payment_password , payMentPswEnable == "0"{
                GDAlertView.alert("请前往个人中心设置支付密码", image: nil , time: 2, complateBlock: nil)
                return
            }
            self.pushVC(vcIdentifier: "DDGetCashVC")
//            self.navigationController?.pushViewController(DDGetCashVC(), animated: true)
            break
        case mingXi:
            self.pushVC(vcIdentifier: "MingXiVC")
//            let mingXi = MingXiVC()
//            self.navigationController?.pushViewController(mingXi, animated: true)
            break
        case bankCard:
            self.pushVC(vcIdentifier: "DDBankCardManageVC")
//            self.navigationController?.pushViewController(DDBankCardManageVC(), animated: true )
            break
            
        default:
            break
        }
    }
}
extension NewAchievementStatisticVC : UIPickerViewDataSource , UIPickerViewDelegate{
    class DDPickerContainer: UIView {
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            mylog("touch")
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return  1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.apiModel.data?.date_list?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if let model  = self.apiModel.data?.date_list?[row] {
            return model.create_at
        }
        return ""
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if let model  = self.apiModel.data?.date_list?[row] {
            self.selectedDate = model.create_at
        }
    }
    @objc func chooseTimeClick(sender:DDTimeSelectButton)  {
        
        //        sender.isSelected = !sender.isSelected
        let leftButton = UIButton(frame: CGRect(x: 20, y: 10, width: 88, height: 44))
        let rightButton = UIButton(frame: CGRect(x:self.view.bounds.width - 20 - 88 , y: 10, width: 88, height: 44))
        leftButton.addTarget(self , action: #selector(leftButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        leftButton.setTitle("取消", for: UIControlState.normal)
        rightButton.setTitle("确定", for: UIControlState.normal)
        leftButton.setTitleColor(UIColor.DDSubTitleColor, for: UIControlState.normal)
        rightButton.setTitleColor(UIColor.DDSubTitleColor, for: UIControlState.normal)
        let pickerContainerH :CGFloat = 250
        let pickerContainer = DDPickerContainer(frame: CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: pickerContainerH))
        pickerContainer.backgroundColor = .white
        let pickerH :CGFloat = 200
        let picker = UIPickerView.init(frame: CGRect(x: 0, y: pickerContainerH - pickerH, width: self.view.bounds.width, height: pickerH))
        picker.backgroundColor = .white
        picker.dataSource = self
        picker.delegate = self
        cover = GDCoverView.init(superView: self.view)
        cover?.addTarget(self , action: #selector(conerClick) , for: UIControlEvents.touchUpInside)
        pickerContainer.addSubview(picker)
        pickerContainer.addSubview(leftButton)
        pickerContainer.addSubview(rightButton)
        self.cover?.addSubview(pickerContainer)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            pickerContainer.frame = CGRect(x: 0 , y: self.view.bounds.height - pickerContainerH, width: self.view.bounds.width, height: pickerH)
        }, completion: { (bool ) in
        })
        for ( index ,  model) in (self.apiModel.data?.date_list ?? []).enumerated(){
            if model.create_at == self.selectedDate{
                picker.selectRow(index, inComponent: 0, animated: true )
            }
        }
    }
    @objc func leftButtonClick(sender:UIButton)  {
        conerClick()
    }
    @objc func rightButtonClick(sender:UIButton)  {
        ///do something
        if self.selectedDate == "全部" || self.selectedDate == "总计"{
            self.newRequestApi(requestType:.refresh)
            self.chooseTime.title = "总计"
            
        }else{
            self.newRequestApi(requestType:.refresh,create_at : self.selectedDate)
            self.chooseTime.title = self.selectedDate
        }
        conerClick()
        self.adjustChooseTimeTitle()
//        let container2Margin : CGFloat = 10
//        let chooseTimeW = (chooseTime.label.text ?? "").sizeSingleLine(font: chooseTime.label.font).width + 20
//        chooseTime.frame = CGRect(x:container3.bounds.width - chooseTimeW - container2Margin, y: 0, width: chooseTimeW, height: 44)
//        timeLabel.sizeToFit()
//        timeLabel.frame = CGRect(x:chooseTime.frame.minX - timeLabel.bounds.width - container2Margin, y: 0, width: timeLabel.bounds.width, height: 44)
    }
    
    func adjustChooseTimeTitle(){
        let container2Margin : CGFloat = 10
        let chooseTimeW = (chooseTime.label.text ?? "").sizeSingleLine(font: chooseTime.label.font).width + 20
        chooseTime.frame = CGRect(x:container3.bounds.width - chooseTimeW - container2Margin, y: 0, width: chooseTimeW, height: 44)
        timeLabel.sizeToFit()
        timeLabel.frame = CGRect(x:chooseTime.frame.minX - timeLabel.bounds.width - container2Margin, y: 0, width: timeLabel.bounds.width, height: 44)
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

