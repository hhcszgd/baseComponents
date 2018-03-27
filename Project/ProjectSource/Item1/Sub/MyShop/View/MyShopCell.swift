//
//  MyShopCell.swift
//  Project
//
//  Created by 张凯强 on 2018/2/2.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
enum MyShopCellType: String {
    case screenInfo = "screenInfo"
    case shopInof = "shopInfo"
}
class MyShopCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var botttom: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib.init(nibName: "InstallDetailShopInfoCell", bundle: Bundle.main), forCellReuseIdentifier: "InstallDetailShopInfoCell")
        self.tableView.register(UINib.init(nibName: "InstallShopImageCell", bundle: Bundle.main), forCellReuseIdentifier: "InstallShopImageCell")
        self.tableView.register(UINib.init(nibName: "ApplicationCell", bundle: Bundle.main), forCellReuseIdentifier: "ApplicationCell")
        self.tableView.register(UINib.init(nibName: "AuditCell", bundle: Bundle.main), forCellReuseIdentifier: "AuditCell")
        self.tableView.register(UINib.init(nibName: "ManagerCell", bundle: Bundle.main), forCellReuseIdentifier: "ManagerCell")
        self.tableView.register(UINib.init(nibName: "ScreenCell", bundle: Bundle.main), forCellReuseIdentifier: "ScreenCell")
        self.botttom.constant = TabBarHeight
        self.contentView.layoutIfNeeded()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    var type: MyShopCellType?
    var model: ShopDetailModel<ShopInfoModel, ShopImagesModel, ScreensModel>? {
        didSet{
            self.tableView.reloadData()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.type == MyShopCellType.screenInfo {
            
            if let arr = self.model?.shop?.screens, arr.count > 0, self.model?.shop?.status == "5" {
                return 2
            }else {
                return 1
            }
        }
        if self.type == MyShopCellType.shopInof {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.model == nil {
            return 0
        }
        if self.type == MyShopCellType.screenInfo {
            if section == 0 {
                if self.model?.shop?.status != "0" {
                    return 2
                }else {
                    return 1
                }
                
            }
            if section == 1 {
                guard let arr = self.model?.shop?.screens else {
                    return 0
                }
                return arr.count
            }
        }
        if self.type == MyShopCellType.shopInof {
            return 2
        }
        return 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.type == MyShopCellType.screenInfo {
            if indexPath.section == 0 {
                if self.model?.shop?.status != "0" {
                    if indexPath.row == 0 {
                        let cell: AuditCell = tableView.dequeueReusableCell(withIdentifier: "AuditCell", for: indexPath) as! AuditCell
                        cell.model = self.model?.shop
                        return cell
                    }
                    if indexPath.row == 1 {
                        let cell: ManagerCell = tableView.dequeueReusableCell(withIdentifier: "ManagerCell", for: indexPath) as! ManagerCell
                        cell.model = self.model?.shop
                        if self.model?.shop?.status == "5" {
                            cell.myTitlelabel.text = "管理业务员信息"
                        }else {
                            cell.myTitlelabel.text = "业务员信息"
                        }
                        cell.nameKeyLabel.text = "姓名："
                        cell.mobileKeyLabel.text = "电话："
//                        cell.jobNumberlabel.text = "工号："
                        return cell
                    }
                }else {
                    if indexPath.row == 0 {
                        let cell: ManagerCell = tableView.dequeueReusableCell(withIdentifier: "ManagerCell", for: indexPath) as! ManagerCell
                        cell.model = self.model?.shop
                        if self.model?.shop?.status == "5" {
                            cell.myTitlelabel.text = "管理业务员信息"
                        }else {
                            cell.myTitlelabel.text = "业务员信息"
                        }
                        cell.nameKeyLabel.text = "姓名："
                        cell.mobileKeyLabel.text = "电话："
                        cell.jobNumberlabel.text = "工号："
                        return cell
                    }
                }
                
                
                
            }
            if indexPath.section == 1 {
                let cell: ScreenCell = tableView.dequeueReusableCell(withIdentifier: "ScreenCell", for: indexPath) as! ScreenCell
                cell.model = self.model?.shop?.screens![indexPath.row]
                return cell
            }
            
        }
        if self.type == MyShopCellType.shopInof {
            if indexPath.row == 0 {
                let cell: InstallDetailShopInfoCell = tableView.dequeueReusableCell(withIdentifier: "InstallDetailShopInfoCell", for: indexPath) as! InstallDetailShopInfoCell
//                self.model?.shop?.status = ""
                cell.subType = 3
                cell.model = self.model?.shop
                return cell
            }
            if indexPath.row == 1 {
                let cell: InstallShopImageCell = tableView.dequeueReusableCell(withIdentifier: "InstallShopImageCell", for: indexPath) as! InstallShopImageCell
                cell.dataArr = (self.model?.imageArr)!
                return cell
            }
            
        }
        return UITableViewCell.init()
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.type == MyShopCellType.screenInfo {
            if section == 1 {
                let view = ScreenHeaderView.init(frame: CGRect.zero)
                return view
            }
            return nil
        }
        
        return nil
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 30
        }
        return 0.001
    }
    
    
}
