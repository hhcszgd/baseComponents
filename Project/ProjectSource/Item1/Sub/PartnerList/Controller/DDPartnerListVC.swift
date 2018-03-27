//
//  DDPartnerListVC.swift
//  Project
//
//  Created by WY on 2018/1/3.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDPartnerListVC: DDNormalVC , UITextFieldDelegate{
    var naviBarStartShowH : CGFloat =  DDDevice.type == .iphoneX ? 164 : 148
    var naviBarEndShowH : CGFloat = DDDevice.type == .iphoneX ? 100 : 80
    var pageNum : Int  = 1
    var keyword : String?
    var partnerLevel : Int = 0
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    let searchBox = UITextField.init()
    var users  = [DDSubUserModel]()
    var apiModel = DDPartnerListApiModel()
    var levelSelectButton = DDLevelSelectButton()
    var cover  : GDCoverView?
    let noMsgNoticeLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        configNaviBar()
        self.configTableView()
        
        self.view.addSubview(noMsgNoticeLabel)
        noMsgNoticeLabel.frame = CGRect(x: 0, y: self.view.bounds.height/2, width: self.view.bounds.width, height: 44)
        noMsgNoticeLabel.textColor = UIColor.DDSubTitleColor
        self.switchNoMsgStatus(show: false)
        noMsgNoticeLabel.textAlignment = .center
