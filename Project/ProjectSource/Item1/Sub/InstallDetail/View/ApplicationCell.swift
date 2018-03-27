//
//  ApplicationCell.swift
//  Project
//
//  Created by 张凯强 on 2018/1/11.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ApplicationCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    
    @IBOutlet var applicationPeopleTitle: UILabel!
    @IBOutlet var applicationIDTitle: UILabel!
    @IBOutlet var applicationPhoneTitle: UILabel!
    
    @IBOutlet var applicationTimeTitle: UILabel!
    
    @IBOutlet var applicationPeopleValue: UILabel!
    @IBOutlet var applicationIDValue: UILabel!
    @IBOutlet var applicationPhoneValue: UILabel!
    
    @IBOutlet var applicationTimeValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    var type: String = ""
    var model: ShopInfoModel? {
        didSet{
            if type == "install" {
                self.title.text = "业务员信息"
                
            }
            if let number = model?.number {
                self.applicationIDTitle.text = "工号："
            }else {
                self.applicationIDTitle.text = ""
            }
            
            self.applicationPeopleValue.text = model?.memberName ?? ""
            self.applicationIDValue.text = model?.number ?? ""
            
            self.applicationTimeValue.text = model?.createAt ?? ""
            self.applicationPhoneValue.text = model?.mobile
            
            
            
            
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
