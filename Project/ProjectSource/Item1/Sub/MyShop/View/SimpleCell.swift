//
//  SimpleCell.swift
//  Project
//
//  Created by 张凯强 on 2018/2/4.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class SimpleCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    @IBOutlet var myTitleLabel: UILabel!
    @IBOutlet var plusImage: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var model: ScreensModel? {
        didSet {
            self.myTitleLabel.text = model?.name
            if model?.isSelected == true {
                self.myTitleLabel.textColor = UIColor.colorWithHexStringSwift("ea9061")
                self.plusImage.isHidden = false
            }else {
                self.plusImage.isHidden = true
                self.myTitleLabel.textColor = UIColor.colorWithHexStringSwift("333333")
            }
        }
    }
}
