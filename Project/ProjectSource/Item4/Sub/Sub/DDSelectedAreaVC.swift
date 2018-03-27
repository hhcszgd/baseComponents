//
//  DDSelectedAreaVC.swift
//  Project
//
//  Created by WY on 2018/3/8.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
private let itemW = SCREENWIDTH / 3
class DDSelectedAreaVC: DDNormalVC {
    enum AddressType : Int {
        case County
        case province
        case city
        case area
    }
    let bar1 = DDNavigationItemBar.init(CGRect(x: 0, y: DDNavigationBarHeight, width: itemW, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight), DDNavigationProvince.self)
    let bar2 = DDNavigationItemBar.init(CGRect(x: itemW, y: DDNavigationBarHeight, width: itemW, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight), DDNavigationCity.self)
    let bar3 = DDNavigationItemBar.init(CGRect(x: itemW * 2, y: DDNavigationBarHeight, width: itemW, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight), DDNavigationArea.self)
    var apiModel1 = DDSelectedAreaApiModel()
    var apiModel2 = DDSelectedAreaApiModel()
    var apiModel3 = DDSelectedAreaApiModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.userInfo == nil  {
            self.userInfo = "0"
        }
        self.title = "已选择地区列表"
        configBar(bar: bar1)
        bar1.whetherItemSizeAverage = false
        bar1.backgroundColor = .black
        configBar(bar: bar2)
        bar2.whetherItemSizeAverage = false
        bar2.backgroundColor = .lightGray
        configBar(bar: bar3)
        bar3.backgroundColor = .white
        bar3.whetherItemSizeAverage = false
        // Do any additional setup after loading the view.
        requestApi()
    }
    func requestApi(addressType : AddressType = .County, parentID : String? = nil)  {
        DDRequestManager.share.orderSelectedArea(order_id: self.userInfo as! String, parent_id: parentID , true )?.responseJSON(completionHandler: { (response ) in
            if let apiModel = DDDecode(DDSelectedAreaApiModel.self , from: response){
                switch addressType {
                case .County :
                    self.apiModel1 = apiModel
                    self.bar1.reloadData()
                    break
                case .province :
                    self.apiModel2 = apiModel
                    self.bar2.selectedIndexPath = IndexPath(item: 0, section: 0 )
                    self.apiModel3 = DDSelectedAreaApiModel()
                    self.bar3.reloadData()
                    self.bar3.selectedIndexPath = IndexPath(item: 0, section: 0 )
                    self.bar2.reloadData()
                    break
                case .city :
                    self.apiModel3 = apiModel
                    self.bar3.reloadData()
                    break
                case .area :
                    break
                }
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension DDSelectedAreaVC :  DDNavigationItemBarDelegate {
    func configBar(bar:DDNavigationItemBar)  {
        self.view.addSubview(bar)
        bar.delegate = self
        bar.selectedIndexPath = IndexPath(item: 0, section: 0)
        bar.scrollDirection = .vertical
    }
    func itemSizeOfNavigationItemBar(bar : DDNavigationItemBar) -> CGSize{
        return CGSize(width: itemW, height: 34)
    }
    func numbersOfNavigationItemBar(bar: DDNavigationItemBar) -> Int {
        switch bar  {
        case bar1:
            return self.apiModel1.data?.count ?? 0
        case bar2:
            return self.apiModel2.data?.count ?? 0
        case bar3:
            return self.apiModel3.data?.count ?? 0
        default:
            return 0
        }
    }
    func setParameteToItem(bar : DDNavigationItemBar,item: UICollectionViewCell, indexPath: IndexPath) {
        switch bar  {
        case bar1:
            if let itemInstens = item as? DDNavigationProvince{
                itemInstens.selectedStatus = bar.selectedIndexPath == indexPath ? true : false
                if  let model = self.apiModel1.data?[indexPath.item] , bar.selectedIndexPath == indexPath{
                    self.requestApi(addressType: DDSelectedAreaVC.AddressType.province, parentID: "\(model.id)")
                }
                itemInstens.label.text = self.apiModel1.data?[indexPath.item].name//dataSource of province
            }
        case bar2:
            if let itemInstens = item as? DDNavigationCity{
                itemInstens.selectedStatus = bar.selectedIndexPath == indexPath ? true : false
                itemInstens.label.text = self.apiModel2.data?[indexPath.item].name//dataSource of city
                if  let model = self.apiModel2.data?[indexPath.item] , bar.selectedIndexPath == indexPath{
                    self.requestApi(addressType: DDSelectedAreaVC.AddressType.city, parentID: "\(model.id)")
                }
            }
        case bar3:
            if let itemInstens = item as? DDNavigationArea{
                itemInstens.selectedStatus = bar.selectedIndexPath == indexPath ? true : false
                itemInstens.label.text = self.apiModel3.data?[indexPath.item].name//dataSource of area
            }
        default:
            break
        }

    }
    func didSelectedItemOfNavigationItemBar(bar : DDNavigationItemBar,item: UICollectionViewCell, indexPath: IndexPath) {
        if let itemInstens = item as? DDNavigationProvince{
            itemInstens.selectedStatus = bar.selectedIndexPath == indexPath ? true : false
            self.bar1.reloadData()
        } else if let itemInstens = item as? DDNavigationCity{
            itemInstens.selectedStatus = bar.selectedIndexPath == indexPath ? true : false
            self.bar2.reloadData()
        }else if let itemInstens = item as? DDNavigationArea{
            itemInstens.selectedStatus = bar.selectedIndexPath == indexPath ? true : false
        }
    }
}


extension DDSelectedAreaVC {
    class DDNavigationProvince: DDNavigationItem {
        override var selectedStatus : Bool{
            didSet{
                if selectedStatus {
                    self.contentView.backgroundColor = UIColor.lightGray
                    self.label.textColor = .black
                }else{
                    self.contentView.backgroundColor = UIColor.black
                    self.label.textColor = .white
                }
            }
        }
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.contentView.backgroundColor = .black
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    class DDNavigationCity: DDNavigationItem {
        override var selectedStatus : Bool{
            didSet{
                if selectedStatus {
                    self.backgroundColor = UIColor.white
                    self.label.textColor = .black
                }else{
                    self.backgroundColor = UIColor.lightGray
                    self.label.textColor = .white
                }
            }
        }
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    class DDNavigationArea: DDNavigationItem {
        override var selectedStatus : Bool{
            didSet{
                if selectedStatus {
                    self.backgroundColor = UIColor.white
                }else{
                    self.backgroundColor = UIColor.white
                }
            }
        }
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
