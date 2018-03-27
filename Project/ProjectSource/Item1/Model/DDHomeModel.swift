//
//  DDHomeModel.swift
//  Project
//
//  Created by WY on 2017/12/5.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit


class test : NSObject , Decodable {
    var isNeedJudge: Bool = false
    var actionKey: String = ""
    var keyParameter: Any? = nil
    private enum CodingKeys: String, CodingKey  {
        case isNeedJudge
        case actionKey
        case keyParameter
    }
    
    required init(from decoder: Decoder) throws{
        var container = try decoder.container(keyedBy: CodingKeys.self)
        isNeedJudge = try container.decode(type(of: isNeedJudge), forKey: test.CodingKeys.isNeedJudge)
        //           var container =  try decoder.container(keyedBy: CodingKeys.self)
        //        var container = decoder.container(keyedBy: CodingKeys.self)
        //            try container.decode(isNeedJudge, forKey:.isNeedJudge)
        //        try container.decode(isNeedJudge, forKey: DDActionModel.CodingKeys.isNeedJudge)
    }
}
class DDHomeApiModel: NSObject , Codable{
    var status : Int = 0
    var message : String = ""
    var data  = HomeDataModel()
    
    
}
class DDActionModel: NSObject , DDShowProtocol {
    var isNeedJudge: Bool = false
    var actionKey: String = ""
    var keyParameter: Any? = nil
//    private enum CodingKeys: String, CodingKey  {
//        case isNeedJudge
//        case actionKey
//        case keyParameter2
//    }
//
//    required init(from decoder: Decoder) throws{
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        isNeedJudge = try container.decode(type(of: isNeedJudge), forKey: DDActionModel.CodingKeys.isNeedJudge)
//        actionKey = try container.decode(type(of: actionKey), forKey: DDActionModel.CodingKeys.actionKey)
//        keyParameter = try container.decode(type(of: keyParameter), forKey: DDActionModel.CodingKeys.keyParameter)
//    }
}
///data模型
class HomeDataModel   : NSObject , Codable{
    var banner : [DDHomeBannerModel] = [DDHomeBannerModel]()
    var notice : [DDHomeMsgModel] = [DDHomeMsgModel]()
    var function : [DDHomeFoundation] = [DDHomeFoundation]()
    var myshop : String?
}
///banner图
class DDHomeBannerModel:  DDActionModel , Codable{
    var image_url : String = ""
    var link_url : String = ""
//    "image_url":"http://i0.bjyltf.com/function/1_1.png",
//    "link_url":"http://www.baidu.com"
}
///轮播消息
class DDHomeMsgModel:  DDActionModel ,Codable {
    var id : String    = ""
    var title : String = ""
//    "id":"1",
//    "title":"公告公告公告公告"
}
///模块儿
class DDHomeFoundation : DDActionModel , Codable {
    var id :  String?
    var name : String = ""
    var image_url  = ""
    var target = ""
    var status : String?
    var link_url : String?
    /*
     "id":"1",
     "name":"安装业务",
     "image_url":"http://i0.bjyltf.com/function/1_1.png",
     "target":"anzhuang",
     "status":"1"
     */
}
