//
//  DDSalemanOrderContentView.swift
//  Project
//
//  Created by WY on 2018/3/14.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

private let toBorderMargin : CGFloat = 10
private let rowHeight : CGFloat = 40
private let rowWidth : CGFloat = SCREENWIDTH - toBorderMargin * 2
class DDSalemanOrderContentView: UIView {
    var action : ((Int)->())?
    let kehu = RowView1(frame: CGRect(x: -10, y: 0, width:SCREENWIDTH, height: rowHeight))
    let orderNum = RowView(frame: CGRect(x: 0, y: 0, width:rowWidth, height: rowHeight), rowType: .type1)
    let createOrderTime = RowView(frame: CGRect(x: 0, y: 0, width:rowWidth, height: rowHeight), rowType: .type1)
    let userLocation = RowView(frame: CGRect(x: 0, y: 0, width:rowWidth, height: rowHeight), rowType: .type1)
    
    let sentTime = RowView(frame: CGRect(x: 0, y: 0, width:rowWidth, height: rowHeight), rowType: .type1)
    let sentArea = RowView(frame: CGRect(x: 0, y: 0, width:rowWidth, height: rowHeight), rowType: .type3)
    let areaType = RowView(frame: CGRect(x: 0, y: 0, width:rowWidth, height: rowHeight), rowType: .type1)
    let addShowTime = RowView(frame: CGRect(x: 0, y: 0, width:rowWidth, height: rowHeight), rowType: .type1)
    let rate = RowView(frame: CGRect(x: 0, y: 0, width:rowWidth, height: rowHeight), rowType: .type1)
    let daysCount = RowView(frame: CGRect(x: 0, y: 0, width:rowWidth, height: rowHeight), rowType: .type2)
    let unitPrice = RowView(frame: CGRect(x: 0, y: 0, width:rowWidth, height: rowHeight), rowType: .type2)
    let dingjin = RowView1(frame: CGRect(x: 0, y: 0, width:rowWidth, height: rowHeight))
    

