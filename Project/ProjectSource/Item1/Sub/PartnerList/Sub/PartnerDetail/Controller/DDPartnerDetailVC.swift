//
//  DDPartnerDetailVC.swift
//  Project
//
//  Created by WY on 2018/1/12.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDPartnerDetailVC: DDNormalVC {
    var memberID = ""
    convenience init(memberID : String ){
        self.init()
        self.memberID = memberID
    }
    var naviBarStartShowH : CGFloat =  DDDevice.type == .iphoneX ? 164 : 148
    var naviBarEndShowH : CGFloat = DDDevice.type == .iphoneX ? 100 : 80
    var pageNum : Int  = 1
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    let tableHeader = TableHeaderView.init(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height:  SCREENWIDTH * 0.6))
    var apiModel = DDPartnerDetailApiModel(){
        didSet{
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configNaviBar()
        self.configTableView()
    }
    
    func configTableView() {
        tableView.frame = CGRect(x:0 , y : DDNavigationBarHeight , width : self.view.bounds.width , height : self.view.bounds.height - DDNavigationBarHeight - DDTabBarHeight)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableHeaderView = tableHeader
        tableView.gdLoadControl = GDLoadControl.init(target: self , selector: #selector(loadMore))
        DDRequestManager.share.partnerDetail(targetMemberID: memberID)?.responseJSON(completionHandler: { (response ) in
            mylog(response.debugDescription)
            if let apiModel = DDDecode(DDPartnerDetailApiModel.self , from: response){
                self.apiModel = apiModel
                self.tableHeader.memberInfoModel = apiModel.data.member
                self.tableHeader.upLevelModel = apiModel.data.parent_member
                if apiModel.data.parent_member != nil {
                    self.tableHeader.frame =  CGRect(x: 0, y: 0, width: SCREENWIDTH, height:  SCREENWIDTH * 0.85)
                    
                }else{
                    
                    self.tableHeader.frame =  CGRect(x: 0, y: 0, width: SCREENWIDTH, height:  SCREENWIDTH * 0.6)
                }
                self.tableView.reloadData()
            }
            
        })
        
    }
    
    func requestApi(requestType : DDLoadType) {
        if requestType == .loadMore {
            pageNum += 1
        }else if requestType == .initialize {
            pageNum = 1
        }else if requestType == .refresh{
            pageNum = 1
        }
        
        DDRequestManager.share.partnerDetail(targetMemberID: memberID , page : pageNum)?.responseJSON(completionHandler: { (response ) in
            mylog(response.debugDescription)
//            if let apiModel = DDDecode(DDPartnerDetailApiModel.self , from: response){
//                self.apiModel = apiModel
//                self.tableHeader.memberInfoModel = apiModel.data.member
//                self.tableHeader.upLevelModel = apiModel.data.parent_member
//                if apiModel.data.parent_member != nil {
//                    self.tableHeader.frame =  CGRect(x: 0, y: 0, width: SCREENWIDTH, height:  SCREENWIDTH * 0.85)
//
//                }else{
//
//                    self.tableHeader.frame =  CGRect(x: 0, y: 0, width: SCREENWIDTH, height:  SCREENWIDTH * 0.6)
//                }
//                self.tableView.reloadData()
//            }
            /////
            
            switch response.result{
            case .success:
                if let apiModel = DDDecode(DDPartnerDetailApiModel.self, from: response){
                    if requestType == .loadMore {
                        if let moreData =  apiModel.data.shop , moreData.count > 0{
                          self.apiModel.data.shop?.append(contentsOf: moreData)
                            self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)
                        }else{
                            self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.nomore)
                        }
                    }else{
                        self.apiModel = apiModel
                        self.tableHeader.memberInfoModel = apiModel.data.member
                        self.tableHeader.upLevelModel = apiModel.data.parent_member
                        if apiModel.data.parent_member != nil {
                            self.tableHeader.frame =  CGRect(x: 0, y: 0, width: SCREENWIDTH, height:  SCREENWIDTH * 0.85)
                        }else{
                            
                            self.tableHeader.frame =  CGRect(x: 0, y: 0, width: SCREENWIDTH, height:  SCREENWIDTH * 0.6)
                        }
                        self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)
                    }
                }
                self.tableView.reloadData()
            case .failure:
                self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.failure)
            }
            
        })
    }
    
    func configNaviBar() {
        self.title = "伙伴"
//        self.navigationController?.title = nil
    }
    //textfieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        return false
    }
    @objc func loadMore() {
        requestApi(requestType: .loadMore)
    }
    @objc func performRefresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.pageNum = 0
        }
    }

}