//        self.requestApi( )
        
        
        DDRequestManager.share.partnerPage(keyword:self.keyword , level: nil, page: self.pageNum)?.responseJSON(completionHandler: { (response ) in
            mylog(response.debugDescription)
            switch response.result{
            case .success:
                if let apiModel = DDDecode(DDPartnerListApiModel.self, from: response){
                    
                        self.apiModel = apiModel
                        if apiModel.data.lower != nil && apiModel.data.lower!.count > 0 {
                            self.switchNoMsgStatus(show: false)
                        }else{
                            self.noMsgNoticeLabel.text = "您暂时还没有伙伴..."
                            self.switchNoMsgStatus(show: true)
                        }
                        self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)

                }
                self.tableView.reloadData()
            case .failure: break
//                self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.failure)
                break
            }
            mylog(response.result)
        })
        
    }
    
    func switchNoMsgStatus(show:Bool)  {
        if show && self.apiModel.data.parent == nil {
            self.noMsgNoticeLabel.isHidden = false
        }else{
            self.noMsgNoticeLabel.isHidden = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    func requestApi(requestType : LoadDataType = .initialize )  {
        if requestType == .loadMore {
            pageNum += 1
        }else if requestType == .initialize {
            
            noMsgNoticeLabel.text = "您暂时还没有伙伴..."
            pageNum = 1
        }else{
            pageNum = 1
            
            noMsgNoticeLabel.text = "找不到相关伙伴信息"
        }
        
        DDRequestManager.share.partnerPage(keyword:self.keyword , level: "\(self.partnerLevel)", page: self.pageNum)?.responseJSON(completionHandler: { (response ) in
            mylog(response.debugDescription)
            switch response.result{
            case .success:
                if let apiModel = DDDecode(DDPartnerListApiModel.self, from: response){
                    if requestType == .loadMore {
                        if let moreData =  apiModel.data.lower , moreData.count > 0{
                            self.apiModel.data.lower?.append(contentsOf: moreData)
                            self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)
                            self.switchNoMsgStatus(show: false)
                        }else{
                            self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.nomore)
                        }
                    }else{
                        self.apiModel.data.lower = apiModel.data.lower
                        self.apiModel.data.parent = apiModel.data.parent
//                        self.apiModel = apiModel
                        if apiModel.data.lower != nil && apiModel.data.lower!.count > 0 {
                            self.switchNoMsgStatus(show: false)
                        }else{
                            self.switchNoMsgStatus(show: true)
                        }
                        self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)
                    }
                    
                }
                self.tableView.reloadData()
            case .failure:
                self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.failure)
            }
            mylog(response.result)
        })
    }
    func configTableView() {
        let searchContaier = self.configTableHeaderView()
        
        
        tableView.frame = CGRect(x:0 , y : searchContaier.frame.maxY , width : self.view.bounds.width , height : self.view.bounds.height - searchContaier.frame.maxY )
        self.view.addSubview(tableView)
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        tableView.gdLoadControl = GDLoadControl.init(target: self , selector: #selector(loadMore))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
//        tableView.tableHeaderView = self.configTableHeaderView()
    }
    func configNaviBar() {
        self.title = "伙伴列表"
    }

  
    //UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.keyword = self.searchBox.text ?? ""
        self.requestApi(requestType: LoadDataType.reload)
        self.tableView.reloadData()
        self.searchBox.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == 0 && textField.text?.count == 1 {
            self.keyword  = nil
            self.requestApi(requestType: LoadDataType.reload)
        }
//        else{
//            self.tableView.reloadData()
//        }
        return true
    }
    
    
    
    @objc func loadMore() {
        requestApi(requestType: LoadDataType.loadMore)
    }
    @objc func performRefresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.pageNum = 0
            
        }
    }
    
    func configTableHeaderView() -> UIView{
        let tableHeader = UIView(frame: CGRect(x:0 , y : DDNavigationBarHeight , width : self.view.bounds.width , height : 66 * SCALE))
        self.view.addSubview(tableHeader)
        let searchBoxEdgeInset = UIEdgeInsetsMake(15 * SCALE, 10, 15 * SCALE, 10)
        searchBox.returnKeyType = .search
        searchBox.delegate =  self //UITextFieldDelegate
        tableHeader.addSubview(searchBox)
        tableHeader.addSubview(levelSelectButton)
        levelSelectButton.addTarget(self , action: #selector(levelSelectBtnClick(sender:)), for: UIControlEvents.touchUpInside)
        levelSelectButton.frame = CGRect(x: searchBoxEdgeInset.left, y: searchBoxEdgeInset.top, width: 88, height: tableHeader.bounds.height - searchBoxEdgeInset.top - searchBoxEdgeInset.bottom)
        searchBox.frame = CGRect(x: levelSelectButton.frame.maxX + 10, y: searchBoxEdgeInset.top, width: UIScreen.main.bounds.width - searchBoxEdgeInset.left - searchBoxEdgeInset.right - levelSelectButton.frame.width - 10, height: tableHeader.bounds.height - searchBoxEdgeInset.top - searchBoxEdgeInset.bottom)
        
        tableHeader.backgroundColor = UIColor.colorWithHexStringSwift("#eeeeee")
        searchBox.backgroundColor = UIColor.white
        searchBox.borderStyle = UITextBorderStyle.roundedRect
        let rightView = UIButton(frame: CGRect(x: -10, y: 0, width: 20, height: 20))
        rightView.setImage(UIImage(named: "search"), for: UIControlState.normal)
        rightView.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        searchBox.rightView = rightView
        searchBox.rightViewMode = .always
        searchBox.placeholder = "请输入伙伴姓名"
        return tableHeader
    }
}

protocol DDLevelChooseDelegate : NSObjectProtocol {
    func didSelectRowAt(indexPath : IndexPath)
}

