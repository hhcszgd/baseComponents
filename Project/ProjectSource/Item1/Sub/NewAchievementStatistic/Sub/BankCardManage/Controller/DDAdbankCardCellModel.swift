//
//  DDAdbankCardCellModel.swift
//  Project
//
//  Created by WY on 2018/1/23.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDAdbankCardCellModel: NSObject , Codable{
    var data : [DDBankCardModel]?
    var message = "";
    var status : Int  = -1;
}
class DDBankCardModel : NSObject , Codable {
    var bank_logo = ""
    var bank_name = ""
    var id : String = ""
    var member_id = ""
    var mobile = ""
    var number = ""
    var bank_back : String?
}
