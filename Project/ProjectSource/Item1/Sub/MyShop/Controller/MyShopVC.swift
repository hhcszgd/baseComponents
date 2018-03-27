//
//  MyShopVC.swift
//  Project
//
//  Created by 张凯强 on 2018/2/1.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
enum ShopStatus: String {
    case 待审核 = "待审核"
    case 待安装 = "待安装"
    case 被驳回 = "被驳回"
    case 安装完成 = "安装完成"
}
class MyShopVC: DDNormalVC, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var top: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title = "我的店铺"
        self.top.constant = DDNavigationBarHeight
        self.view.layoutIfNeeded()
        self.applyBtn.layer.borderColor = UIColor.white.cgColor
        self.applyBtn.layer.cornerRadius = 2
        if #available(iOS 10.0, *) {
            self.myCollectionView.isPrefetchingEnabled = false
        } else {
            // Fallback on earlier versions
        }
        self.myCollectionView.register(UINib.init(nibName: "MyShopCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MyShopCell")
        self.flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        let itemsWidth: CGFloat = SCREENWIDTH - 20
        let itemsHeight: CGFloat = SCREENHEIGHT - self.subContainerView.max_Y - DDNavigationBarHeight
        self.flowLayout.itemSize = CGSize.init(width: itemsWidth, height: itemsHeight)
//        self.request(shopID: nil)
        self.screenInfoBtn.isSelected = true
        self.addressView.addSubview(self.addressBtn)
        self.aboveBackImage.addSubview(self.effect)
        self.applyBtn.isHidden = true
    }
    var shopCount: Int = 0
    func uploadUI() {
        if  self.shopCount == 0 {
            self.aboveBackImage.image = UIImage.init(named: "orangebackground")
            self.shopImage.isHidden = true
            self.addressView.isHidden = true
            self.prompt.isHidden = false
            self.cornericonImage.isHidden = true
            self.statusLabel.isHidden = true
            self.applyBtn.isHidden = false
            self.maskView.isHidden = false
            self.effect.alpha = 0.0
            self.prompt.text = "申请安装屏幕\n不仅安装免费 更有两百元奖励"
            self.screenInfoBtn.isEnabled = false
            self.shopInfoBtn.isEnabled = false
            self.myCollectionView.isScrollEnabled = false
        }else {
            self.maskView.isHidden = true
            self.prompt.isHidden = true
            self.cornericonImage.isHidden = false
            self.statusLabel.isHidden = false
            self.applyBtn.isHidden = true
            self.shopImage.isHidden = false
            self.addressView.isHidden = false
            self.effect.alpha = 0.7
            self.screenInfoBtn.isEnabled = true
            self.shopInfoBtn.isEnabled = true
            self.myCollectionView.isScrollEnabled = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.request(shopID: nil)
        
    }
    
    
    
    lazy var effect: UIVisualEffectView = {
        let blur = UIBlurEffect.init(style: UIBlurEffectStyle.dark)
        
        let effectView = UIVisualEffectView.init(effect: blur)
        effectView.alpha = 0.8
        effectView.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight)
        
        return effectView
    }()
    lazy var addressBtn: MyShopAddressBtn = {
        let btn = MyShopAddressBtn.init(frame: CGRect.init(x: 0, y: 0, width: 140, height: 30), title: "")
        btn.addTarget(self, action: #selector(changeAddress(btn:)), for: .touchUpInside)
        return btn
    }()
    var selectAddressView: MyShopAddressView?
    @objc func changeAddress(btn: MyShopAddressBtn) {
        if let model = self.selectAddressModel {
            let subFrame = self.addressView.convert(self.addressView.bounds, to: self.view)
            let selectAddress = MyShopAddressView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT), subFrame: CGRect.init(x: subFrame.origin.x, y: subFrame.origin.y, width: subFrame.size.width, height: 110), dataArr: self.addressArr, selectShop: model)
            self.view.addSubview(selectAddress)
            self.selectAddressView = selectAddress
            self.selectAddressView?.finished.subscribe(onNext: { [weak self](value) in
                self?.selectAddressView?.removeFromSuperview()
            }, onError: nil, onCompleted: {
                mylog("结束")
                self.selectAddressView = nil
            }, onDisposed: {
                mylog("回收")
            })
            self.selectAddressView?.select.subscribe(onNext: { [weak self](value) in
                self?.addressBtn.title = value.name
                self?.selectAddressModel = value
                
                self?.request(shopID: value.id)
            }, onError: nil, onCompleted: {
                mylog("结束")
            }, onDisposed: {
                mylog("回收")
            })
            
            self.selectAddressView?.jump.subscribe(onNext: { [weak self](value) in
                self?.pushVC(vcIdentifier: "HomeWebVC", userInfo: DomainType.wap.rawValue +  "shop/create?type=dianpu")
//                let web = HomeWebVC()
//                let action = DDActionModel()
//
//                action.keyParameter =  DomainType.wap.rawValue +  "shop/create?type=dianpu"
//                web.showModel = action
//
//            self?.navigationController?.pushViewController(web, animated: true)

                
            }, onError: nil, onCompleted: {
                mylog("结束")
            }, onDisposed: {
                mylog("回收")
            })
            
            
        }else {
            GDAlertView.alert("没有店铺数据", image: nil, time: 1, complateBlock: nil)
        }
        
        
        
        
    }
    @IBOutlet var aboveBackImage: UIImageView!
    @IBOutlet var maskView: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var cornericonImage: UIImageView!
    @IBOutlet var applyBtn: UIButton!
    @IBOutlet var prompt: UILabel!
    @IBOutlet var shopImage: UIImageView!
    var addressArr: [ScreensModel] = []
    var selectAddressModel: ScreensModel?
    func request(shopID: String?) {
        let token = DDAccount.share.token ?? ""
        let id = DDAccount.share.id ?? ""
        
        var paramete = ["token": token] as [String: Any]
        if shopID != nil {
            paramete["shop_id"] = shopID!
        }
        NetWork.manager.requestData(router: Router.get("member/\(id)/myshop", .api, paramete)).subscribe(onNext: { (dict) in
            let model = BaseModel<ShopDetailModel<ShopInfoModel, ShopImagesModel, ScreensModel>>.deserialize(from: dict)
            
            if let data = model?.data {
                self.shopModel = data
                self.dataArr = ["a", "b"]
                
                self.myCollectionView.reloadData()
                if let address = self.shopModel?.item?.first, let arr = self.shopModel?.item, arr.count > 0 {
                    
                    self.addressBtn.title = address.name
                    self.selectAddressModel = address
                    if shopID == nil {
                        self.addressArr = arr
                        self.shopCount = arr.count
                        UserDefaults.standard.setValue(self.shopCount, forKey: "ShopCount")
                    }
                }
                if let status = self.shopModel?.shop?.status {
                    var statusStr: String = ""
                    switch status {
                    case "0":
                        statusStr = ShopStatus.待审核.rawValue
                    case "1", "3", "4":
                        statusStr = ShopStatus.待安装.rawValue
                    case "2":
                        statusStr = ShopStatus.被驳回.rawValue
                    case "5":
                        if self.shopModel?.shop?.screenStatus == "1" {
                            statusStr = "屏幕正常"
                        }else {
                            statusStr = "屏幕异常"
                        }
                        
                    default:
                        break
                    }
                    self.statusLabel.text = statusStr
                }
                
                
                if let imageStr = self.shopModel?.shop?.shopImage, imageStr.count > 0 {
                    let str = imageStr + "?imageView2/0/h/400"
                    self.shopImage.sd_setImage(with: imgStrConvertToUrl(str), placeholderImage: placeImageUse)
                    self.aboveBackImage.sd_setImage(with: imgStrConvertToUrl(str), placeholderImage: placeImageUse)
                }
                
                self.uploadUI()
            }
            
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
    }
    var dataArr: [String] = []
    var shopModel: ShopDetailModel<ShopInfoModel, ShopImagesModel, ScreensModel>?
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MyShopCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyShopCell", for: indexPath) as! MyShopCell
        if indexPath.item == 0 {
            cell.type = MyShopCellType.screenInfo
        }else {
            cell.type = MyShopCellType.shopInof
        }
        cell.model = self.shopModel
        return cell
    }
    
    
    
    
    @IBOutlet var subContainerView: UIView!
    @IBOutlet var backContainerView: UIView!
    @IBAction func applyInstallAction(_ sender: UIButton) {
        
        self.pushVC(vcIdentifier: "HomeWebVC", userInfo: DomainType.wap.rawValue +  "shop/create?type=dianpu")
//        let web = HomeWebVC()
//        let action = DDActionModel()
//        action.keyParameter =  DomainType.wap.rawValue +  "shop/create?type=dianpu"
//        web.showModel = action
//        self.navigationController?.pushViewController(web, animated: true )
        
    }
    @IBOutlet var aboveContainerView: UIView!
    
    
    
    @IBOutlet var addressView: UIView!
    
    @IBOutlet var myCollectionView: UICollectionView!
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet var guangGaoBtn: UIButton!
    @IBAction func guangGaoAction(_ sender: UIButton) {
    }
    @IBOutlet var shopInfoBtn: UIButton!
    
    @IBAction func shopInfoAction(_ sender: UIButton) {
        sender.isSelected = true
        self.screenInfoBtn.isSelected = false
        self.myCollectionView.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: .left, animated: true)
    }
    @IBOutlet var screenInfoBtn: UIButton!
    
    @IBAction func screenInfoAction(_ sender: UIButton) {
        sender.isSelected = true
        self.shopInfoBtn.isSelected = false
        self.myCollectionView.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: .left, animated: true)
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / (SCREENWIDTH - 20))
        if index == 0 {
            self.screenInfoBtn.isSelected = true
            self.shopInfoBtn.isSelected = false
            
        }else {
            self.screenInfoBtn.isSelected = false
            self.shopInfoBtn.isSelected = true
        }
    }
    deinit {
        self.addressBtn.invalidate()
        mylog("习奥会")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