extension DDPartnerListVC : DDLevelChooseDelegate {
    class DDLevelContainer: UIView ,UITableViewDelegate , UITableViewDataSource{
        var levels : [DDLevelModel]? = [DDLevelModel](){
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
        
        weak var delegate : DDLevelChooseDelegate?
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            mylog(indexPath)
            self.delegate?.didSelectRowAt(indexPath: indexPath)
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.levels?.count ?? 0
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 44
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DDLevelCell") as? DDLevelCell{
                let model =     self.levels?[indexPath.row]
                cell.model = model
                if let levelKey = model?.key , levelKey == self.currentSelectLevel{
                    cell.textLabel?.textColor = UIColor.orange
                }else{cell.textLabel?.textColor = UIColor.DDTitleColor}
                return cell
            }else{
                let cell = DDLevelCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDLevelCell")
                let model =     self.levels?[indexPath.row]
                cell.model = model
                if let levelKey = model?.key , levelKey == self.currentSelectLevel{
                    cell.textLabel?.textColor = UIColor.orange
                }else{cell.textLabel?.textColor = UIColor.DDTitleColor}
                return cell
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            self.tableView.frame = self.bounds
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    class DDLevelCell: UITableViewCell {
        var model : DDLevelModel? = DDLevelModel(){
            didSet{
                self.textLabel?.text = model?.value
            }
        }
        
    }
    
    @objc func levelSelectBtnClick(sender:DDLevelSelectButton) {
        sender.isSelected = !sender.isSelected
        let frame = self.searchBox.superview!.convert(self.searchBox.frame, to: self.view)
        
//        mylog(frame )
        if sender.isSelected {
            if self.cover != nil {
                conerClick(sender: self.cover!)
                return
            }
            
            cover = GDCoverView.init(superView: self.view)
            cover?.frame = CGRect(x: 0.0 , y: frame.maxY, width: self.view.bounds.width, height: self.view.bounds.height - frame.maxY)
            cover?.addTarget(self , action: #selector(conerClick(sender:)) , for: UIControlEvents.touchUpInside)
            let levelContainer = DDLevelContainer.init(frame: CGRect(x: 0, y: -450, width: self.view.bounds.width, height: 300))
            levelContainer.delegate = self
            levelContainer.currentSelectLevel = self.partnerLevel
            levelContainer.levels = self.apiModel.data.level
            self.cover?.addSubview(levelContainer)
            
            let animateFrame = self.searchBox.superview!.convert(self.searchBox.frame, to: self.cover)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                levelContainer.frame = CGRect(x: 0 , y: animateFrame.maxY, width: self.view.bounds.width, height: 300)
            }, completion: { (bool ) in
                
            })
        }else{
            self.cover?.remove()
            self.cover = nil
            levelSelectButton.isSelected = false
        }
    }
    func didSelectRowAt(indexPath : IndexPath){
        mylog(indexPath)
        if let chooseLevel = self.apiModel.data.level?[indexPath.row]{
            self.partnerLevel = chooseLevel.key
            self.requestApi(requestType: .reload)
        }
        self.cover?.remove()
        self.cover = nil
        levelSelectButton.isSelected = false
    }
    @objc func corverItemClick(sender:UIButton){
        mylog(sender.tag)
        //to do something
        switch sender.tag {
        case 0:
            break
        case 1:
            self.pushVC(vcIdentifier: "DDPartnerListVC")
//            self.navigationController?.pushViewController(DDPartnerListVC(), animated: true )
        case 2:
            
            break
        default:
            break
        }
        self.cover?.remove()
        self.cover = nil
        
        levelSelectButton.isSelected = false
    }
    