extension DDPartnerDetailVC  {
    class  TableHeaderView: UIView{
        var memberInfoModel : DDPartnerDetailMemberModel?{
            didSet{
                guard let modelUnwrap = memberInfoModel else {
                    mylog(memberInfoModel)
                    return
                }
                if let imageURL =  URL(string: modelUnwrap.avatar ?? "")  {
                    imageView.sd_setImage(with: imageURL, placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed])
                }
                imageView.backgroundColor = .blue
                mylog(imageView)
                name.text = modelUnwrap.name
                partnerLevel.text = modelUnwrap.level
                
                let levelUnwrap = modelUnwrap.level
                switch levelUnwrap {
                case "1":
                    partnerLevel.text = "上级伙伴"
                case "2":
                    partnerLevel.text = "二级伙伴"
                case "3":
                    partnerLevel.text = "三级伙伴"
                case "4":
                    partnerLevel.text = "四级伙伴"
                case "5":
                    partnerLevel.text = "五级伙伴"
                case "6":
                    partnerLevel.text = "六级伙伴"
                default:
                    break
                }
                
                if modelUnwrap.number?.count ?? 0 > 0 {
                    workerNum.isHidden = false
                }else{
                    workerNum.isHidden = true
                }
                workerNum.text = "工号    " + (modelUnwrap.number ?? "")
                phoneNum.text = "电话     " + modelUnwrap.mobile
                backImageView.image = UIImage(named:"businesscardbackground")
            }
        }
        
        var upLevelModel : DDPartnerDetailUpMemberModel? {
            didSet{
                guard let modelUnwrap = upLevelModel  else {
                    self.bottomContainer.alpha = 0
                    self.bottomContainer.frame = CGRect.zero;
                    return;
                }
                if let imageURL =  URL(string: modelUnwrap.avatar ?? "")  {
                    upLevelIcon.sd_setImage(with: imageURL, placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed])
                }
                self.upLevelName.text = modelUnwrap.name
            }
        }
        
        let topContainer = UIView()
        let backImageView = UIImageView()
        let imageView = UIImageView()
        let name = UILabel()
        let partnerLevel = UILabel()
        let workerNum = UILabel()
        let phoneNum = UILabel()
        
        let bottomContainer = UIView()
        let upLevelTitle = UILabel()
        let upLevelIcon = UIImageView()
        let upLevelName = UILabel()
        let bottomLine = UIView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.addSubview(topContainer)
            self.topContainer.addSubview(backImageView)
            self.topContainer.addSubview(imageView)
            self.topContainer.addSubview(name)
            self.topContainer.addSubview(partnerLevel)
            self.topContainer.addSubview(workerNum)
            self.topContainer.addSubview(phoneNum)
            
            self.addSubview(bottomContainer)
            self.bottomContainer.addSubview(upLevelTitle)
            upLevelTitle.text = "他的上级伙伴"
            self.bottomContainer.addSubview(upLevelIcon)
            self.bottomContainer.addSubview(upLevelName)
            self.bottomContainer.addSubview(bottomLine)
            
