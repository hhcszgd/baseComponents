//
//  MingXiCell.swift
//  Project
//
//  Created by 张凯强 on 2018/1/24.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class MingXiCell: UITableViewCell {
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var bussinessTitle: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var timelabel: UILabel!
    @IBOutlet var money: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        // Initialization code
    }
    var model: MingXiItem? {
        didSet{
            self.timelabel.text = model?.createAt ?? ""
            var price: String = ""
            if model?.type == "1" {
                self.money.textColor = UIColor.colorWithHexStringSwift("ea9061")
                price = "+" + (model?.price ?? "")
                self.myImageView.image = UIImage.init(named: "installbusinessicons")
            }
            if model?.type == "2" {
                self.money.textColor = UIColor.colorWithHexStringSwift("2fc664")
                price = "-" + (model?.price ?? "")
                self.myImageView.image = UIImage.init(named: "bringoutsmallicons")
                
            }
            self.money.text = price
            self.bussinessTitle.text = model?.title
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