    @objc func conerClick(sender : GDCoverView)  {
        self.levelSelectButton.isSelected = false
        for (index ,view) in sender.subviews.enumerated(){
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                view.frame = CGRect(x: 0 , y: -450, width: self.view.bounds.width , height: 300)
            }, completion: { (bool ) in
                sender.remove()
                self.cover = nil
            })
        }
    }
}
extension DDPartnerListVC : UITableViewDelegate , UITableViewDataSource {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        self.searchBox.resignFirstResponder()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var memberID = ""
        if self.apiModel.data.parent != nil && (self.apiModel.data.lower?.count ?? 0) > 0  {
            if indexPath.section == 0 {
                let upPartner = apiModel.data.parent!
                memberID =  upPartner.id
            }else{
                let downPartner = apiModel.data.lower![indexPath.row]
                memberID =  downPartner.lower_member_id
            }
        }else if self.apiModel.data.parent != nil{
            let upPartner = apiModel.data.parent!
            memberID =  upPartner.id
        } else if (self.apiModel.data.lower?.count ?? 0) > 0  {
            let downPartner = apiModel.data.lower![indexPath.row]
            memberID =  downPartner.lower_member_id
        }
        let partnerDetailVC = DDPartnerDetailVC(memberID: memberID)
        self.navigationController?.pushViewController(partnerDetailVC, animated: true )
        mylog(indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.apiModel.data.parent != nil && (self.apiModel.data.lower?.count ?? 0) > 0  {
            return 2
        }else if self.apiModel.data.parent != nil || (self.apiModel.data.lower?.count ?? 0) > 0  {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.apiModel.data.parent != nil && (self.apiModel.data.lower?.count ?? 0) > 0  {
            return section == 0 ? 1 : (apiModel.data.lower?.count ?? 0)
        }else if self.apiModel.data.parent != nil || (self.apiModel.data.lower?.count ?? 0) > 0  {
            return self.apiModel.data.parent != nil ? 1 : (self.apiModel.data.lower?.count ?? 0)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tempCell : DDPartnerListCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDPartnerListCell") as? DDPartnerListCell{
            tempCell = cell
        }else{
            let cell = DDPartnerListCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDPartnerListCell")
            tempCell = cell
        }
        
        if self.apiModel.data.parent != nil && (self.apiModel.data.lower?.count ?? 0) > 0  {
            if indexPath.section == 0 {
                tempCell.parentUser = apiModel.data.parent!
            }else{
                tempCell.subUser = apiModel.data.lower![indexPath.row]
                tempCell.keyWorld = self.searchBox.text
            }
        }else if self.apiModel.data.parent != nil{
            tempCell.parentUser = apiModel.data.parent!
        } else if (self.apiModel.data.lower?.count ?? 0) > 0  {
            tempCell.subUser = apiModel.data.lower![indexPath.row]
            tempCell.keyWorld = self.searchBox.text
        }

        return tempCell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header : DDParnerSectionHeader!
        if let headerView  = tableView.dequeueReusableHeaderFooterView(withIdentifier: "UITableViewHeaderFooterView") as?  DDParnerSectionHeader{
            header = headerView
        }else{
            header = DDParnerSectionHeader.init(reuseIdentifier: "DDParnerSectionHeader")
        }
        
        if self.apiModel.data.parent != nil && (self.apiModel.data.lower?.count ?? 0) > 0  {
            if section == 0 {
                
                 header.button.setAttributedTitle(" 上级伙伴".setColor(color: UIColor.colorWithHexStringSwift("#23a9b8")), for: UIControlState.normal)
                header.button.setImage(UIImage(named:"superioricon"), for: UIControlState.normal)
//                header.backgroundColor = .white
            }else{
                
                 header.button.setAttributedTitle(" 下级伙伴".setColor(color: UIColor.colorWithHexStringSwift("#ea9061")), for: UIControlState.normal)
                header.button.setImage(UIImage(named:"lowerlevelicon"), for: UIControlState.normal)
//                header.backgroundColor = .white
            }
        }else if self.apiModel.data.parent != nil{
            header.button.setAttributedTitle(" 上级伙伴".setColor(color: UIColor.colorWithHexStringSwift("#23a9b8")), for: UIControlState.normal)
            header.button.setImage(UIImage(named:"superioricon"), for: UIControlState.normal)
//            header.backgroundColor = .white
        } else if (self.apiModel.data.lower?.count ?? 0) > 0  {
            header.button.setAttributedTitle(" 下级伙伴".setColor(color: UIColor.colorWithHexStringSwift("#ea9061")), for: UIControlState.normal)
            header.button.setImage(UIImage(named:"lowerlevelicon"), for: UIControlState.normal)
//            header.backgroundColor = .white
        }
        header.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width , height: 44)
        return header
    }

}

