//
//  DDGetCsahApiModel.swift
//  Project
//
//  Created by WY on 2018/1/25.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDGetCsahApiModel: NSObject ,Codable{
    var data : DDGetCsahApiDataModel?
    var message : String?
    var status : Int  = -1
}
class DDGetCsahApiDataModel: NSObject , Codable{
    var balance : String? = ""
    var bank_logo : String?
    var bank_name : String?
    var id : String?
    var number : String?

}
