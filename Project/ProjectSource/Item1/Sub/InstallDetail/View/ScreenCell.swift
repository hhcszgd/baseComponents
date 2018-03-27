//
//  ScreenCell.swift
//  Project
//
//  Created by 张凯强 on 2018/1/18.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ScreenCell: UITableViewCell {

    @IBOutlet var statusImage: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var status: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var model: ScreensModel? {
        didSet{
            self.title.text = model?.name ?? ""
            if let status = model?.status {
                if status == "1" {
                    self.statusImage.image = UIImage.init(named: "normalscreenicon")
                    self.status.text = "状态正常"
                    self.status.textColor = UIColor.colorWithHexStringSwift("4ca714")
                }else {
                    self.statusImage.image = UIImage.init(named: "screenexceptionicon")
                    self.status.textColor = UIColor.red
                    self.status.text = "状态异常"
                }
            }
        }
    }
    
    
    
    
}
