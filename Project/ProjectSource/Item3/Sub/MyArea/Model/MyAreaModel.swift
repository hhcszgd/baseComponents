//
//  MyAreaModel.swift
//  Project
//
//  Created by 张凯强 on 2018/1/18.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import HandyJSON
class MyAreaModel<T: HandyJSON>: GDModel {
    var mobile: String?
    var name: String?
    ///员工编号
    var number: String?
    
    var area: String?
    var admin_area: String?
    var member_type: String?
    var area_list: [T]?
    var examine_status: String?
    
    
    
    var avatar: String?
}

class AreaListModel: GDModel {
    var area: String?
    var name: String?
    var isSelected: Bool = false
}
