//
//  DDPartnerDetailApiModel.swift
//  Project
//
//  Created by WY on 2018/1/12.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDPartnerDetailApiModel: NSObject  , Decodable{
    var message = ""
    var status:Int  = -1
    var data : DDPartnerDetailDataModel = DDPartnerDetailDataModel()
}
class DDPartnerDetailDataModel: NSObject  , Decodable {
    var member : DDPartnerDetailMemberModel?
    var parent_member : DDPartnerDetailUpMemberModel?
    var shop : [DDShopReviewModel]?
}
class DDPartnerDetailMemberModel: DDActionModel , Decodable {
    var level :String  = ""
    var mobile : String = ""
    var name: String?   = ""
    var number : String?  = ""
    var avatar : String?
    
    private enum CodingKeys: String, CodingKey  {
        case level
        case mobile
        case name
        case number
        case avatar
    }
    
    required init(from decoder: Decoder) throws{
        var container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            level = try container.decode(type(of: level), forKey: CodingKeys.level)//按String处理
        } catch  {
            let levelInt =  try container.decode(Int.self , forKey: CodingKeys.level)//再按Int处理
            level = "\(levelInt)"
        }
        mobile = try container.decode(type(of: mobile), forKey: CodingKeys.mobile)
        name = try container.decode(type(of: name), forKey: CodingKeys.name)
        number = try container.decodeIfPresent(type(of: number), forKey: CodingKeys.number) as? String//.decode(type(of: number), forKey: CodingKeys.number)
        avatar = try container.decode(type(of: avatar), forKey: CodingKeys.avatar)
    }
}
class DDPartnerDetailUpMemberModel: DDActionModel,Decodable {
    var avatar:String?
    var id:String  = ""
    var name:String? = ""
}

class DDShopReviewModel: DDActionModel,Decodable {
    var shop_image : String? = "" 
    var area_name = ""
    var create_at = ""
    var id : String = ""
    var logo : String? = ""
    var name : String = ""
    var  member_name : String? = ""
    var screen_number:String  = ""
    var screen_status : String  = ""
    ///(0、待审核 1、待安装 2、被驳回 3、已安装) // 1、待审核 2、被驳回 3、待安装 4、已安装)
    var status : String  = ""
}
/*
data =     {
    member =         {
        level = 2;
        mobile = 18500971054;
        name = "<null>";
        number = BJ1515735751;
    };
    "parent_member" =         {
        avatar = "<null>";
        id = 1;
        name = "\U8bb8\U9e4f\U4eae1";
    };
    shop =         (
        {
            "area_name" = "\U54c8";
            "create_at" = "2018-01-12";
            id = 2;
            logo = "http://";
            name = "\U554a";
            "screen_number" = 0;
            "screen_status" = 0;
            status = 1;
        }
    );
};
message = "\U6210\U529f";
status = 200;
 */