//            backImageView.backgroundColor = .orange
            name.textAlignment = .center
            partnerLevel.textAlignment = .center
            workerNum.textAlignment = .center
            phoneNum.textAlignment = .center
            name.textColor = .white
            partnerLevel.textColor = .white
            workerNum.textColor = .white
            phoneNum.textColor = .white
            
            bottomLine.backgroundColor = UIColor.DDLightGray
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            topContainer.frame = CGRect(x: 0 , y: 0 , width: self.bounds.width, height: SCREENWIDTH * 0.6)
            let top_bottomMargin : CGFloat = 20
            let imageWH : CGFloat = self.topContainer.bounds.height * 0.3
            let virticalMargin : CGFloat = 2
            let labelH = (self.topContainer.bounds.height - top_bottomMargin * 2 - virticalMargin * 4 - imageWH) / 4
            let imageY = top_bottomMargin
            let imageX = self.topContainer.bounds.width/2 - imageWH/2
            imageView.frame = CGRect(x: imageX, y: imageY, width: imageWH, height: imageWH)
            imageView.layer.cornerRadius = imageWH/2
            imageView.layer.masksToBounds = true
            name.frame = CGRect(x: 0, y: imageView.frame.maxY + virticalMargin, width: self.topContainer.bounds.width, height: labelH)
            partnerLevel.frame = CGRect(x: 0, y: name.frame.maxY + virticalMargin, width: self.topContainer.bounds.width, height: labelH)
            workerNum.frame = CGRect(x: 0, y: partnerLevel.frame.maxY + virticalMargin, width: self.topContainer.bounds.width, height: labelH)
            phoneNum.frame = CGRect(x: 0, y: workerNum.frame.maxY + virticalMargin, width: self.topContainer.bounds.width, height: labelH)
            backImageView.frame = self.topContainer.bounds
            backImageView.image = UIImage(named:"businesscardbackground")
            self.bottomContainer.frame = CGRect(x: 0, y: self.topContainer.frame.maxY, width: self.bounds.width, height: self.bounds.height - self.topContainer.frame.maxY)
            let X : CGFloat = 20
            let titleH : CGFloat = 30
            let iconToTop : CGFloat = 10
            let iconToBottom : CGFloat = 10
            let bottomLineH : CGFloat = 2
            let iconWH = self.bottomContainer.bounds.height - titleH - iconToTop - iconToBottom - bottomLineH
            let nameH : CGFloat = 20
            upLevelTitle.frame = CGRect(x: X, y: 0, width: self.bottomContainer.bounds.width - X , height: titleH)
            upLevelIcon.frame =  CGRect(x: X, y: upLevelTitle.frame.maxY + iconToTop, width: iconWH , height: iconWH)
            upLevelName.frame =  CGRect(x: upLevelIcon.frame.maxX + 12, y: upLevelIcon.frame.midY - nameH/2, width: self.bottomContainer.bounds.width - upLevelIcon.frame.maxX - 30 , height: nameH)
            bottomLine.frame = CGRect(x: 0, y: self.bottomContainer.bounds.height - bottomLineH, width: self.bottomContainer.bounds.width, height: bottomLineH)
            
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
    class DDPartnerSectionHeader: UITableViewHeaderFooterView {
        let sectionTitle = UILabel()
        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(sectionTitle)
            sectionTitle.text = "业务信息"
           
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let X : CGFloat = 20
            sectionTitle.frame = CGRect(x: X, y: 0, width: self.bounds.width - X , height: self.bounds.height)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}


extension DDPartnerDetailVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if let count = self.apiModel.data.shop?.count , count > 0{
            return 1
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.apiModel.data.shop?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = DDPartnerSectionHeader.init(reuseIdentifier: "DDPartnerSectionHeader")
        sectionHeader.contentView.backgroundColor = .white
        sectionHeader.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40)
        let temp = DDPartnerDetailUpMemberModel.init()
        temp.name = "this is name"
        temp.avatar = DDTestImageUrl?.absoluteString
//        sectionHeader.model = self.apiModel.data.parent_member
//        sectionHeader.model = temp
        return sectionHeader
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.apiModel.data.shop?[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDMessageCell") as? DDMessageCell{
            cell.model = model
            return cell
        }else{
            let cell = DDMessageCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDMessageCell")
            cell.model = model
            return cell
        }
    }
}
import SDWebImage
extension DDPartnerDetailVC{
    class DDMessageCell : UITableViewCell {
        let icon  = UIImageView()
        let shopName = UILabel()
        
        let address = UILabel()
        let screenCount = UILabel()
        let time = UILabel()
        let status = UILabel()
        let peopleName = UILabel()
        
