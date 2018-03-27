//
//  DDPartnerListApiModel.swift
//  Project
//
//  Created by WY on 2018/1/11.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDPartnerListApiModel: NSObject ,Codable{
    var status:Int  = -1
    var message: String = ""
    var data : DDPartnerListApiDataModel = DDPartnerListApiDataModel()
}
class DDPartnerListApiDataModel: NSObject ,Codable{
    var parent:DDParentUserModel?
    var lower: [DDSubUserModel]?
    var level : [DDLevelModel]?
}
class DDLevelModel : DDActionModel,Codable {
    var key:Int = 0
    var value:String = ""
}

