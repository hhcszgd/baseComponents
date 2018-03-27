//
//  ProvinceCell.swift
//  Project
//
//  Created by 张凯强 on 2018/3/7.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ProvinceCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.colorWithHexStringSwift("333333")
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.myTitleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    let selectBackColor = UIColor.init(red: 204, green: 204, blue: 204, alpha: 1.0)
    let unSelectBackColor = UIColor.colorWithHexStringSwift("333333")
    var model: AreaModel? {
        didSet{
            if model?.isSelected ?? false {
                self.contentView.backgroundColor = selectBackColor
                self.myTitleLabel.textColor = UIColor.colorWithHexStringSwift("333333")
            }else {
                self.myTitleLabel.textColor = UIColor.white
                self.contentView.backgroundColor = unSelectBackColor
            }

            self.myTitleLabel.text = model?.name
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var myTitleLabel: UILabel = {
        let label = UILabel.configlabel(font: UIFont.systemFont(ofSize: 16), textColor: UIColor.white, text: "北京市")
        label.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(label)
        return label
    }()
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