    let weiKuan = RowView1(frame: CGRect(x: 0, y: 0, width:rowWidth, height: rowHeight))
    let totalPrice = RowView(frame: CGRect(x: 0, y: 0, width:rowWidth, height: rowHeight), rowType: .type2)
    let yeWuHeZuo = RowView(frame: CGRect(x: 0, y: 0, width:rowWidth, height: rowHeight), rowType: .type1)
    let guangGaoDuiJie = RowView(frame: CGRect(x: 0, y: 0, width:rowWidth, height: rowHeight), rowType: .type1)
    let suCai = RowView(frame: CGRect(x: 0, y: 0, width:rowWidth, height: rowHeight), rowType: .type3)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(kehu)
        self.addSubview(orderNum)
        self.addSubview(createOrderTime)
        self.addSubview(userLocation)
        self.addSubview(sentTime)
        self.addSubview(sentArea)
        self.addSubview(areaType)
        self.addSubview(addShowTime)
        self.addSubview(rate)
        self.addSubview(daysCount)
        self.addSubview(unitPrice)
        self.addSubview(weiKuan)
        self.addSubview(totalPrice)
        self.addSubview(yeWuHeZuo)
        self.addSubview(guangGaoDuiJie)
        self.addSubview(suCai)
        sentArea.button.addTarget(self , action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
        sentArea.button.tag = 1
        
        
        yeWuHeZuo.button.addTarget(self , action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
        yeWuHeZuo.button.tag = 2
        
        
        guangGaoDuiJie.button.addTarget(self , action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
        guangGaoDuiJie.button.tag = 3
        
        
        suCai.button.addTarget(self , action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
        suCai.button.tag = 4
        //        self.addSubview(<#T##view: UIView##UIView#>)
        //        self.addSubview(<#T##view: UIView##UIView#>)
        //        self.addSubview(<#T##view: UIView##UIView#>)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var apiModel = DDOrderDetailApiModel(){
        didSet{
            setContent()
            setUI()
            self.layoutIfNeeded()
        }
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    @objc func buttonClick(sender:UIButton)  {
        self.action?(sender.tag)
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    /*订单状态(-1放弃支付0待支付1待补交2预付款已逾期 3 已完成)为空全部订单*/
    func setContent()  {
        kehu.backgroundColor = .darkGray
        kehu.titleLabel.textColor = .white
        kehu.valueLabel.textColor = .white
        kehu.valueLabel.text = "联系方式 " + (apiModel.data?.order?.mobile ?? "")
        kehu.titleLabel.text = "客户姓名 " + (apiModel.data?.order?.member_name ?? "")
        orderNum.titleLabel.text = "订单号码"
        orderNum.valueLabel.text = apiModel.data?.order?.order_code
        createOrderTime.titleLabel.text = "下单时间"
        createOrderTime.valueLabel.text = apiModel.data?.order?.create_at
        userLocation.titleLabel.text = "用户所在地"
        userLocation.valueLabel.text = apiModel.data?.order?.address
        sentTime.titleLabel.text = "投放时间"
        sentTime.valueLabel.text = (apiModel.data?.order?.start_at ?? "") + "到" + (apiModel.data?.order?.end_at ?? "")
        sentArea.titleLabel.text = "投放地区"
        sentArea.valueLabel.text = apiModel.data?.order?.area_name
        sentArea.button.setTitle("查看投放地区", for: UIControlState.normal)
        sentArea.button.setTitleColor(.orange, for: UIControlState.normal)
        areaType.titleLabel.text = "广告位选择"
        areaType.valueLabel.text = apiModel.data?.order?.advert_name
        addShowTime.titleLabel.text = "广告时长"
        addShowTime.valueLabel.text = apiModel.data?.order?.advert_time
        rate.titleLabel.text = "频次选择"
        rate.valueLabel.text = apiModel.data?.order?.rate
        daysCount.titleLabel.text = "天数"
        daysCount.valueLabel.text = (apiModel.data?.order?.total_day ?? "") + "天"
        daysCount.valueLabel.textColor = .orange
        unitPrice.titleLabel.text = "价格"
        unitPrice.valueLabel.text = (apiModel.data?.order?.unit_price ?? "") + "元/天"
        unitPrice.valueLabel.textColor = .orange
        
        
        if (apiModel.data?.order?.payment_type ) ?? "" == "2"{//定金支付
            let weiKuanTime = ["定金支付 : " ,  "¥" + (apiModel.data?.order?.payment_price ?? "") ]
            dingjin.titleLabel.attributedText = weiKuanTime.setColor(colors: [UIColor.lightGray , .orange ])
            
            let weiKuanNum = ["尾款支付 : " ,"¥" + (apiModel.data?.order?.retainage ?? "") ]
            dingjin.valueLabel.attributedText = weiKuanNum.setColor(colors: [UIColor.lightGray , .orange])
            
            //            weiKuan.valueLabel.text = "待补交尾款 : "
            
        }
        
        
        if (apiModel.data?.order?.payment_status ) ?? "" == "1"{//待补交
            let weiKuanTime = ["补交尾款剩余时间 : " ,  (apiModel.data?.order?.days_remaining ?? "") + "天"]
            weiKuan.titleLabel.attributedText = weiKuanTime.setColor(colors: [UIColor.lightGray , .orange ])
            
            
            let weiKuanNum = ["待补交尾款 : " ,"¥" + (apiModel.data?.order?.retainage ?? "") + "元"]
            weiKuan.valueLabel.attributedText = weiKuanNum.setColor(colors: [UIColor.lightGray , .orange])
            
            //            weiKuan.valueLabel.text = "待补交尾款 : "
            
        }
        //        totalPrice.titleLabel.text = "价格"
        let t = ["总费用:" , ( apiModel.data?.order?.order_price ?? "") + "元"].setColor(colors: [UIColor.lightGray , .orange])
        //        totalPrice.valueLabel.text =  "总费用:" + ( apiModel.data?.order?.order_price ?? "")
        totalPrice.valueLabel.attributedText = t
        yeWuHeZuo.titleLabel.text = "业务合作人"
        yeWuHeZuo.valueLabel.text = (apiModel.data?.order?.salesman_name ?? "") + ":" + (apiModel.data?.order?.salesman_mobile ?? "")
        yeWuHeZuo.button.setTitle("评价", for: UIControlState.normal)
        yeWuHeZuo.button.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        guangGaoDuiJie.titleLabel.text = "广告对接人"
        guangGaoDuiJie.valueLabel.text = ((apiModel.data?.order?.custom_service_name ?? "") + ":" )+(apiModel.data?.order?.custom_service_mobile ?? "")
        guangGaoDuiJie.button.setTitle("评价", for: UIControlState.normal)
        guangGaoDuiJie.button.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        suCai.titleLabel.text = "素材提交"
        suCai.button.setAttributedTitle(UIImage(named:"hinticon")?.imageConvertToAttributedString(), for: .normal)
        
    }
    func setUI()  {
        var maxY : CGFloat = 0
        let bigMargin : CGFloat = 10
        let smallMargin : CGFloat = 2
        kehu.frame.origin.y = 0
        orderNum.frame.origin.y = kehu.frame.maxY + bigMargin
        createOrderTime.frame.origin.y = orderNum.frame.maxY + smallMargin
        userLocation.frame.origin.y = createOrderTime.frame.maxY + smallMargin
        sentTime.frame.origin.y = userLocation.frame.maxY + bigMargin
        sentArea.frame.origin.y = sentTime.frame.maxY + smallMargin
        areaType.frame.origin.y = sentArea.frame.maxY + smallMargin
        addShowTime.frame.origin.y = areaType.frame.maxY + smallMargin
        rate.frame.origin.y = addShowTime.frame.maxY + smallMargin
        daysCount.frame.origin.y = rate.frame.maxY + bigMargin
        unitPrice.frame.origin.y = daysCount.frame.maxY + smallMargin
        maxY = unitPrice.frame.maxY
        
        if (apiModel.data?.order?.payment_type ) ?? "" == "2"{//定金支付
            dingjin.isHidden = false
            dingjin.frame.origin.y = maxY + smallMargin
            maxY = dingjin.frame.maxY
            dingjin.setNeedsLayout()
        }else{
            dingjin.isHidden = true
        }
        
        if (apiModel.data?.order?.payment_status ) ?? "" == "1"{
            weiKuan.frame.origin.y = unitPrice.frame.maxY + smallMargin
            maxY = weiKuan.frame.maxY
            weiKuan.isHidden = false
            //            weiKuan.layoutIfNeeded()
            weiKuan.setNeedsLayout()
        }else{
            weiKuan.isHidden = true
        }
        totalPrice.frame.origin.y = maxY + smallMargin
        yeWuHeZuo.frame.origin.y = totalPrice.frame.maxY + bigMargin
        guangGaoDuiJie.frame.origin.y = yeWuHeZuo.frame.maxY + smallMargin
        yeWuHeZuo.setNeedsLayout()
        guangGaoDuiJie.setNeedsLayout()
        suCai.setNeedsLayout()
        sentArea.setNeedsLayout()
        kehu.setNeedsLayout()
        suCai.frame.origin.y = guangGaoDuiJie.frame.maxY + bigMargin
        self.frame.size.height = suCai.frame.maxY
    }
    
}
extension DDSalemanOrderContentView {
    enum RowType : Int  {
        case type1//文字.....文字............//
        case type2//文字.................文字//
        case type3//文字.....文字.........按钮//
    }
    
    
    class RowView: UIView {
        let titleLabel = UILabel()
        let valueLabel = UILabel()
        let button = UIButton()
        var  rowType : RowType = .type1
        convenience init(frame: CGRect , rowType : RowType) {
            self.init(frame: frame)
            self.rowType = rowType
            self.addSubview(titleLabel)
            self.addSubview(valueLabel)
            self.backgroundColor = .white
            if rowType == .type3{self.addSubview(button)}
            titleLabel.textColor = .gray
            valueLabel.textColor = .lightGray
            titleLabel.font = GDFont.systemFont(ofSize: 15)
            valueLabel.font = GDFont.systemFont(ofSize: 14)
            button.titleLabel?.font  = GDFont.systemFont(ofSize: 13)
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            titleLabel.frame = CGRect(x: 10, y: 0, width: 100, height: self.bounds.height)
            switch rowType {
            case .type1:
                valueLabel.frame = CGRect(x: titleLabel.frame.maxX, y: 0, width: self.bounds.width - titleLabel.frame.maxX - 10, height: self.bounds.height)
                valueLabel.textAlignment = .left
            case .type2:
                valueLabel.frame = CGRect(x: titleLabel.frame.maxX, y: 0, width: self.bounds.width - titleLabel.frame.maxX - 10, height: self.bounds.height)
                valueLabel.textAlignment = .right
            case .type3:
                button.titleLabel?.sizeToFit()
                button.sizeToFit()
                mylog(button.titleLabel?.frame)
                button.center = CGPoint(x: self.bounds.width - 10 - button.bounds.width/2, y: self.bounds.height/2)
                valueLabel.frame =  CGRect(x: titleLabel.frame.maxX, y: 0, width: button.frame.minX - titleLabel.frame.maxX - 10, height: self.bounds.height)
                mylog(button.frame)
            }
            
        }
    }
    
    class RowView1: UIView {
        let titleLabel = UILabel()
        let valueLabel = UILabel()
        override init(frame: CGRect ) {
            super.init(frame: frame)
            self.addSubview(titleLabel)
            self.addSubview(valueLabel)
            self.backgroundColor = .white
            titleLabel.textColor = .gray
            valueLabel.textColor = .lightGray
            titleLabel.font = GDFont.systemFont(ofSize: 15)
            valueLabel.font = GDFont.systemFont(ofSize: 14)
            titleLabel.adjustsFontSizeToFitWidth  = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            //            valueLabel.ddSizeToFit(contentInset: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            valueLabel.sizeToFit()
            valueLabel.center = CGPoint(x: self.bounds.width - valueLabel.bounds.width/2 - 10, y: self.bounds.height/2)
            
            titleLabel.frame = CGRect(x: 10, y: 0, width: valueLabel.frame.minX - 10, height: self.bounds.height)
            valueLabel.textAlignment = .right
            
            
        }
    }
    
    
}
