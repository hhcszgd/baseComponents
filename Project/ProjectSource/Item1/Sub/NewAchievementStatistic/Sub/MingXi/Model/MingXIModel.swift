//
//  MingXIModel.swift
//  Project
//
//  Created by 张凯强 on 2018/1/25.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import HandyJSON
class MingXIModel<T: HandyJSON, Q: HandyJSON>: GDModel {
    var income: String?
    var date_list: [T]?
    var item: [Q]?
    var pay: String?
    
}
class MingXiTimeListModel: GDModel {
    var createAt: String?
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
        self.createAt <-- "create_at"
    }
}
class MingXiItem: GDModel {
    var createAt: String?
    var price: String?
    var status: String?
    var mingxiType: String?
    var title: String?
    var desc: String?
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.createAt <-- "create_at"
        mapper <<<
            self.mingxiType <-- "type"
    }
}


