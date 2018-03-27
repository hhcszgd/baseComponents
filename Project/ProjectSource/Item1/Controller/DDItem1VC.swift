//
//  DDItem1VC.swift
//  ZDLao
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit
import CryptoSwift
import CoreLocation
class DDItem1VC: DDNormalVC , UITextFieldDelegate{
    var collection : UICollectionView!
    let sectionHeaderH : CGFloat = 280 * SCALE
    var apiModel = DDHomeApiModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        if #available(iOS 11.0, *) {
            self.collection.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        performRequestApi()
        
        self.title = "工作"
//        self.navigationController?.title = nil
        let name = NSNotification.Name.init("ChangeSquenceSuccess")
        NotificationCenter.default.addObserver(self , selector: #selector(changeSquenceSuccess), name: name , object: nil )
        
        
        
    }
    
    
    
    
    
    @objc func changeSquenceSuccess() {
        performRequestApi()
    }
    func performRequestApi()  {
        DDRequestManager.share.homePage( true)?.responseJSON(completionHandler: { (response ) in
            mylog(response.result)
            if let apiModel = DDDecode(DDHomeApiModel.self , from: response){
                self.apiModel = apiModel
                self.collection.reloadData()
                
            }
//            let jsonDecoder = JSONDecoder.init()
//            do{
//                let apiModel = try jsonDecoder.decode(DDHomeApiModel.self , from: response.data ?? Data())
//                mylog(apiModel)
//            }catch {
//                mylog(error )
//            }
        })
    }
    
    func configCollectionView()  {
        let toBorderMargin :CGFloat  = 10
        let itemMargin  : CGFloat = 15
        let itemCountOneRow = 4
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = itemMargin
        flowLayout.minimumInteritemSpacing = itemMargin
        flowLayout.sectionInset = UIEdgeInsetsMake(0, toBorderMargin, 0, toBorderMargin)
        let itemW = (self.view.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * CGFloat(itemCountOneRow)) / CGFloat(itemCountOneRow)
        let itemH = itemW * 1.33
        flowLayout.itemSize = CGSize(width: itemW, height: itemH)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        flowLayout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: sectionHeaderH)
        self.collection = UICollectionView.init(frame: CGRect(x: 0, y:  DDNavigationBarHeight , width: self.view.bounds.width, height: self.view.bounds.height - DDNavigationBarHeight - DDTabBarHeight), collectionViewLayout: flowLayout)
        self.view.addSubview(collection)
        collection.register(HomeItem.self , forCellWithReuseIdentifier: "HomeItem")
        collection.register(HomeSectionFooter.self , forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "HomeSectionFooter")
        collection.register(HomeSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HomeSectionHeader")
        collection.delegate = self
        collection.dataSource = self
        collection.bounces = true
        collection.alwaysBounceVertical = true
        collection.showsVerticalScrollIndicator = false 
        collection.backgroundColor = .white
    }

}



extension DDItem1VC : UICollectionViewDelegate ,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mylog(indexPath)
        var targetVC : UIViewController!
        let model = apiModel.data.function[indexPath.item]
        switch model.target {
        case "guanggao":
            self.pushVC(vcIdentifier: "DDSalemanOrderListVC")
            return
        case "anzhuang":
            self.pushVC(vcIdentifier: "InStallVC")
//            let install = InStallVC()
//            targetVC = install
        case "huoban":
            self.pushVC(vcIdentifier: "DDPartnerListVC")
//            let partnerListVC = DDPartnerListVC()
//            targetVC = partnerListVC
        case "chaxun":
            self.pushVC(vcIdentifier: "ChaXunVC")
//            let vc = ChaXunVC()
//            targetVC = vc
        case "tongji":
            self.pushVC(vcIdentifier: "NewAchievementStatisticVC")
//            let achievementStatisticVC = NewAchievementStatisticVC()
//            targetVC = achievementStatisticVC
        case "pingmu":
            self.pushVC(vcIdentifier: "ScreenManagerVC")
//            let screenManager = ScreenManagerVC()
//            targetVC = screenManager
        case "bianji":
            self.pushVC(vcIdentifier: "DDFuncEditVC")
//            let editVC = DDFuncEditVC(collectionViewLayout: UICollectionViewFlowLayout())
//            targetVC = editVC
        case "wap":
            self.pushVC(vcIdentifier: "HomeWebVC" , userInfo : model.link_url)
//            let editVC = HomeWebVC()
//            let tempModel = DDActionModel()
//            tempModel.keyParameter = model.link_url
//            
//            editVC.showModel = tempModel
//            targetVC = editVC
        case "myshop":
            self.pushVC(vcIdentifier: "MyShopVC")
//            let editVC = MyShopVC()
//            targetVC = editVC
        default:
            return
        }
