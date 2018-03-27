//
//  EditSelectCell.swift
//  Project
//
//  Created by 张凯强 on 2018/1/13.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class EditSelectCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.contentView.backgroundColor = UIColor.colorWithHexStringSwift("ed8202")
            self.title.textColor = UIColor.white
        }else {
            self.contentView.backgroundColor = UIColor.white
            self.title.textColor = UIColor.colorWithHexStringSwift("333333")
        }
        // Configure the view for the selected state
    }
    
    
}
