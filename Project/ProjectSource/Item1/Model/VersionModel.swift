//
//  VersionModel.swift
//  Project
//
//  Created by 张凯强 on 2018/2/6.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import HandyJSON
class VersionModel: GDModel {
    var version: String = ""
    var desc: String = ""
    var uptype: String = ""
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.uptype <-- "upgrade_type"
    }
    
}
