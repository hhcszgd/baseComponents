//
//  RightTableCell.swift
//  Project
//
//  Created by 张凯强 on 2018/1/17.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class RightTableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        // Initialization code
    }
    @IBOutlet var title: UILabel!
    var model: TimeModel? {
        didSet{
            guard let myModel = self.model else {
                return
            }
            self.title.text = myModel.title
            if myModel.isSelected {
                self.title.textColor = UIColor.colorWithHexStringSwift("ea9061")
                
            }else {
                self.title.textColor = UIColor.colorWithHexStringSwift("333333")
            }
        }
    }
    
    
    var statusModel: StatusModel? {
        didSet{
            guard let myModel = self.statusModel else {
                return
            }
            self.title.text = myModel.title
            if myModel.isSelected {
                self.title.textColor = UIColor.colorWithHexStringSwift("ea9061")
                
            }else {
                self.title.textColor = UIColor.colorWithHexStringSwift("333333")
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
