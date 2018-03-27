//
//  AchievementStatisticVC.swift
//  Project
//
//  Created by WY on 2018/1/13.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//
/*
import UIKit
import SDWebImage
class AchievementStatisticVC: DDNormalVC {
    let container1 = UIView()
    let backImgView = UIImageView()
    let icon = UIImageView()
    let name = UILabel()
    let workerID = UILabel()
    let joinTime = UILabel()
    
    let container2 = UIView()
    let achievementTitle = UILabel()
    let timeLabel = UILabel()
    let chooseTime = DDTimeSelectButton()
    let totalMoney = UILabel()
    let toWeb = UIButton()
    let personalReward = UILabel()
    let partnerReward = UILabel()
    
    let container3 = UIView()
    let shopsCount = UILabel()
    let screensCount = UILabel()
    
    var apiModel = DDAchienementApiModel()
    
    var cover  : GDCoverView?
    var selectedDate : String = "全部"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "业绩统计"
        configSubview()
        // Do any additional setup after loading the view.
        
        requestApi(requestType:.initialize)
    }
    func configSubview() {
        self.addSubviews()
        _layoutSubviews()
    }
    func requestApi(requestType:DDLoadType, create_at: String? = nil )  {
        DDRequestManager.share.achievementStatistic(create_at: create_at , true )?.responseJSON(completionHandler: { (response ) in
            if let apiModel = DDDecode(DDAchienementApiModel.self , from: response){
                if requestType == .initialize{
                    self.apiModel = apiModel
                }else{
                    self.apiModel.data.count_price = apiModel.data.count_price
                    self.apiModel.data.lower_price = apiModel.data.lower_price
                    self.apiModel.data.price = apiModel.data.price
                    self.apiModel.data.screen_number = apiModel.data.screen_number
                    self.apiModel.data.shop_number = apiModel.data.shop_number
                }
                self.setValueToUI()
                mylog(apiModel)
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func toWebView() {
        let model = DDActionModel.init()
        model.keyParameter = DomainType.release.rawValue + "v1/html/reward_rule"
        let web : GDBaseWebVC = GDBaseWebVC()
        web.showModel = model
        self.navigationController?.pushViewController(web , animated: true )
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func setValueToUI() {
//        icon
        if let url  = URL(string:self.apiModel.data.avatar ?? "") {
            icon.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
        }else{
            icon.image = DDPlaceholderImage
        }
        self.name.text = self.apiModel.data.name
        self.workerID.text = "ID : " + (self.apiModel.data.number ?? "")
        self.joinTime.text = "加入平台 : " + "\(self.apiModel.data.create_at ?? 0 )" + "天"
        self.achievementTitle.text = "我的业绩"
        self.timeLabel.text = "时间区间"
        let totalMoney = self.apiModel.data.price == nil ? "0" : "\(self.apiModel.data.price!)"
        let totalStr = "获得奖励 (元) : " + totalMoney
        self.totalMoney.attributedText = totalStr.setColor(color: UIColor.orange, keyWord: totalMoney)
        self.toWeb.setTitle("查看奖励规则", for: UIControlState.normal)
        toWeb.setTitleColor(UIColor.orange, for: UIControlState.normal)
        
        let personalMoney = self.apiModel.data.count_price == nil ? "0" : "\(self.apiModel.data.count_price!)"
        let personal = "个人奖励 (元) : " + personalMoney
        self.personalReward.attributedText = personal.setColor(color: UIColor.orange, keyWord: personalMoney)
        
        let partnerMoney = self.apiModel.data.lower_price == nil ? "0" : "\(self.apiModel.data.lower_price!)"
        let partner = "伙伴奖励 (元) : " + partnerMoney
        self.partnerReward.attributedText = partner.setColor(color: UIColor.orange, keyWord: partnerMoney)
        
        let shops = "安装店铺 (家) : " + "\(self.apiModel.data.shop_number ?? "0")"
        self.shopsCount.attributedText = shops.setColor(color: UIColor.orange, keyWord: self.apiModel.data.shop_number ?? "0"
        )
        let screens = "安装店铺 (家) : " + "\(self.apiModel.data.screen_number ?? "0")"
        self.screensCount.attributedText = screens.setColor(color: UIColor.orange, keyWord: self.apiModel.data.screen_number ?? "0")
    }
    func _layoutSubviews()  {
        let toBorder : CGFloat = 10
        let containerW : CGFloat = self.view.bounds.width - toBorder  * 2
        self.container1.frame = CGRect(x: toBorder, y: DDNavigationBarHeight + 44, width: containerW    , height: 150 * SCALE)
        self.container2.frame = CGRect(x: toBorder, y: container1.frame.maxY + 20, width: containerW    , height: 180 * SCALE)
        self.container3.frame = CGRect(x: toBorder, y: container2.frame.maxY - 1, width: containerW    , height: 80  * SCALE)
        
        let container1Margin : CGFloat = 15
        self.backImgView.frame = self.container1.bounds
        self.icon.frame = CGRect(x: container1Margin, y: container1Margin, width: container1.bounds.height - container1Margin * 2, height: container1.bounds.height - container1Margin * 2)
        icon.layer.cornerRadius = self.icon.bounds.width/2
        icon.layer.masksToBounds = true 
        name.frame = CGRect(x: icon.frame.maxX + container1Margin, y: icon.frame.minY, width: container1.bounds.width - icon.frame.maxX - container1Margin*2    , height: icon.frame.height/3)
        workerID.frame = CGRect(x: icon.frame.maxX + container1Margin, y: icon.frame.midY - icon.frame.height/6, width: container1.bounds.width - icon.frame.maxX - container1Margin*2    , height: icon.frame.height/3)
        joinTime.frame = CGRect(x: icon.frame.maxX + container1Margin, y: icon.frame.maxY - icon.frame.height/3, width: container1.bounds.width - icon.frame.maxX - container1Margin*2    , height: icon.frame.height/3)
        
        let container2Margin : CGFloat = 15
        chooseTime.sizeToFit()
        let chooseTimeW = chooseTime.title.sizeSingleLine(font: chooseTime.label.font).width + 20
        chooseTime.frame = CGRect(x:container2.bounds.width - chooseTimeW - container2Margin, y: container2Margin, width: chooseTimeW, height: 40)
        
        
        
        
        timeLabel.frame = CGRect(x:chooseTime.frame.minX - 99 - container2Margin, y: container2Margin, width: 99, height: 40)
        totalMoney.frame = CGRect(x:0, y: container2.bounds.height / 2 - 30, width: container2.bounds.width, height: 30)
        toWeb.frame = CGRect(x:0, y: totalMoney.frame.maxY, width: container2.bounds.width, height: 30)
        achievementTitle.frame = CGRect(x: container2Margin, y: container2Margin, width: timeLabel.frame.minX - container2Margin * 2, height: 40 )
        personalReward.frame = CGRect(x: 0, y:container2.bounds.height -  container2Margin - 40, width: container2.bounds.width/2, height: 40 )
        partnerReward.frame = CGRect(x: container2.bounds.width/2, y:container2.bounds.height -  container2Margin - 40, width: container2.bounds.width/2, height: 40 )
        
        
        
        let container3Margin : CGFloat = 15
        shopsCount.frame = CGRect(x: container3Margin, y: 0, width: container1.bounds.width - container3Margin * 2, height: container3.bounds.height/2)
        screensCount.frame = CGRect(x: container3Margin, y: container3.bounds.height/2, width: container1.bounds.width - container3Margin * 2, height: container3.bounds.height/2)
    }
    func addSubviews()  {
        self.view.addSubview(container1)
        container1.addSubview(backImgView)
        container1.addSubview(icon)
        container1.addSubview(name)
        container1.addSubview(workerID)
        container1.addSubview(joinTime)
        
        self.view.addSubview(container2)
        container2.addSubview(achievementTitle)
        container2.addSubview(timeLabel)
        container2.addSubview(chooseTime)
        container2.addSubview(totalMoney)
        container2.addSubview(toWeb)
        container2.addSubview(personalReward)
        container2.addSubview(partnerReward)
        
        self.view.addSubview(container3)
        container3.addSubview(shopsCount)
        container3.addSubview(screensCount)
        
        container2.layer.borderColor = UIColor.DDLightGray.cgColor
        container2.layer.borderWidth = 1
        
        container3.layer.borderColor = UIColor.DDLightGray.cgColor
        container3.layer.borderWidth = 1
        backImgView.image = UIImage(named:"businesscardbackground")
        icon.image = UIImage(named:"logo")
        totalMoney.textAlignment = .center
        personalReward.textAlignment = .center
        partnerReward.textAlignment = .center
        toWeb.contentHorizontalAlignment = .center
        toWeb.titleLabel?.font = GDFont.systemFont(ofSize: 13)
        timeLabel.textAlignment = .right
        
        name.textColor = .white
        workerID.textColor = .white
        joinTime.textColor = .white
        totalMoney.textColor = UIColor.DDTitleColor
        achievementTitle.textColor = UIColor.DDTitleColor
        timeLabel.textColor = UIColor.DDSubTitleColor
        personalReward.textColor = UIColor.DDSubTitleColor
        partnerReward.textColor = UIColor.DDSubTitleColor
        
        shopsCount.textColor = UIColor.DDTitleColor
        screensCount.textColor = UIColor.DDTitleColor
        
        toWeb.addTarget(self , action: #selector(toWebView), for: UIControlEvents.touchUpInside)
        chooseTime.addTarget(self , action: #selector(chooseTimeClick(sender:)), for: UIControlEvents.touchUpInside)
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
extension AchievementStatisticVC : UIPickerViewDataSource , UIPickerViewDelegate{
    class DDPickerContainer: UIView {
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            mylog("touch")
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return  1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.apiModel.data.date_list?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if let model  = self.apiModel.data.date_list?[row] {
            return model.create_at
        }
        return ""
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if let model  = self.apiModel.data.date_list?[row] {
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
//            cover?.addTarget(self , action: #selector(conerClick) , for: UIControlEvents.touchUpInside)
        pickerContainer.addSubview(picker)
        pickerContainer.addSubview(leftButton)
        pickerContainer.addSubview(rightButton)
        self.cover?.addSubview(pickerContainer)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            pickerContainer.frame = CGRect(x: 0 , y: self.view.bounds.height - pickerContainerH, width: self.view.bounds.width, height: pickerH)
        }, completion: { (bool ) in
        })
        for ( index ,  model) in (self.apiModel.data.date_list ?? []).enumerated(){
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
            self.requestApi(requestType:.refresh)
            self.chooseTime.title = "总计"

        }else{
            self.requestApi(requestType:.refresh,create_at : self.selectedDate)
            self.chooseTime.title = self.selectedDate
        }
        conerClick()
        let container2Margin : CGFloat = 15
        let chooseTimeW = chooseTime.title.sizeSingleLine(font: chooseTime.label.font).width + 20
        chooseTime.frame = CGRect(x:container2.bounds.width - chooseTimeW - container2Margin, y: container2Margin, width: chooseTimeW, height: 40)
        timeLabel.frame = CGRect(x:chooseTime.frame.minX - 99 - container2Margin, y: container2Margin, width: 99, height: 40)
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
*/
