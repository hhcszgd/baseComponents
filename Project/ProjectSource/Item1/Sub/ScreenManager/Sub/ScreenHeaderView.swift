//
//  ScreenHeaderView.swift
//  Project
//
//  Created by 张凯强 on 2018/1/18.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ScreenHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.aLabel)
        self.aLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        self.aLabel.text = "屏幕状态信息"
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var aLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.colorWithHexStringSwift("333333")
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
}
