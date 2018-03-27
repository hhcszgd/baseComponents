//
//  NewAchienementApiModel.swift
//  Project
//
//  Created by WY on 2018/1/22.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class NewAchienementApiModel: NSObject ,Codable{
    var message : String?
    var status : Int = -1
    var data : NewAchienementDataModel? 
}



//class DDAchienementApiModel: DDActionModel  ,Codable{
//    var message : String?
//    var status : Int = -1
//    var data : DDAchienementDataModel = DDAchienementDataModel()
//}

class NewAchienementDataModel: DDActionModel ,Codable {
    var avatar : String?
    var count_price : CGFloat? = 0
    var create_at : Int? = -1
    var date_list : [NewAchienementTimeModel]?
    var lower_price: CGFloat? = 0
    var member_id : String? = ""
    var name : String?
    var number : String? = "" // 工号
    var price : CGFloat? = 0
    var screen_number : String?
    var shop_number: String?
    var message : [NewAchienementMsgModel]?
    var payment_password : String?
    var balance : String?
    required init(from decoder: Decoder) throws{
        var container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            screen_number = try container.decode(type(of: screen_number), forKey: CodingKeys.screen_number)//按String处理
        } catch  {
            let levelInt =  try container.decode(Int.self , forKey: CodingKeys.screen_number)//再按Int处理
            screen_number = "\(levelInt)"
        }
        avatar = try container.decodeIfPresent(type(of: avatar), forKey: CodingKeys.avatar) as? String
        count_price = try container.decodeIfPresent(type(of: count_price), forKey: CodingKeys.count_price) as? CGFloat
        create_at = try container.decodeIfPresent(type(of: create_at), forKey: CodingKeys.create_at) as? Int
        date_list = try container.decodeIfPresent(type(of: date_list), forKey: CodingKeys.date_list) as? [NewAchienementTimeModel]
        
        lower_price = try container.decodeIfPresent(type(of: lower_price), forKey: CodingKeys.lower_price) as? CGFloat
        member_id = try container.decodeIfPresent(type(of: member_id), forKey: CodingKeys.member_id) as? String
        name = try container.decodeIfPresent(type(of: name), forKey: CodingKeys.name) as? String
        number = try container.decodeIfPresent(type(of: number), forKey: CodingKeys.number) as? String
        price = try container.decodeIfPresent(type(of: price), forKey: CodingKeys.price) as? CGFloat
        
//        balance = try container.decodeIfPresent(type(of: balance), forKey: CodingKeys.balance) as? String
        do {
            balance = try container.decode(type(of: balance), forKey: CodingKeys.balance)//按String处理
        } catch  {
            let levelInt =  try container.decode(Int.self , forKey: CodingKeys.balance)//再按Int处理
            balance = "\(levelInt)"
        }
//        shop_number = try container.decodeIfPresent(type(of: shop_number), forKey: CodingKeys.shop_number) as? String
        do {
            shop_number = try container.decode(type(of: shop_number), forKey: CodingKeys.shop_number)//按String处理
        } catch  {
            let levelInt =  try container.decode(Int.self , forKey: CodingKeys.shop_number)//再按Int处理
            shop_number = "\(levelInt)"
        }
        
        do {
            payment_password = try container.decode(type(of: payment_password), forKey: CodingKeys.payment_password)//按String处理
        } catch  {
            let levelInt =  try container.decode(Int.self , forKey: CodingKeys.payment_password)//再按Int处理
            payment_password = "\(levelInt)"
        }
        
        message = try container.decodeIfPresent(type(of: message), forKey: CodingKeys.message) as? [NewAchienementMsgModel]
        
        
    }
    private enum CodingKeys: String, CodingKey  {
        case avatar
        case count_price
        case create_at
        case date_list
        case lower_price
        case member_id
        case name
        case number
        case price
        case screen_number
        case shop_number
        case message
        case payment_password
        case balance
    }
    
    
    
}

class NewAchienementTimeModel: DDActionModel ,Codable{
    var create_at : String = ""
}

class NewAchienementMsgModel: DDActionModel ,Codable{
    var create_at : String = ""
    var title : String = ""
}
