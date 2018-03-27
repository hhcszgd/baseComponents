//
//  ProfileBtn.swift
//  Project
//
//  Created by 张凯强 on 2017/11/28.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit

class ProfileBtn: GDControl {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.titleL.font = UIFont.systemFont(ofSize: 14)
        self.titleL.textColor = UIColor.colorWithHexStringSwift("000000")
        self.subTitlelabel.font = UIFont.systemFont(ofSize: 14)
        self.subTitlelabel.textColor = UIColor.colorWithHexStringSwift("feb4b4")
        self.imageV.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10 * SCALE)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        self.titleL.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.imageV.snp.bottom).offset(6 * SCALE)
        }
        self.subTitlelabel.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleL.snp.bottom).offset(7 * SCALE)
        }
        
    }
    var title: String? {
        didSet{
            self.titleL.text = title
        }
    }
    var subTitle: String? {
        didSet{
            self.subTitlelabel.text = subTitle
        }
    }
    var image: UIImage? {
        didSet{
            self.imageV.image = image
            guard let img = image else {
                return
            }
            let width = img.size.width
            let height = img.size.height
            self.imageV.snp.updateConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(10 * SCALE)
                make.width.equalTo(width)
                make.height.equalTo(height)
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
