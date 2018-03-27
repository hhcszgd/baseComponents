//
//  InstallDetailShopInfoCell.swift
//  Project
//
//  Created by 张凯强 on 2018/1/10.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class InstallDetailShopInfoCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var shopName: UILabel!
    
    @IBOutlet var shopAddress: UILabel!
    
    @IBOutlet var shopCont: UILabel!
    
    @IBOutlet var shopPeopleTitle: UILabel!
    @IBOutlet var shopPhoneTitle: UILabel!
    @IBOutlet var shopNameValue: UILabel!
    @IBOutlet var shopCountValue: UILabel!
    
    @IBOutlet var shopaddressValue: UILabel!
    @IBOutlet var shopPeopleValue: UILabel!
    @IBOutlet var shopPhoneValue: UILabel!
    @IBOutlet var shopStatus: UILabel!
    
    @IBOutlet var shopNmaeValueWidth: NSLayoutConstraint!
    @IBOutlet var shopAddressValueWidth: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let leftWidth = SCREENWIDTH - 25 - 80 - 15 - 15
//        self.shopNmaeValueWidth.constant = leftWidth
//        self.shopAddressValueWidth.constant = leftWidth
        self.contentView.layoutIfNeeded()
        self.selectionStyle = .none
        // Initialization code
    }
    ///0,代表安装业务详情 ,1代表屏幕管理详情， 3我的店铺的信息
    var subType: Int = 0
    var type: Int = 0
    var model: ShopInfoModel? {
        didSet{
            self.shopNameValue.text = model?.name ?? ""
            self.shopaddressValue.text = (model?.areaName ?? "") + (model?.address ?? "")
            self.shopCountValue.text = model?.applyScreenNumber ?? ""
            self.shopPeopleTitle.text = ""
            self.shopPeopleValue.text = ""
            self.shopPhoneValue.text = ""
            self.shopPhoneTitle.text = ""
            
            self.shopPeopleTitle.text = "店铺联系人:"
            self.shopPhoneTitle.text = "联系方式:"
            self.shopPeopleValue.text = model?.applyName ?? ""
            self.shopPhoneValue.text = model?.applyMobile ?? ""
            
            if self.type == 0 {
                if let status = model?.status {
                    switch status {
                    case "0":
                        self.shopStatus.textColor = willAduitColor
                        self.shopStatus.text = "待审核"
                    case "1", "3", "4":
                        self.shopStatus.textColor = willInstallColor
                        self.shopStatus.text = "待安装"
                    case "2":
                        self.shopStatus.textColor = aduitFailColor
                        self.shopStatus.text = "被驳回"
                    case "5":
                        self.shopStatus.textColor = installedColor
                        if self.subType == 3 {
                            self.shopStatus.text = ""
                        }else {
                            self.shopStatus.text = "安装完成"
                        }
                        
                    case "":
                        self.shopStatus.text = ""
                    default:
                        break
                    }
                }
                
            }else {
                if let status = model?.screenStatus {
                    if status == "1" {
                        self.shopStatus.textColor = UIColor.colorWithHexStringSwift("4ca714")
                        self.shopStatus.text = "状态正常"
                    }else {
                        self.shopStatus.textColor = UIColor.red
                        self.shopStatus.text = "状态异常"
                    }
                }
            }
            
            
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
