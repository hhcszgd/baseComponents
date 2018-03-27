//
//  InstallModel.swift
//  Project
//
//  Created by 张凯强 on 2018/1/11.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import HandyJSON
class InstallModel<T: HandyJSON, Q:HandyJSON>: GDModel {
    var data_list: [T]?
    var shop_list: [Q]?
    var memberType: String?
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
        self.data_list <-- "date_list"
        mapper <<<
        self.memberType <-- "member_type"
    }
}

class DataListModel: GDModel {
    
    var years: String?
    var month: [String]?
}

class ShopListModel: GDModel {
    var id: String?
    var logo: String?
    var name: String?
    var areaName: String?
    var screenNumber: String?
    var createAt: String?
    var screenStatus: String?
    var status: String?
    var memberName: String?
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.areaName <-- "area_name"
        mapper <<<
            self.screenNumber <-- "screen_number"
        mapper <<<
            self.createAt <-- "create_at"
        mapper <<<
            self.screenStatus <-- "screen_status"
        mapper <<<
            self.logo <-- "shop_image"
        mapper <<<
            self.memberName <-- "member_name"
        
    }
}

