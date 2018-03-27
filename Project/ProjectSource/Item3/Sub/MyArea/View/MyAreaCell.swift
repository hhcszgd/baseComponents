//
//  MyAreaCell.swift
//  Project
//
//  Created by 张凯强 on 2018/1/15.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class MyAreaCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    @IBAction func btnAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        self.model?.isSelected = sender.isSelected
    }
    
    @IBOutlet var btn: UIButton!
    @IBOutlet var Label: UILabel!
    
    var model: AreaListModel? {
        didSet{
            self.Label.text = model?.name
            self.btn.isSelected = model?.isSelected ?? false
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
