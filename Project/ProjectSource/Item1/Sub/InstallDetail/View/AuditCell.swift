//
//  AuditCell.swift
//  Project
//
//  Created by 张凯强 on 2018/1/11.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class AuditCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    
    @IBOutlet var applicationPeopleTitle: UILabel!
    @IBOutlet var auditTimeTitle: UILabel!
    @IBOutlet var installCountTitle: UILabel!
    @IBOutlet var applicationPeopleValue: UILabel!
    @IBOutlet var auditTimeValue: UILabel!
    @IBOutlet var installCountValue: UILabel!
    @IBOutlet var propmt: UILabel!
    
    @IBOutlet var propmtTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    var model: ShopInfoModel? {
        didSet{
            self.propmtTitle.text = ""
            self.applicationPeopleValue.text = model?.auditingUser ?? ""
            self.auditTimeValue.text = model?.auditingTime ?? ""
            if model?.status == "2" {
                self.installCountValue.text = ""
                self.installCountTitle.text = ""
                self.propmtTitle.text = "被驳回的原因："
                self.propmt.text = (model?.failReasion ?? "")
            }else {
                if let screenNumber = model?.screenNumber, let applyscreenNumber = model?.applyScreenNumber, screenNumber != applyscreenNumber {
                    self.installCountValue.text = model?.screenNumber ?? ""
                    self.propmt.text = ""
                    self.propmtTitle.text = ""
                    self.installCountTitle.text = "修改安装数量："
                }else {
                    self.installCountValue.text = ""
                    self.propmt.text = ""
                    self.propmtTitle.text = ""
                    self.installCountTitle.text = ""
                }
                
            }
            
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
