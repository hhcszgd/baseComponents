//
//  DDBandBrandModel.swift
//  Project
//
//  Created by WY on 2018/1/24.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDBandBrandApiModel: NSObject , Codable{
    var message : String?
    var status : Int  = -1
    var data : [DDBandBrandModel]?
}
class DDBandBrandModel: NSObject , Codable {
    var back : String? = ""
    var id : Int  = -1
    var logo : String? = ""
    var name = ""
}
