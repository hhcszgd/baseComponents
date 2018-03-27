//
//  ProfileCell.swift
//  Project
//
//  Created by 张凯强 on 2017/12/30.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class ProfileCell: GDControl {
    init(frame: CGRect, viewModel: ProfileViewModel) {
        super.init(frame: frame)
        self.addSubview(self.titleLabel)
        self.titleL.textColor = UIColor.colorWithHexStringSwift("333333")
        self.titleL.font = UIFont.systemFont(ofSize: 15)
        self.titleL.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        self.titleLabel.font = UIFont.systemFont(ofSize: 14)
        self.titleLabel.textColor = UIColor.colorWithHexStringSwift("333333")
        self.addSubview(self.titleLabel)
        self.addSubview(self.imageView)
        self.imageView.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(109)
            make.centerY.equalToSuperview()
            make.right.equalTo(self.imageView.snp.left).offset(-10)
        }
        self.addSubview(self.customView)
        self.customView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
        self.customView.backgroundColor = UIColor.colorWithHexStringSwift("eaeef4")
        

    }
    
    var model: ProfileModel = ProfileModel() {
        didSet{
            self.titleL.text = model.title
            self.titleLabel.text = model.subTitle
            let img = UIImage.init(named: model.rightImage)
            self.imageView.snp.updateConstraints { (make) in
                make.width.equalTo(img?.size.width ?? 15)
                make.height.equalTo(img?.size.height ?? 15)
            }
            self.imageView.image = img
            
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
