//
//  ScreentPromptCell.swift
//  Project
//
//  Created by 张凯强 on 2018/3/12.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ScreentPromptCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    @IBOutlet var backView: UIView!
    var model: AdvertisModel? {
        didSet{
            self.mytitle.text = model?.name
            self.timeValue.text = model?.time
            self.sizelable.text = model?.spec
            self.formatLabel.text = model?.format
            var rateStr: String = ""
            model?.rate_list?.forEach({ (rate) in
                rateStr += rate + "频次 "
            })
            self.frequency.text = rateStr
        }
    }
    @IBOutlet var mytitle: UILabel!
    @IBOutlet var timeValue: UILabel!
    
    @IBOutlet var sizelable: UILabel!
    
    @IBOutlet var formatLabel: UILabel!
    
    @IBOutlet var frequency: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
