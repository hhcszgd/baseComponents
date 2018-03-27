//
//  ShopDetailModel.swift
//  Project
//
//  Created by 张凯强 on 2018/1/18.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import HandyJSON
class ShopDetailModel<T: HandyJSON, K: HandyJSON, Q: HandyJSON>: GDModel {
    var shop: T?
    var imageArr: [K]?
    var screens: [Q]?
    var item: [Q]?
    var shopImage: String?
    
    
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
        self.imageArr <-- "shop_images"
        mapper <<<
        self.shopImage <-- "shop_image"
    }
}
class ShopInfoModel: GDModel {
    var adminMemberID: String?
    var applyScreenNumber: String?
    var areaName: String?
    var auditingTime: String?
    var auditingUser: String?
    var createAt: String?
    var failReasion: String?
    var memberId: String?
    var memberName: String?
    var mobile: String?
    var name: String?
    var screenNumber: String?
    var screenStatus: String?
    var status: String?
    var applyName: String?
    var address: String?
    var number: String?
    var screens: [ScreensModel]?
    var shopImage: String = ""
    
    //管理人电话
    var adminMobile: String?
    //管理人姓名
    var adminMemberName: String?
    //申请人
    var applyMobile: String?
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
        self.adminMemberID <-- "admin_member_id"
        mapper <<<
        self.applyScreenNumber <-- "apply_screen_number"
        mapper <<<
        self.areaName <-- "area_name"
        mapper <<<
        self.auditingTime <-- "auditing_time"
        mapper <<<
        self.auditingUser <-- "auditing_user"
        mapper <<<
        self.createAt <-- "create_at"
        mapper <<<
        self.failReasion <-- "fail_reason"
        mapper <<<
        self.memberId <-- "member_id"
        mapper <<<
        self.memberName <-- "member_name"
        mapper <<<
        self.screenNumber <-- "screen_number"
        mapper <<<
        self.screenStatus <-- "screen_status"
        mapper <<<
        self.applyName <-- "apply_name"
        mapper <<<
        self.adminMobile <-- "admin_mobile"
        mapper <<<
        self.adminMemberName <-- "admin_member_name"
        mapper <<<
        self.applyMobile <-- "apply_mobile"
        mapper <<<
        self.shopImage <-- "shop_image"
    }
}

class ShopImagesModel: GDModel {
    var image: String?
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
        self.image <-- "image_url"
    }
}
class ScreensModel: GDModel {
    var name: String?
    var status: String?
    var id: String?
    var isSelected: Bool = false
}
