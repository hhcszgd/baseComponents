//
//  DDOrderDetailApiModel.swift
//  Project
//
//  Created by WY on 2018/3/7.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDOrderDetailApiModel: DDActionModel , Codable{
    var message = ""
    var status = -1
    var data : DDOrderDetailApiData?
}

class DDOrderDetailApiData: Codable {
    var order :  DDOrderDetailApiDataModel?
}
class DDOrderDetailApiDataModel : DDActionModel , Codable{
    var advert_name = "";
    var advert_time : String = ""
    var area_name : String = ""
    var create_at = "";
    var end_at : String? = "";
    var examine_status  = ""
    var id = ""
    var is_update : String = ""
    var order_code : String = ""
    var order_price  = ""
    var payment_status = "";
    var rate  = ""
    var start_at : String? = "";
    var total_day   = ""
    var unit_price = ""
    
    var salesman_name = ""
    var salesman_mobile  = ""
    var custom_service_name  = ""
    var custom_service_mobile = ""
    ///素材驳回状态时返回此字段（驳回原因）
    var examine_desc : String?
    // 业务员查看订单才有的信息
    var member_name : String?
    var mobile  : String?
    
    ///尾款
    var retainage : String?
    ///补尾款剩余天数
    var days_remaining : String?
    /// 订单状态为0和1时且支付方式为线下付款时返回此字段值为1
    var remittance : String?
    
    ///对接人评价状态1:已投诉 , 2:未投诉
    var custom_complain_type : String?
    ///业务员评价状态1:已投诉 , 2:未投诉
    var salesman_complain_type : String?
    ///支付类型1:全款 , 2:定金
    var payment_type = "0"
    ///预付定金
    var payment_price : String?
    ///用户所在地
    var address = ""
    
}