//        self.navigationController?.pushViewController(targetVC, animated: true)
    }
//        func getMessageModels() -> [DDHuDong] {
//        var models = [DDHuDong]()
//        for index  in 0...5 {
//            let model = DDHuDong()
//            model.hd_name = "\(index)\(index)\(index)"
//            model.hd_title = "\(index)\(index)\(index)"
//            model.nikename = "\(index)\(index)\(index)"
//            models.append(model)
//        }
//        return models
//    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        if kind ==  UICollectionElementKindSectionHeader{
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HomeSectionHeader", for: indexPath) as? HomeSectionHeader{
//                header.backgroundColor = UIColor.randomColor()
                header.bannerActionDelegate = self
                header.msgActionDelegate = self
                header.msgModels =       self.apiModel.data.notice
                header.bannerModels =          self.apiModel.data.banner
                header.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: sectionHeaderH)
                return header
                
            }
        }else if kind == UICollectionElementKindSectionFooter  {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "HomeSectionFooter", for: indexPath)
            footer.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 0)
            return footer
        }
        return UICollectionReusableView.init()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apiModel.data.function.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeItem", for: indexPath)
        if let itemUnwrap = item as? HomeItem{
            itemUnwrap.model = self.apiModel.data.function[indexPath.row]
        }
//        item.backgroundColor = UIColor.randomColor()
        return item
    }

}
extension DDItem1VC : BannerAutoScrollViewActionDelegate , DDMsgScrollViewActionDelegate{
    func performMsgAction(indexPath: IndexPath) {
        let msgModel = self.apiModel.data.notice[indexPath.item % self.apiModel.data.notice.count]
        toWebView(messageID: msgModel.id)
        mylog(indexPath)
    }
    @objc func toWebView(messageID:String) {
        self.pushVC(vcIdentifier: "GDBaseWebVC", userInfo: DomainType.wap.rawValue + "message/\(messageID)?type=notice")
//        let model = DDActionModel.init()
//        model.keyParameter = DomainType.wap.rawValue + "message/\(messageID)?type=notice"
//        let web : GDBaseWebVC = GDBaseWebVC()
//        web.showModel = model
//        self.navigationController?.pushViewController(web , animated: true )
    }
    func moreBtnClick() {
        mylog("to message page ")
        rootNaviVC?.selectChildViewControllerIndex(index: 3)
    }
    
