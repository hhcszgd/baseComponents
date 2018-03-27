//
//  DDMsgDetailModel.swift
//  Project
//
//  Created by WY on 2018/1/12.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDMsgDetailApiModel: NSObject ,Codable{
    var data = DDMsgDetailDataModel()
    
    var message = ""
    var status = 0
}
class DDMsgDetailDataModel: NSObject ,Codable{
    //    var data
    
    var content : String? = ""
    var title = ""
    var create_at:String? = "2999"
}


