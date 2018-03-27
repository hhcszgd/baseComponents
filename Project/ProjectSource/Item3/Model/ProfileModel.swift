//
//  ProfileModel.swift
//  Project
//
//  Created by 张凯强 on 2017/12/12.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit

class ProfileModel: GDModel {
    var title: String = ""
    var subTitle: String = ""
    var rightImage: String = ""
    class func creatModel(title: String, subTitle: String, imgStr: String, actionKey: Actionkey) -> ProfileModel{
        let model = ProfileModel.init()
        model.title = DDLanguageManager.text(title)
        model.subTitle = subTitle
        model.rightImage = imgStr
        model.actionKey = actionKey
        return model
        
    }
}