import SDWebImage
class DDLevelSelectButton: UIControl {
    let arrow1 = UIImageView()
    let arrow2 = UIImageView()
    let label = UILabel()
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
        label.text = "伙伴等级"
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


class DDParnerSectionHeader: UITableViewHeaderFooterView {
    let button = UIButton()
    let topLine = UIView()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(topLine)
        self.contentView.addSubview(button)
        topLine.backgroundColor = UIColor.colorWithHexStringSwift("#eeeeee")
        self.contentView.backgroundColor = .white
        button.setTitleColor(UIColor.DDTitleColor, for: UIControlState.normal)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        topLine.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 3)
        button.frame = self.bounds
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class DDPartnerListCell : UITableViewCell {
    var parentUser : DDParentUserModel?{
        didSet{
            if let imageURL = parentUser?.avatar {
                let url = URL(string: imageURL)
                icon.sd_setImage(with: url, placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed]) { (image , error , imageCacheType, url) in }
            }
            title.text = parentUser?.name
            subTitle.text = "上级伙伴"
        }
    }
    var subUser : DDSubUserModel?{
        didSet{
            if let imageURL = subUser?.lower_member_avatar {
                let url = URL(string: imageURL)
                icon.sd_setImage(with: url, placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed]) { (image , error , imageCacheType, url) in }
            }
            title.text = subUser?.lower_member_name
            if let levelUnwrap = subUser?.level{
                switch levelUnwrap {
                case "6":
                    subTitle.text = "六级伙伴"

                case "2":
                    subTitle.text = "二级伙伴"

                case "3":
                    subTitle.text = "三级伙伴"

                case "4":
                    subTitle.text = "四级伙伴"

                case "5":
                    subTitle.text = "五级伙伴"

                    
                default:
                    break
                }
            }
            
        }
    }
    
    
    var keyWorld : String? = ""{
        didSet{
            
            if let title = subUser?.lower_member_name, let keyWorkUnwrap = keyWorld{
                let attributeStr = title.setColor(color: UIColor.red, keyWord: keyWorkUnwrap)
                self.title.attributedText = attributeStr
            }
            
        }
    }
    
    let icon  = UIImageView()
    let title = UILabel()
    let subTitle = UILabel()

    let bottomLine = UIView()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(icon)
        self.contentView.addSubview(title)
        self.contentView.addSubview(subTitle)
        title.textColor = UIColor.DDTitleColor
        title.font = GDFont.systemFont(ofSize: 17)
        bottomLine.backgroundColor = UIColor.DDLightGray
        icon.image = QRCodeScannerVC.creatQRCode(string: "this qrCode is created by wyf", imageToInsert: UIImage(named: "groupchatbackground"))
        title.text = "姓名"
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 10
        let bottomLineH : CGFloat = 2
        let iconWH = self.bounds.height - margin * 2 - bottomLineH
        icon.frame = CGRect(x: margin , y: margin , width:iconWH, height:iconWH )
        title.ddSizeToFit()
        subTitle.ddSizeToFit()
        title.frame = CGRect(x: icon.frame.maxX + margin, y: icon.frame.minY, width: self.frame.width - margin - icon.frame.maxX - margin , height: icon.frame.height/2)
        subTitle.frame =  CGRect(x: icon.frame.maxX + margin, y: icon.frame.midY, width: self.frame.width - margin - icon.frame.maxX - margin , height: icon.frame.height/2)
        bottomLine.frame = CGRect(x: 0, y: self.bounds.height - bottomLineH, width: self.bounds.width, height: bottomLineH)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DDSubUserModel: DDActionModel , Codable {
    var parent_member_id : String = ""
    var parent_member_name:String? = ""
    var lower_member_id:String = ""
    var lower_member_name:String? = ""
    var level:String = ""
    var lower_member_avatar : String? = "http://ozstzd6mp.bkt.gdipper.com/e8afacc4aff1b456d58a25af234096d7.jpg"
}
class DDParentUserModel: DDActionModel ,Codable{
    var name:String = ""
    var avatar:String?
    var id : String = ""
}
