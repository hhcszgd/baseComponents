//
//  bussinessCell.swift
//  Project
//
//  Created by 张凯强 on 2018/1/10.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
let willInstallColor = UIColor.colorWithHexStringSwift("ea9061")
let installedColor = UIColor.colorWithHexStringSwift("4ca714")
let willAduitColor = UIColor.colorWithHexStringSwift("ea9061")
let aduitFailColor = UIColor.colorWithHexStringSwift("cccccc")
class bussinessCell: UITableViewCell {

    @IBOutlet var titleImage: UIImageView!
    @IBOutlet var shopName: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var count: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var status: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    @IBOutlet var chargeLabel: UILabel!
    var keyWorld: String?
    var type: Int = 0
    var model: ShopListModel? {
        didSet{
            self.shopName.attributedText = (model?.name ?? "").setColor(color: UIColor.red, keyWord: self.keyWorld ?? "")
            self.address.attributedText = (model?.areaName ?? "").setColor(color: UIColor.red, keyWord: self.keyWorld ?? "")
            self.time.attributedText = (model?.createAt ?? "").setColor(color: UIColor.red, keyWord: self.keyWorld ?? "")
            if let st = model?.status {
                switch st {
                case "0":
                    self.status.textColor = willAduitColor
                    self.status.attributedText = ShopStatus.待审核.rawValue.setColor(color: UIColor.red, keyWord: self.keyWorld ?? "")
                case "1", "3", "4":
                    self.status.textColor = willInstallColor
                    self.status.attributedText = ShopStatus.待安装.rawValue.setColor(color: UIColor.red, keyWord: self.keyWorld ?? "")
                case "2":
                    self.status.textColor = aduitFailColor
                    self.status.attributedText = ShopStatus.被驳回.rawValue.setColor(color: UIColor.red, keyWord: self.keyWorld ?? "")
                case "5":
                    self.status.textColor = installedColor
                    self.status.attributedText = ShopStatus.安装完成.rawValue.setColor(color: UIColor.red, keyWord: self.keyWorld ?? "")
                default:
                    break
                }
            }
            
            
            let screenNumber = (model?.screenNumber ?? "0") + "台屏幕"
            
            let attribute = NSMutableAttributedString.init(string: screenNumber)
            
            attribute.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.colorWithHexStringSwift("ea9061")], range: NSRange.init(location: 0, length: screenNumber.count - 3))
            self.count.attributedText = attribute
            
            if let img = model?.logo {
                
                self.titleImage.sd_setImage(with: imgStrConvertToUrl(img), placeholderImage: DDPlaceholderImage, options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed])
            }else {
                self.titleImage.image = UIImage.init()
            }
            
            
        }
    }
    
    
    
    var screenModel: ShopListModel? {
        didSet{
            self.shopName.attributedText = (screenModel?.name ?? "").setColor(color: UIColor.red, keyWord: self.keyWorld ?? "")
            self.address.attributedText = (screenModel?.areaName ?? "").setColor(color: UIColor.red, keyWord: self.keyWorld ?? "")
            self.time.attributedText = (screenModel?.createAt ?? "").setColor(color: UIColor.red, keyWord: self.keyWorld ?? "")
            if let st = screenModel?.screenStatus, let statusInt = Int(st) {
                if statusInt == 1 {
                    self.status.textColor = willInstallColor
                    self.status.attributedText = "屏幕正常".setColor(color: UIColor.red, keyWord: self.keyWorld ?? "")
                }
                if statusInt == 2 {
                    self.status.textColor = aduitFailColor
                    self.status.attributedText = "屏幕异常".setColor(color: UIColor.red, keyWord: self.keyWorld ?? "")
                }
                if statusInt == 0 {
                    self.status.text = ""
                }
                
            }else {
                self.status.text = ""
            }
            
            
            let screenNumber = (screenModel?.screenNumber ?? "0") + "台屏幕"
            
            let attribute = NSMutableAttributedString.init(string: screenNumber)
            
            attribute.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.colorWithHexStringSwift("ea9061")], range: NSRange.init(location: 0, length: screenNumber.count - 3))
            self.count.attributedText = attribute
            if let img = screenModel?.logo {
                self.titleImage.sd_setImage(with: imgStrConvertToUrl(img), placeholderImage: DDPlaceholderImage, options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed])
                
                
            }else {
                self.titleImage.image = UIImage.init()
            }
            
            
        }
    }
    var chaxunModel: ShopListModel? {
        didSet{
            self.shopName.attributedText = (chaxunModel?.name ?? "").setColor(color: UIColor.red, keyWord: self.keyWorld ?? "")
            self.address.attributedText = (chaxunModel?.areaName ?? "").setColor(color: UIColor.red, keyWord: self.keyWorld ?? "")
            self.time.attributedText = (chaxunModel?.createAt ?? "").setColor(color: UIColor.red, keyWord: self.keyWorld ?? "")
            if let st = chaxunModel?.status {
                switch st {
                case "0":
                    self.status.textColor = willAduitColor
                    self.status.attributedText = ShopStatus.待审核.rawValue.setColor(color: UIColor.red, keyWord: self.keyWorld ?? "")
                case "1", "3", "4":
                    self.status.textColor = willInstallColor
                    self.status.attributedText = ShopStatus.待安装.rawValue.setColor(color: UIColor.red, keyWord: self.keyWorld ?? "")
                case "2":
                    self.status.textColor = aduitFailColor
                    self.status.attributedText = ShopStatus.被驳回.rawValue.setColor(color: UIColor.red, keyWord: self.keyWorld ?? "")
                case "5":
                    self.status.textColor = installedColor
                    self.status.attributedText = ShopStatus.安装完成.rawValue.setColor(color: UIColor.red, keyWord: self.keyWorld ?? "")
                default:
                    break
                }
            }
            
            
            
            let screenNumber = (chaxunModel?.screenNumber ?? "0") + "台屏幕"
            
            let attribute = NSMutableAttributedString.init(string: screenNumber)
            
            attribute.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.colorWithHexStringSwift("ea9061")], range: NSRange.init(location: 0, length: screenNumber.count - 3))
            self.count.attributedText = attribute
            
            if let img = chaxunModel?.logo {
                self.titleImage.sd_setImage(with: imgStrConvertToUrl(img), placeholderImage: DDPlaceholderImage, options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed])
            }else {
                self.titleImage.image = UIImage.init()
            }
            if let str = chaxunModel?.memberName {
                self.chargeLabel.attributedText = ("负责人：" + str).setColor(color: UIColor.red, keyWord: self.keyWorld ?? "")
            }else {
                self.chargeLabel.text = ""
            }
            
        }
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
