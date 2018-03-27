//
//  DDItem4VC.swift
//  ZDLao
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit
import RxSwift

class DDItem4VC: DDNormalVC, BannerAutoScrollViewActionDelegate, DDBankChooseDelegate {
   
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var bottom: NSLayoutConstraint!
    @IBOutlet var top: NSLayoutConstraint!
    let calander = Calendar.current
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bottom.constant = DDTabBarHeight
        self.view.layoutIfNeeded()
        self.request()
        self.configBannerView()
        self.startTimeValue = self.calander.configStart()
        self.beginTimeBtn.setTitle(self.startTimeValue, for: .normal)
        let dict =  self.calander.configEnd(startTime: self.startTimeValue)
        self.endTimeValue = dict["endTime"] ?? ""
        self.timeLengthLabel.text = " " + (dict["dayCount"] ?? "") + "天" + " "
        self.day = Int(dict["dayCount"] ?? "0")!
        self.endTimeBtn.setTitle(self.endTimeValue, for: .normal)
        
        
        
        
    }
    

    var model: DDItem4Model<AdvertisModel, AdvertiseBannerModel>?
    func request() {
        let paramete = ["token": DDAccount.share.token ?? ""]
        NetWork.manager.requestData(router: Router.get("advert", .api, paramete)).subscribe(onNext: { (dict) in
            if let model = BaseModel<DDItem4Model<AdvertisModel, AdvertiseBannerModel>>.deserialize(from: dict), let data = model.data {
                self.model = data
                self.reloadBannerView()
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
        }
    }
    
    var screenItems: [AdvertisePickModel] {
        get {
            if let arr = self.model?.advert_position {
                var items: [AdvertisePickModel]  = [AdvertisePickModel]()
                arr.forEach({ (model) in
                    let resultModel = AdvertisePickModel.init()
                    resultModel.id = model.id
                    resultModel.name = model.name
                    items.append(resultModel)
                    
                })
                return items
            }else {
                return [AdvertisePickModel]()
            }
        }
    }
    var advertiseTimeItems: [AdvertisePickModel] {
        get {
            if let arr = self.model?.advert_position {
                if self.selectAddressModel == nil {
                    
                    return [AdvertisePickModel]()
                }else {
                    var items: [AdvertisePickModel]  = [AdvertisePickModel]()
                    arr.forEach({ (model) in
                        if model.id == self.selectAddressModel?.id {
                            model.time_list?.forEach({ (time) in
                                let resultModel = AdvertisePickModel.init()
                                resultModel.name = time
                                items.append(resultModel)
                            })
                            
                        }
                        
                        
                    })
                    return items
                }
                
            }else {
                return [AdvertisePickModel]()
            }
        }
    }
    
    var frequencyChildrenItems: [AdvertisePickModel] {
        get {
            if let arr = self.model?.advert_position {
                if self.selectAddressModel == nil {
                    
                    return [AdvertisePickModel]()
                }else {
                    var items: [AdvertisePickModel]  = [AdvertisePickModel]()
                    arr.forEach({ (model) in
                        if model.id == self.selectAddressModel?.id {
                            model.rate_list?.forEach({ (time) in
                                let resultModel = AdvertisePickModel.init()
                                resultModel.name = time
                                items.append(resultModel)
                            })
                            
                        }
                        
                        
                    })
                    return items
                }
                
            }else {
                return [AdvertisePickModel]()
            }
        }
    }
    var frequencyItems: [AdvertisePickModel] {
        get {
            if let arr = self.model?.advert_position {
                if self.selectAddressModel == nil {
                    
                    return [AdvertisePickModel]()
                }else {
                    var items: [AdvertisePickModel]  = [AdvertisePickModel]()
                    arr.forEach({ (model) in
                        if model.id == self.selectAddressModel?.id {
                            model.rate_list?.forEach({ (time) in
                                let resultModel = AdvertisePickModel.init()
                                resultModel.name = time + "频次/天"
                                items.append(resultModel)
                            })
                            
                        }
                        
                        
                    })
                    return items
                }
                
            }else {
                return [AdvertisePickModel]()
            }
        }
    }
    
    
    
    ///布局bannerview
    func configBannerView() {
        let height: CGFloat = (150.0 / 375.0) * SCREENWIDTH
        let bannerView = DDLeftRightAutoScroll.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: height))
        
        self.bannerView.addSubview(bannerView)
        
        bannerView.models = bannerDataArr
        self.banner = bannerView
        
        bannerView.delegate = self
    }
    ///刷新banner的数据
    func reloadBannerView() {
        self.banner?.models = self.bannerDataArr
    }
    var banner: DDLeftRightAutoScroll?
    var bannerDataArr: [DDHomeBannerModel] {
        get {
            var dataArr = [DDHomeBannerModel]()
            if let arr = self.model?.banner {
                
                arr.forEach({ (model) in
                    let otherModel = DDHomeBannerModel.init()
                    otherModel.link_url = model.link_url
                    otherModel.image_url = model.image_url
                    dataArr.append(otherModel)
                })
                
            }
            return dataArr
        }
    }
    
    func performBannerAction(indexPath: IndexPath) {
        //点击banner图到的操作
        let model = self.bannerDataArr[indexPath.row]
        self.pushVC(vcIdentifier: "GDBaseWebVC", userInfo: model.link_url)
        
    }
    
    @IBOutlet var bannerView: UIView!
    @IBOutlet var beginTimeBtn: UIButton!
    var timePickView: AdvertisePickView?
    @IBAction func beginTimeAction(_ sender: UIButton) {
        self.advetiseStartTime(pickerTitleText: "  请选择起始时间:", isStart: true, startTime: "")
        self.timePickView?.finishedSelect.subscribe(onNext: { [unowned self](time) in
            self.beginTimeBtn.setTitle(time, for: .normal)
            self.startTimeValue = time
            
            
            let dict =  self.calander.configEnd(startTime: self.startTimeValue)
            self.endTimeValue = dict["endTime"] ?? ""
            self.timeLengthLabel.text = " " + (dict["dayCount"] ?? "") + "天" + " "
            self.day = Int(dict["dayCount"] ?? "0")!
            self.endTimeBtn.setTitle(self.endTimeValue, for: .normal)
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    @IBOutlet var timeLengthLabel: UILabel!
    @IBOutlet var endTimeBtn: UIButton!
    @IBAction func endTimeBtnAction(_ sender: UIButton) {
        if self.startTimeValue.count > 0 {
            self.advetiseStartTime(pickerTitleText: "  请选择结束时间:", isStart: false, startTime: self.beginTimeBtn.currentTitle!)
        }else {
            GDAlertView.alert("请选择开始时间", image: nil, time: 1, complateBlock: nil)
            return
            
        }
        self.timePickView?.finishedSelect.subscribe(onNext: { [weak self](time) in
            self?.endTimeBtn.setTitle(time, for: .normal)
            let day = (self?.calander.getDifferenceByDate(oldTime: (self?.startTimeValue)!, newTime: time))! + 1
            self?.day = day
            self?.timeLengthLabel.text = String.init(format: " %d天 ", day)
            self?.endTimeValue = time
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
       
        
        
        
    }
    ///开始时间
    var startTimeValue: String = ""
    ///结束时间
    var endTimeValue: String = ""
    ///广告天数
    var day: Int = 0
    var rate: String = ""
    var time: String = ""
    var advertID: String = ""
    var advertIDName: String = ""
    var area: String = ""
    var areaName: String = ""
    //投放地区
    
    
    @IBOutlet var toufangAddressBtn: UIButton!
    
    @IBAction func toufangAddressAction(_ sender: UIButton) {
        let vc = ToufangAreaVC.init(nibName: "ToufangAreaVC", bundle: Bundle.main)
        self.navigationController?.pushViewController(vc, animated: true)
        vc.selectArea.subscribe(onNext: { (dict) in
            self.area = dict["area"]!
            self.areaName = dict["areaName"]!
            self.toufangAddressBtn.setTitle(self.areaName, for: .normal)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    //查看已经选择的地区
    @IBAction func chakanTouFangAddressAction(_ sender: UIButton) {
        if self.areaName.count <= 0 {
            GDAlertView.alert("请先选择投放地区", image: nil, time: 2, complateBlock: nil)
            return
        }
        self.pushVC(vcIdentifier: "DDSelectedAreaVC", userInfo: "0")
    }
    
    @IBOutlet var guanggaoweiBtn: UIButton!
    
    @IBAction func guanggaoweiAction(_ sender: UIButton) {
        //广告位
        self.advertiseAddress()
        
    }
    
    @IBAction func guanggaoweiyulanAction(_ sender: UIButton) {
        //广告位预览
        let promptVC = ScreenPromptVC()
        promptVC.items = self.model?.advert_position
        self.navigationController?.pushViewController(promptVC, animated: true)
    }
    
    @IBOutlet var guanggaotimeLengthBtn: UIButton!
    var cover: DDCoverView?
   
    @IBAction func guanggaoTimelengthAction(_ sender: UIButton) {
        //选择广告的时长
        self.advertiseTime()
    }
    
    var vertiseTime: AdvertisementTime?
    var vertiseAddress: AdvertisementTime?
    var vertiseRate: AdvertisementTime?
    var selectAddressModel: AdvertisePickModel?
    var selectTimeModel: AdvertisePickModel?
    var selectScreenModel: AdvertisModel?
    
    
    func didSelectRowAt(indexPath: IndexPath, target: UIView?) {
        if target == self.vertiseAddress {
            let model = self.screenItems[indexPath.row]
            self.selectAddressModel = model
            if let arr = self.model?.advert_position {
                self.selectScreenModel = arr[indexPath.row]
            }
            
            self.guanggaoweiBtn.setTitle(model.name, for: .normal)
            self.advertID = model.id ?? ""
            self.advertIDName = model.name ?? ""
            self.conerClick()
            self.vertiseAddress = nil
            if self.time.count <= 0 {
                
            }else {
                self.time = ""
                self.guanggaotimeLengthBtn.setTitle("请选择投放内容的时长", for: .normal)
            }
            if self.rate.count <= 0 {
                
            }else {
                self.rate = ""
                self.pinciBtn.setTitle("请选择播放内容的频次", for: .normal)
            }
            
            
            
            
        }else if self.vertiseTime == target{
            let model = self.advertiseTimeItems[indexPath.row]
            self.guanggaotimeLengthBtn.setTitle(model.name, for: .normal)
            self.time = model.name ?? ""
            self.conerClick()
            self.vertiseTime = nil
        }else {
            let model = self.frequencyItems[indexPath.row]
            self.pinciBtn.setTitle(model.name!, for: .normal)
            let childrenModel = self.frequencyChildrenItems[indexPath.row]
            self.rate = childrenModel.name ?? ""
            self.conerClick()
            self.vertiseRate = nil
        }
    }
    
    @IBAction func tishiTimeLength(_ sender: UIButton) {
        //查看播放内容时长的提示
        
        GDAlertView.alert("广告时长即为您选择提交广告素材的时间长度，本系统默认按照最小单位5s的倍数进行销售。", image: nil, time: 1, complateBlock: nil)

    }
    
    @IBOutlet var pinciBtn: UIButton!
    
    @IBAction func pinciAction(_ sender: UIButton) {
        self.advertiseRate()
    }
    @IBAction func pinciChankanAction(_ sender: UIButton) {
        //查看频次的提示
        GDAlertView.alert("广告播放频次即为广告每天播放的次数，本系统默认按照最小单位12次/天的倍数进行销售。", image: nil, time: 1, complateBlock: nil)
    }
    
    
    @IBAction func chanxunAction(_ sender: UIButton) {
        self.chaxunResultView()
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
}
extension DDItem4VC {
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
    func advertiseTime() {
        if self.selectAddressModel == nil {
            GDAlertView.alert("请先选择屏幕板块", image: nil, time: 1, complateBlock: nil)
            return
        }
        let pickerTitle = UILabel(frame: CGRect(x:0 , y: 0, width: SCREENWIDTH, height: 44))
        pickerTitle.text = "  请选择购买广告的时长:"
        let pickerContailerH: CGFloat = 7 * 40
        let pickerContainer = AdvertisementTime.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: pickerContailerH))
        pickerContainer.delegate = self
        cover = DDCoverView.init(superView: self.view)
        cover?.deinitHandle = {
            self.conerClick()
        }
        self.cover?.addSubview(pickerContainer)
        pickerContainer.backgroundColor = UIColor.white
        pickerContainer.pickerTitleView = pickerTitle
        pickerContainer.addSubview(pickerTitle)
        pickerContainer.models = self.advertiseTimeItems
        self.vertiseTime = pickerContainer
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            pickerContainer.frame = CGRect(x: 0 , y: self.view.bounds.height - pickerContailerH - TabBarHeight - 49, width: self.view.bounds.width, height: pickerContailerH)
        }, completion: { (bool ) in
        })
    }
    func advertiseAddress() {
        let pickerView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 225.5 + 30))
        pickerView.image = UIImage.init(named: "screenselection")
        pickerView.contentMode = .center
        let pickerContailerH: CGFloat = CGFloat(self.screenItems.count) * 40 + 225.5 + 30
        let pickerContainer = AdvertisementTime.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: pickerContailerH))
        pickerContainer.delegate = self
        cover = DDCoverView.init(superView: self.view)
        cover?.deinitHandle = {
            self.conerClick()
        }
        self.vertiseAddress = pickerContainer
        self.cover?.addSubview(pickerContainer)
        pickerContainer.backgroundColor = UIColor.white
        pickerContainer.pickerTitleView = pickerView
        pickerContainer.addSubview(pickerView)
        pickerContainer.models = self.screenItems
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            pickerContainer.frame = CGRect(x: 0 , y: self.view.bounds.height - pickerContailerH - TabBarHeight - 49, width: self.view.bounds.width, height: pickerContailerH)
        }, completion: { (bool ) in
        })
    }

    func advertiseRate() {
        if self.selectAddressModel == nil {
            GDAlertView.alert("请先选择屏幕板块", image: nil, time: 1, complateBlock: nil)
            return
        }
        let pickerTitle = UILabel(frame: CGRect(x:0 , y: 0, width: SCREENWIDTH, height: 44))
        pickerTitle.text = "  请选择广告播放频次:"
        let pickerContailerH: CGFloat = 7 * 40
        let pickerContainer = AdvertisementTime.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: pickerContailerH))
        pickerContainer.delegate = self
        cover = DDCoverView.init(superView: self.view)
        cover?.deinitHandle = {
            self.conerClick()
        }
        self.cover?.addSubview(pickerContainer)
        pickerContainer.backgroundColor = UIColor.white
        pickerContainer.pickerTitleView = pickerTitle
        pickerContainer.addSubview(pickerTitle)
        self.vertiseRate = pickerContainer
        pickerContainer.models = self.frequencyItems
        self.vertiseRate = pickerContainer
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            pickerContainer.frame = CGRect(x: 0 , y: self.view.bounds.height - pickerContailerH - TabBarHeight - 49, width: self.view.bounds.width, height: pickerContailerH)
        }, completion: { (bool ) in
        })
    }
    
    func advetiseStartTime(pickerTitleText: String, isStart: Bool, startTime: String) {
        let pickerTitleView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 44))
        
        
        
        let pickerTitle = UILabel(frame: CGRect(x:0 , y: 0, width: SCREENWIDTH - 80, height: 44))
        pickerTitle.text = pickerTitleText
        pickerTitleView.addSubview(pickerTitle)
        
        
        
        let rightBtn: UIButton = UIButton.init(frame: CGRect.init(x: SCREENWIDTH - 80, y: 0, width: 80, height: pickerTitleView.height))
        rightBtn.setTitle("确定", for: .normal)
        rightBtn.setTitleColor(UIColor.colorWithHexStringSwift("ed8102"), for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightBtn.addTarget(self, action: #selector(rightBtnAction(btn:)), for: .touchUpInside)
        pickerTitleView.addSubview(rightBtn)
        
        
        
        
        
        let pickerContailerH: CGFloat = 44 * 4
        var pickerContainer: AdvertisePickView!
        if isStart {
            let view = AdvertisePickView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: pickerContailerH), isStart: isStart)
            pickerContainer = view
        }else {
            pickerContainer = AdvertisePickView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: pickerContailerH), isStart: false, startTime: startTime + " 00:00:00")
        }
        
        cover = DDCoverView.init(superView: self.view)
        cover?.deinitHandle = {
            self.conerClick()
        }
        self.timePickView = pickerContainer
        self.cover?.addSubview(pickerContainer)
        pickerContainer.backgroundColor = UIColor.white
        pickerContainer.pickerTitleView = pickerTitleView
        pickerContainer.addSubview(pickerTitleView)

        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            pickerContainer.frame = CGRect(x: 0 , y: self.view.bounds.height - pickerContailerH - TabBarHeight - 49, width: self.view.bounds.width, height: pickerContailerH)
        }, completion: { (bool ) in
        })
    }
    
    @objc func rightBtnAction(btn: UIButton) {
        
        self.timePickView?.sure()
        self.conerClick()
        self.timePickView = nil
        
    }
    
    
    

    func chaxunResultView() {
        
        if self.advertID.count <= 0 {
            GDAlertView.alert("请选择投放屏幕位置", image: nil, time: 1, complateBlock: nil)
            return
            
        }
        if self.time.count <= 0 {
            GDAlertView.alert("请选择播放时长", image: nil, time: 1, complateBlock: nil)
            return
        }
        if self.area.count <= 0 {
            GDAlertView.alert("请选择投放地区", image: nil, time: 1, complateBlock: nil)
            return
        }
        if self.rate.count <= 0 {
            GDAlertView.alert("请选择播放频次", image: nil, time: 1, complateBlock: nil)
            return
        }
        
        cover = DDCoverView.init(superView: self.view)
        cover?.deinitHandle = {
            self.conerClick()
        }
        let width: CGFloat = 280
        let height: CGFloat = 385
        let x: CGFloat = (SCREENWIDTH - width) / 2.0
        let y: CGFloat = (SCREENHEIGHT - height) / 2.0
        let resultView = ResultView.init(frame: CGRect.init(x: x, y: 0, width: width, height: height))
        let time = self.startTimeValue + "到" + self.endTimeValue
        resultView.timeLabel.text = time
        resultView.areaLabel.text = self.areaName
        resultView.advertisLabel.text = self.advertIDName
        resultView.timeLengthLabel.text = self.time
        resultView.ratelabel.text = self.rate
        resultView.dayCout.text = String(self.day) + "天"
        self.cover?.addSubview(resultView)
        
        
        
        
        resultView.cancel.subscribe(onNext: { [weak self](value) in
            if value == "cancle" {
                self?.conerClick()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        //查询
        var totalPrice: String = ""
        var dayPrice: String = ""
        let token: String = DDAccount.share.token ?? ""
        let paramter = ["advert_id": self.advertID, "time": self.time, "rate": self.rate, "area": self.area, "total_day": String(self.day), "token": token]
        
        
        var param = ["time": time, "area":self.area, "areaName": self.areaName, "advertise": self.advertIDName, "advert_time": self.time, "rate": self.rate, "total_day": String(self.day), "dayPrice": dayPrice, "totalPrice": totalPrice, "format":self.selectScreenModel?.format ?? "", "size": self.selectScreenModel?.size ?? "", "sepc": self.selectScreenModel?.spec ?? "", "start_at": self.startTimeValue, "end_at": self.endTimeValue, "advert_id": self.advertID]
        
        
        
        
        NetWork.manager.requestData(router: Router.post("advert", .api, paramter)).subscribe(onNext: { (dict) in
            if let data = dict["data"] as? [String: AnyObject]{
                if let price = data["order_price"] as? String {
                    totalPrice = String(price)
                    param["totalPrice"] = totalPrice
                    resultView.totalPrice.text = String(price) + "元"
                }
                
                if let unit_price = data["unit_price"] as? String{
                    dayPrice = String(unit_price)
                    param["dayPrice"] = dayPrice
                    resultView.pricelabel.text = String(unit_price) + "元/天"
                }
                if let ration = data["prepayment_ratio"] as? String{
                    param["ratio"] = ration
                }
                
                
                
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
        
        resultView.sureAction.subscribe(onNext: { [weak self](value) in
            self?.conerClick()
            self?.pushVC(vcIdentifier: "TrueOrderVC", userInfo: param)
            
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            resultView.frame = CGRect.init(x: x, y: y, width: width, height: height)
        }, completion: { (bool ) in
        })
        
    }
    
    
    
    
    
}
class AdvertisePickModel: GDModel {
    var id: String?
    var name: String?
}

class AdvertisePickView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
  
    let pickerView: UIPickerView = UIPickerView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 40))
    var leftMonthArrs: [String] = Calendar.current.shortMonthSymbols
    var delegate: DDBankChooseDelegate?
    var rightDaysArrs: [String] {
        get {
            if isStart {
                return ["1日", "16日"]
            }else {
                
                return ["15日", "月底"]
            }
        }
    }
    var isStart: Bool = true
    var pickerTitleView: UIView?
    init(frame: CGRect, isStart: Bool) {
        super.init(frame: frame)
        self.isStart = isStart
        self.addSubview(self.pickerView)
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        if isStart {
            self.configStart()
            
        }else {
            
            
        }
        
        
        
    }
    init(frame: CGRect, isStart: Bool, startTime: String) {
        super.init(frame: frame)
        self.isStart = isStart
        self.addSubview(self.pickerView)
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        if isStart {
            self.configStart()
            
        }else {
            self.configEnd(startTime: startTime)
            
        }
    }
    
    
    
    func sure() {
        let month: String = String.init(format: "%02d", self.selectMonth)
        let day: String = String.init(format: "%02d", self.selectDay)
        let result = String(startYear) + "-" + month + "-" + day
        finishedSelect.onNext(result)
        finishedSelect.onCompleted()
        
    }
    let finishedSelect: PublishSubject<String> = PublishSubject<String>.init()
    
    
    var startMonth: Int = 1
    var startDay: Int = 1
    var startYear: Int = Calendar.current.getyear()
    var selectMonth: Int = 1
    var selectDay: Int = 1
    func configStart() {
        let currentMonth = calander.getMonth()
        ///首先看看从现在开始推迟7天后有没有超过16号
        let zhidingDate = calander.getZhiDingTime(month: currentMonth, day: 16)
        ///退职七天之后的日期
        let targetDate = calander.getTargetTimeWith(day: "", num: 7)
        self.startMonth = currentMonth
        self.selectMonth = currentMonth
        let result = calander.comparDate(date1: zhidingDate, date2: targetDate)
        if (result == -1) || (result == 0) {
            //开始时间移动到下一个月
            let targetMonth = currentMonth + 1
            self.startMonth = targetMonth
            self.selectMonth = targetMonth
            self.pickerView.selectRow(targetMonth - 1, inComponent: 0, animated: false)
            self.pickerView.selectRow(0, inComponent: 1, animated: false)
            self.startDay = 1
            self.selectDay = 1
        }else {
            self.pickerView.selectRow(currentMonth - 1, inComponent: 0, animated: false)
            self.pickerView.selectRow(1, inComponent: 1, animated: false)
            self.startDay = 16
            self.selectDay = 16
            
        }
    }
    
    func configEnd(startTime: String) {
        self.startMonth = calander.getTargetMonthWithStr(time: startTime)
        self.startDay = calander.getTargetDayWithStr(time: startTime)
        
        if self.startDay == 1 {
            //是从该月的第一天开始的。
            self.selectMonth = self.startMonth
            self.selectDay = 15
            self.pickerView.selectRow(self.selectMonth - 1, inComponent: 0, animated: false)
            self.pickerView.selectRow((self.selectDay == 15) ? 0:1, inComponent: 1, animated: false)
        }else {
            self.selectMonth = self.startMonth
            self.selectDay = calander.getTargetMonthCountDay(month: self.startMonth)
            self.pickerView.selectRow(self.selectMonth - 1, inComponent: 0, animated: false)
            self.pickerView.selectRow((self.selectDay == 15) ? 0:1, inComponent: 1, animated: false)
            
        }
        
        
        
    }
    
    
    
    
    let calander = Calendar.current
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.pickerTitleView != nil {
            self.pickerView.frame = CGRect.init(x: 0, y: self.pickerTitleView?.height ?? 40, width: SCREENWIDTH, height: self.height - (self.pickerTitleView?.height ?? 40))
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.leftMonthArrs.count
        }else {
            return self.rightDaysArrs.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        
        if let  cell = view as? PickerCell {
            if component == 0 {
                cell.label.text = self.leftMonthArrs[row]
            }else {
                cell.label.text = self.rightDaysArrs[row]
            }
            
            return cell
        }else {
            let cell: PickerCell = PickerCell.init(frame: CGRect.init())
            if component == 0 {
                cell.label.text = self.leftMonthArrs[row]
            }else {
                cell.label.text = self.rightDaysArrs[row]
            }
            
            return cell
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return SCREENWIDTH / 2.0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.isStart {
            
            
            if component == 0 {
                let startIndex: Int = self.startMonth - 1
                if row <= startIndex {
                    pickerView.selectRow(startIndex, inComponent: 0, animated: true)
                    let dayIndex: Int = (self.startDay == 1) ? 0:1
                    pickerView.selectRow(dayIndex, inComponent: 1, animated: true)
                }else {
                    
                    self.selectMonth = row + 1
                }
                
                
            }else {
            
                
                if self.selectMonth <= self.startMonth {
                    pickerView.selectRow(self.startMonth - 1, inComponent: 0, animated: true)
                    if self.startDay == 1 {
                        self.selectDay = (row == 0) ? 1:16
                    }else {
                        pickerView.selectRow(1, inComponent: 1, animated: true)
                        self.selectDay = 16
                    }
                }else {
                    
                    self.selectDay = (row == 0) ? 1:16
                }
                
                
            }
            
            
            
            
        }else {
            
            if component == 0 {
                let startIndex: Int = self.startMonth - 1
                if row <= startIndex {
                    pickerView.selectRow(startIndex, inComponent: 0, animated: true)
                    let dayIndex: Int = (self.startDay == 1) ? 0:1
                    pickerView.selectRow(dayIndex, inComponent: 1, animated: true)
                }else {
                    
                    self.selectMonth = row + 1
                }
                
                
            }else {
                
                
                if self.selectMonth <= self.startMonth {
                    pickerView.selectRow(self.startMonth - 1, inComponent: 0, animated: true)
                    if self.startDay == 1 {
                        self.selectDay = (row == 0) ? 1:calander.getTargetMonthCountDay(month: self.selectMonth)
                    }else {
                        pickerView.selectRow(1, inComponent: 1, animated: true)
                        self.selectDay = calander.getTargetMonthCountDay(month: self.selectMonth)
                    }
                }else {
                    
                    self.selectDay = (row == 0) ? 15: calander.getTargetMonthCountDay(month: self.selectMonth)
                }
                
                
            }
            
            
            
            
        }
        
    
    }
    
    
    class PickerCell: UIView {
        let label = UILabel.init()
        override init(frame: CGRect) {
            super.init(frame: frame)
            label.font = UIFont.systemFont(ofSize: 15)
            label.textColor = UIColor.colorWithHexStringSwift("333333")
            label.textAlignment = .center
            label.backgroundColor = UIColor.white
            self.addSubview(label)
         
            self.label.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            
        
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("in；it(coder:) has not been implemented")
    }
    
    
    
    
}








class AdvertisementTime: UIView ,UITableViewDelegate , UITableViewDataSource{
    var models : [AdvertisePickModel]?{
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
    var pickerTitleView: UIView?
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mylog(indexPath)
        self.delegate?.didSelectRowAt(indexPath: indexPath, target: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
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
        self.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        //            tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.pickerTitleView != nil {
            self.tableView.frame = CGRect(x: 0, y: self.pickerTitleView?.max_Y ?? 40, width: self.bounds.width, height: self.bounds.height - (self.pickerTitleView?.height ?? 40 ))
        }
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




