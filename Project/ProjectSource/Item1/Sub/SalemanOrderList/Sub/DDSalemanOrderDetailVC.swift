//
//  DDSalemanOrderDetailVC.swift
//  Project
//
//  Created by WY on 2018/3/14.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
private let topBarH : CGFloat = 64
private let bottomBarH : CGFloat = 40
private let scrollViewH : CGFloat = SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight -  bottomBarH
private let bottomTipsH : CGFloat = 64
class DDSalemanOrderDetailVC: DDNormalVC {

    
    /// -1放弃支付0待支付1待补交2预付款已逾期 3 已完成
    enum OrderType:String {
        case type1 = "-1"//放弃支付 ["联系客服" , "重新购买" ] , [ .lightGray , .orange]
        case type2 = "0"//待支付 ["放弃支付" , "继续支付" ] , [ .lightGray , .orange]
        case type3 = "1"//待补交 ["售后" , "修改时间" , "补交费用"] , [.black , .lightGray , .orange]
        case type4 = "2"//预付款已逾期 ["联系客服" , "重新购买" ] ,  [ .lightGray , .orange]//自己加的
        case type5 = "3"// 已完成 ["售后" , "修改时间" , "再次购买"] , [.black , .lightGray , .orange]
    }
    var apiModel : DDOrderDetailApiModel = DDOrderDetailApiModel()
    let topBar = DDOrderProcessView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: topBarH))
    let bottomTips = UILabel()
    let bottomBar = DDActionSelectBar(frame: CGRect(x: 0, y: SCREENHEIGHT - DDSliderHeight - bottomBarH, width: SCREENWIDTH, height: 34))
    //    let arr = ["售后","修改时间","补交费用"]
    let scrollView = UIScrollView(frame: CGRect(x: 0, y: DDNavigationBarHeight , width: SCREENWIDTH, height: scrollViewH))
    let contentView = DDSalemanOrderContentView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订单详情"
        self.configBottomBar()
        self.configScrollView()
        configTopBar()
        self.configContenView()
        requestApi()
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("#e9e9e9")
        
    }
    func configTopBar()  {
        self.scrollView.addSubview(topBar)
        topBar.backgroundColor = UIColor.DDLightGray1
    }
    func configBottomBar()  {
        self.view.addSubview(bottomBar)
        bottomBar.action = {[unowned  self] index in
            //            mylog(index)
            switch index {
            case 1:
                if self.apiModel.data?.order?.custom_complain_type ?? "2" == "1"{
                    GDAlertView.alert("已投诉", image: nil, time: 2, complateBlock: nil)
                }else{
                    self.tousu()
                }
            case 2:
                self.connectCustomer()
            default :
                break
            }
//            switch (self.apiModel.data?.order?.payment_status ?? "") {
//            case OrderType.type1.rawValue:
//                // ["放弃支付" , "重新购买" ]
//                if index == 1 {
//                    self.connectCustomer()
//                }else if index == 2{
//                    self.buyAgain()
//                }
//            case OrderType.type2.rawValue:
//                // ["放弃支付" , "继续支付" ]
//                if (self.apiModel.data?.order?.remittance ?? "") == "1"{
//                    if index == 1{
//                        self.payCancle()
//                    }else if index == 2 {self.seeRemitInfo()}
//                }else{
//                    if index == 1{
//                        self.payCancle()
//                    }else if index == 2{
//                        self.payContinue()
//                    }
//                }
//            case OrderType.type3.rawValue:
//                //["售后" , "修改时间" , "补交费用"]
//                if (self.apiModel.data?.order?.remittance ?? "") == "1"{
//                    if index == 1{
//                        self.payCancle()
//                    }else if index == 2 {self.seeRemitInfo()}
//                }else{
//                    if index == 1{
//                        self.shouHou()
//                    }else if index == 2{
//                        self.modifyTime()
//                    }else if index == 3{
//                        self.buJiao()
//                    }
//                }
//            case OrderType.type4.rawValue:
//                if index == 1{
//                    self.shouHou()
//                }else if index == 2{
//                    self.buyAgain()
//                }
//                break
//            case OrderType.type5.rawValue:
//                if index == 1{
//                    self.shouHou()
//                }else if index == 2{
//                    self.modifyTime()
//                }else if index == 3{
//                    self.buyAgain()
//                }
//                //["售后" , "修改时间" , "再次购买"]
//                break
//            default:
//                break
//            }
        }
    }
    func configScrollView() {
        self.view.addSubview(scrollView)
        //        scrollView.backgroundColor = .orange
        self.scrollView.addSubview(bottomTips)
        bottomTips.textAlignment = .center
        bottomTips.numberOfLines = 2
        bottomTips.textColor = .lightGray
        bottomTips.font = GDFont.systemFont(ofSize: 13)
        
    }
    func configContenView()  {
        self.scrollView.addSubview(contentView)
        contentView.frame = CGRect(x: 10, y: topBar.bounds.height + 10, width: self.scrollView.bounds.width - 10 * 2 , height: self.scrollView.bounds.height)
        
        contentView.action = {[weak self ] tag in
            switch tag {
            case 1: // 查看地区
                self?.seeSelectedArea()
            case 2: // 评价业务合作人
//                self?.commentYeWu()
                break
            case 3: // 评价广告对接人
//                self?.commentDuiJie()
                break
            case 4: // 素材提交
                self?.suCaiTips()
            default:
                break
            }
            //            mylog(tag)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func requestApi() {
        var orderID = ""
        if let temp = self.userInfo as? String{orderID = temp}
        DDRequestManager.share.saleManOrderDetail(order_id: orderID, true)?.responseJSON(completionHandler: { (response ) in
            if let apiModel = DDDecode(DDOrderDetailApiModel.self , from: response){
                self.apiModel = apiModel
                mylog(apiModel)
                self.configTopAndBottomView(apiModel: apiModel)
                self.contentView.apiModel = apiModel
                self.scrollView.contentSize = CGSize(width: SCREENWIDTH, height: self.contentView.frame.height + topBarH + 10 + bottomTipsH)
                mylog(self.scrollView.contentSize)
                
                self.bottomTips.frame = CGRect(x: 0, y: self.contentView.frame.maxY, width: SCREENWIDTH, height: bottomTipsH)
            }
        })
    }
    func configTopAndBottomView(apiModel: DDOrderDetailApiModel)  {
        ///素材审核状态0待提交1待审核2被驳回3待投放4已投放5投放完成
        switch (apiModel.data?.order?.examine_status ?? "") {
        case "-1":
            bottomTips.text = ""
        case "0":
            topBar.process = .type2
            bottomTips.text = "请尽快登陆素材提交网站 提交相关广告素材\nhttp://www.bjyltf.com"
        case "1":
            topBar.process = .type3
            bottomTips.text = "素材提交成功 , 请等待审核"
        case "2":
            topBar.process = .type3
//            bottomTips.text = "审核未通过"
            bottomTips.text = apiModel.data?.order?.examine_desc
        case "3":
            topBar.process = .type4
        case "4" , "5":
            break
        case OrderType.type5.rawValue:
            topBar.process = .type5
            
        default:
            break
        }
        
        
        
        
        switch (apiModel.data?.order?.payment_status ?? "") {
        case OrderType.type1.rawValue:
//            bottomBar.actionTitleArr = ["联系客服" , "重新购买" ]
//            bottomBar.colors = [ .lightGray , .orange]
            topBar.process = .type6
        case OrderType.type2.rawValue:
//            if (apiModel.data?.order?.remittance ?? "") == "1"{
//                bottomBar.actionTitleArr = ["放弃支付" , "查看汇款信息" ]
//            }else{
//                bottomBar.actionTitleArr = ["放弃支付" , "继续支付" ]
//            }
//            bottomBar.colors =  [ .lightGray , .orange]
            break
        case OrderType.type3.rawValue:
//            if (apiModel.data?.order?.remittance ?? "") == "1"{
//                bottomBar.actionTitleArr = ["放弃支付" , "查看汇款信息" ]
//                bottomBar.colors =  [ .lightGray , .orange]
//            }else{
//                bottomBar.actionTitleArr = ["售后" , "修改时间" , "补交费用"]
//                bottomBar.colors =  [.black , .lightGray , .orange]
//            }
            break
        case OrderType.type4.rawValue:
            bottomTips.text = "尾款已逾期,请联系客服"
//            bottomBar.actionTitleArr = ["联系客服" , "重新购买" ]
//            bottomBar.colors =   [ .lightGray , .orange]
            break
        case OrderType.type5.rawValue:
//            let suCaiStatus = (apiModel.data?.order?.examine_status ?? "")
//            if suCaiStatus == "4" || suCaiStatus == "5"{
//                bottomBar.actionTitleArr = ["售后"  , "再次购买"]
//                bottomBar.colors =  [.lightGray , .orange]
//            }else{
//                bottomBar.actionTitleArr = ["售后" , "修改时间" , "再次购买"]
//                bottomBar.colors =  [.black , .lightGray , .orange]
//            }
            bottomTips.text = ""
        default:
            break
        }
        
        bottomBar.scaleArr  = [0.4 , 0.6]
        if self.apiModel.data?.order?.custom_complain_type ?? "2" == "1"{
            bottomBar.actionTitleArr = ["已投诉" , "联系客户" ]
        }else{
            bottomBar.actionTitleArr = ["投诉" , "联系客户" ]
        }
        bottomBar.colors =   [ .lightGray , .orange]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension DDSalemanOrderDetailVC {
//    func commentYeWu(){//评价业务合作人
//        mylog("评价业务合作人")
//        self.pushVC(vcIdentifier: "DDCommentPersonVC", userInfo: ["key1":DDCommentPersonVC.PersonType.hezuo,"key2": (apiModel.data?.order?.custom_service_name ?? "") , "key3": (apiModel.data?.order?.id ?? "")])
//    }
//    func commentDuiJie(){//评价广告对接人
//        mylog("评价广告对接人")
//        self.pushVC(vcIdentifier: "DDCommentPersonVC", userInfo: ["key1":DDCommentPersonVC.PersonType.duijie,"key2": (apiModel.data?.order?.salesman_name ?? ""), "key3": (apiModel.data?.order?.id ?? "")])
//    }
    func suCaiTips(){//素材提示
        mylog("关于素材的提示")
        DDSuCaiTipsAlert(superView: self.view )
    }
    ///看看已选地区
    func seeSelectedArea(){self.pushVC(vcIdentifier: "DDSelectedAreaVC" , userInfo: self.apiModel.data?.order?.id ?? "0")}
    ///售后
//    func shouHou() {
//        mylog("售后")
//        UIApplication.shared.openURL(URL(string: "telprompt:4006061818")!)
//    }
    ///修改时间
//    func modifyTime() {
//        mylog("改时间")
//        //        DDChangeTimeLimitAlert(superView: self.view )
//        DDChangeTimeAlert(superView: self.view )
//    }
    ///再次购买
//    func buyAgain() {
//        mylog("再次购买")
//    }
    ///放弃支付
//    func payCancle() {
//        mylog("放弃支付")
//        DDCanclePayAlertView.init(superView: self.view ).action = {[weak self ] reason in
//            mylog(reason)
//            var reasonStr = ""
//            switch reason  {
//            case 1:
//                reasonStr = "信息错误,重新购买"
//            case 2:
//                reasonStr = "放弃购买"
//            case 3:
//                reasonStr = "其他"
//            default:
//                break
//            }
//            DDRequestManager.share.canclePay(order_id: self?.apiModel.data?.order?.id ?? "", cancleRease: reasonStr, true)?.responseJSON(completionHandler: { (response ) in
//                self?.viewDidLoad()
//            })
//        }
//    }
    ///继续支付
//    func payContinue() {
//        mylog("继续支付")
//    }
//    func buJiao() {
//        mylog("补交费用")
//    }
    ///联系客服
//    func connectCustomerService() {
//        mylog("联系客服")
//    }
    ///联系客户
    func connectCustomer() {
        mylog("联系客户")
        if let mobile  = apiModel.data?.order?.mobile {
            UIApplication.shared.openURL(URL(string: "telprompt:\(mobile)")!)
        }
    }
    ///查看汇款信息
    func seeRemitInfo() {
        mylog("查看汇款信息")
//        self.pushVC(vcIdentifier: "UnderPayVC")
        self.pushVC(vcIdentifier: "UnderPayVC" , userInfo: self.apiModel.data?.order?.id)
    }
    ///投诉
    func tousu() {//需要更改参数
        mylog("投诉")
        if apiModel.data?.order?.custom_complain_type ?? "2" == "1"{
            GDAlertView.alert("已评价,请勿重复评价", image: nil, time: 2, complateBlock: nil)
            return
        }
        self.pushVC(vcIdentifier: "DDCommentPersonVC", userInfo: ["key1":"touSuDuiJieRen","key2": (apiModel.data?.order?.custom_service_name ?? ""), "key3": (apiModel.data?.order?.id ?? "")])
    }
}