        var model : DDShopReviewModel? {
            didSet{
                if let imageURL =  URL(string: model?.shop_image ?? "")  {
                    icon.sd_setImage(with: imageURL, placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed])
                }
                shopName.text = model?.name
                address.text = model?.area_name
                let screenCountStr = [ (model?.screen_number ?? "") , " 台屏幕"].setColor(colors: [UIColor.colorWithHexStringSwift("#ea9061"),UIColor.DDSubTitleColor])
                screenCount.attributedText = screenCountStr
                time.text = model?.create_at
                ///0、待审核 1、待安装 2、被驳回 3、已安装 //  1、待审核 2、被驳回 3、待安装 4、已安装)
                
                status.textColor = UIColor.colorWithHexStringSwift("#ea9061")
                switch (model?.status ?? "") {
//                case "0":
//                 status.text = "待审核"
//                case "1":
//                    status.text = "待安装"
//                case "2":
//                 status.text = "被驳回"
//                case "3":
//                    status.text = "已安装"
//                    status.textColor = UIColor.colorWithHexStringSwift("#4ca714")
                case "0":
                    status.text = "待审核"
                case "1":
                    status.text = "待安装"
                case "2":
                    status.text = "被驳回"
                case "3" , "4":
                    status.text = "待安装"
                case "5":
                    status.text = "安装完成"
                    status.textColor = UIColor.colorWithHexStringSwift("#4ca714")
                default:
                    break
                }
                peopleName.text = "负责人 : " + (model?.member_name ?? "")
                layoutIfNeeded()
            }
        }
        let bottomLine = UIView()
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.selectionStyle = .none
            self.contentView.addSubview(icon)
            self.contentView.addSubview(shopName)
            self.contentView.addSubview(address)
            self.contentView.addSubview(screenCount)
            self.contentView.addSubview(time)
            self.contentView.addSubview(status)
            self.contentView.addSubview(peopleName)
            
            
            self.contentView.addSubview(bottomLine)
            shopName.font = GDFont.systemFont(ofSize: 16)
            address.font = GDFont.systemFont(ofSize: 15)
            screenCount.font = GDFont.systemFont(ofSize: 15)
            time.font = GDFont.systemFont(ofSize: 14)
            status.font = GDFont.systemFont(ofSize: 18)
            peopleName.font = GDFont.systemFont(ofSize: 13)
            
            shopName.textColor = UIColor.DDTitleColor
            address.textColor = UIColor.colorWithHexStringSwift("#808080")
            screenCount.textColor = UIColor.colorWithHexStringSwift("#333333")
            time.textColor = UIColor.colorWithHexStringSwift("#999999")
            peopleName.textColor = UIColor.colorWithHexStringSwift("#808080")
            
            bottomLine.backgroundColor = UIColor.DDLightGray
            //        icon.image = UIImage(named: "groupchatbackground")
//            icon.image = QRCodeScannerVC.creatQRCode(string: "this qrCode is created by wyf", imageToInsert: UIImage(named: "groupchatbackground"))
            shopName.text = "姓名"
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let margin : CGFloat = 10
            let bottomLineH : CGFloat = 2
            let iconWH = self.bounds.height - margin * 2 - bottomLineH
            let labelH = iconWH/3
            let superW = self.bounds.width
            let superH = self.bounds.height
            icon.frame = CGRect(x: margin * 2 , y: margin , width:iconWH, height:iconWH )
            time.sizeToFit()
            time.frame = CGRect(x: superW - time.bounds.width - margin  , y: icon.frame.minY, width: time.bounds.width, height: labelH)
            shopName.frame = CGRect(x: icon.frame.maxX + margin   , y: icon.frame.minY, width: time.frame.minX - icon.frame.maxX - margin  * 2, height: labelH)
            
            status.sizeToFit()
            status.frame = CGRect(x: superW - status.bounds.width - margin  , y: icon.frame.midY - labelH/2, width: status.bounds.width, height: labelH)
            address.frame = CGRect(x: icon.frame.maxX + margin   , y: icon.frame.midY - labelH/2, width: status.frame.minX - icon.frame.maxX - margin  * 2, height: labelH)
            
            peopleName.sizeToFit()
            peopleName.frame = CGRect(x: superW - peopleName.bounds.width - margin  , y: icon.frame.maxY - labelH, width: peopleName.bounds.width, height: labelH)
            screenCount.frame = CGRect(x: icon.frame.maxX + margin   , y: icon.frame.maxY - labelH, width: peopleName.frame.minX - margin  * 2, height: labelH)
            
            
            bottomLine.frame = CGRect(x: 0, y: self.bounds.height - bottomLineH, width: self.bounds.width, height: bottomLineH)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}


