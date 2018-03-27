//
//  ManagerCell.swift
//  Project
//
//  Created by 张凯强 on 2018/1/18.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ManagerCell: UITableViewCell {

    @IBOutlet var myTitlelabel: UILabel!
    @IBOutlet var nameKeyLabel: UILabel!
    @IBOutlet var mobileKeyLabel: UILabel!
    @IBOutlet var jobNumberlabel: UILabel!
    
    @IBOutlet var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    
    @IBOutlet var mobile: UILabel!
    
    @IBOutlet var number: UILabel!
    
    @IBOutlet var numberTitle: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var model: ShopInfoModel? {
        didSet{
            self.name.text = model?.memberName ?? ""
            self.mobile.text = model?.mobile ?? ""
            self.number.text = model?.number ?? ""
            if let number = model?.number {
                self.numberTitle.text = "工号："
            }else {
                self.numberTitle.text = ""
            }
            
        }
    }
    
    
    
}