    func performBannerAction(indexPath : IndexPath) {
         let model = self.apiModel.data.banner[indexPath.item % self.apiModel.data.banner.count]
        self.pushVC(vcIdentifier: "GDBaseWebVC", userInfo: model.link_url)
//        mylog(indexPath)
//        model.keyParameter = model.link_url
//        let web : GDBaseWebVC = GDBaseWebVC()
//        web.showModel = model
//        self.navigationController?.pushViewController(web , animated: true )
    }
    
    
}
import SDWebImage
class HomeItem : UICollectionViewCell {
    var model : DDHomeFoundation = DDHomeFoundation(){
        didSet{
            if let url  = URL(string:model.image_url) {
                imageView.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
            }else{
                imageView.image = DDPlaceholderImage
            }
            label.text = model.name
        }
    }
    
    
    let imageView = UIImageView()
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView )
        self.contentView.addSubview(label )
        label.text = "exemple"
        label.textAlignment = .center
        label.textColor = UIColor.DDSubTitleColor
        label.font = GDFont.systemFont(ofSize: 13.4)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0 , y : 0 , width : self.bounds.width , height : self.bounds.width)
        label.frame = CGRect(x:0  , y : imageView.frame.maxY , width : self.bounds.width , height : self.bounds.height - self.bounds.width)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class HomeSectionHeader: UICollectionReusableView ,BannerAutoScrollViewActionDelegate , DDMsgScrollViewActionDelegate{
    func performMsgAction(indexPath: IndexPath) {
        self.msgActionDelegate?.performMsgAction(indexPath: indexPath)
    }
    func moreBtnClick() {
        self.msgActionDelegate?.moreBtnClick()
    }
    
    func performBannerAction(indexPath : IndexPath) {
        self.bannerActionDelegate?.performBannerAction(indexPath: indexPath)
    }
    
    var msgModels : [DDHomeMsgModel] = [DDHomeMsgModel](){
        didSet{
            message.models = msgModels
        }
    }
    var bannerModels : [DDHomeBannerModel] = [DDHomeBannerModel](){
        didSet{
            banner.models = bannerModels
        }
    }
    weak var bannerActionDelegate : BannerAutoScrollViewActionDelegate?
    
    weak var msgActionDelegate : DDMsgScrollViewActionDelegate?
    let banner = HomeBannerScrollView.init(frame: CGRect.zero)
    let message : HomeMessageScrollView = HomeMessageScrollView.init(frame: CGRect.zero)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(message)
        self.addSubview(banner)
        banner.delegate = self
        message.delegate = self
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let toBorder : CGFloat = 0
        message.frame = CGRect(x:toBorder , y : self.bounds.height - 44 , width : self.bounds.width - toBorder * 2 , height : 44 )
        banner.frame = CGRect(x:0 , y : 0 , width : self.bounds.width  , height : self.bounds.height - 44 )
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class HomeBannerScrollView : UIView , BannerAutoScrollViewActionDelegate{
    func performBannerAction(indexPath : IndexPath) {
        self.delegate?.performBannerAction(indexPath: indexPath)
    }
    
    var models : [DDHomeBannerModel] = [DDHomeBannerModel](){
        didSet{
            self.banner.models = models
        }
    }
    let banner = DDLeftRightAutoScroll.init(frame: CGRect.zero)
    weak var delegate : BannerAutoScrollViewActionDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(banner)
        banner.delegate = self
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        banner.frame = CGRect(x:0  , y: 0  , width : self.bounds.width , height : self.bounds.height)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol DDMsgScrollViewActionDelegate : NSObjectProtocol{
    func performMsgAction(indexPath : IndexPath)
    func moreBtnClick()
}
class HomeMessageScrollView : UIView , DDUpDownAutoScrollDelegate{
    var models : [DDHomeMsgModel] = [DDHomeMsgModel](){
        didSet{
            self.messageScrollView.models = models
        }
    }
    let messageScrollView : DDUpDownAutoScroll = DDUpDownAutoScroll.init(frame: CGRect.zero)
    weak var delegate : DDMsgScrollViewActionDelegate?
    let  leftBtn = UIButton()
    let  rightBtn = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(leftBtn)
        self.addSubview(rightBtn)
        self.addSubview(messageScrollView)
        messageScrollView.delegate = self
//        leftBtn.setTitle("logo", for: UIControlState.normal)
        leftBtn.setImage(UIImage(named:"notificationicon"), for: UIControlState.normal)
        rightBtn.setTitle("更多", for: UIControlState.normal)
        rightBtn.titleLabel?.font = GDFont.systemFont(ofSize: 13)
        leftBtn.setTitleColor(UIColor.DDTitleColor, for: UIControlState.normal)
//        rightBtn.setTitleColor(UIColor.DDSubTitleColor, for: UIControlState.normal)
        rightBtn.addTarget(self , action: #selector(moreBtnClick(sender:)), for: UIControlEvents.touchUpInside)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        rightBtn.frame = CGRect(x:self.bounds.width - self.bounds.height  , y: self.bounds.height/5  , width : self.bounds.height , height : self.bounds.height/2.5)
        rightBtn.ddSizeToFit()
        rightBtn.bounds = CGRect(x: 0, y: 0, width: rightBtn.bounds.width + 8, height: (rightBtn.titleLabel?.font.lineHeight ?? 13 ) + 3)
        rightBtn.center = CGPoint(x: self.bounds.width - rightBtn.bounds.width/2 - 10 , y: self.bounds.height/2)
        rightBtn.layer.cornerRadius = rightBtn.bounds.height/2
        rightBtn.layer.masksToBounds = true
        rightBtn.backgroundColor = .orange
        leftBtn.frame = CGRect(x:0  , y: 0  , width : self.bounds.height , height : self.bounds.height)
        messageScrollView.frame = CGRect(x: leftBtn.frame.maxX    , y: 0 , width : rightBtn.frame.minX - leftBtn.frame.maxX , height : self.bounds.height)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func performMsgAction(indexPath : IndexPath){
        self.delegate?.performMsgAction(indexPath: indexPath)
    }
    @objc func moreBtnClick(sender:UIButton)  {
        self.delegate?.moreBtnClick()
    }

    
}

class HomeSectionFooter: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
