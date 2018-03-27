
//  DDRequestManager.swift
//  ZDLao
//
//  Created by WY on 2017/10/17.
//  Copyright © 2017年 com.16lao. All rights reserved.
//app address : https://itunes.apple.com/us/app/%e7%8e%89%e9%be%99%e4%bc%a0%e5%aa%92/id1335870775?l=zh&ls=1&mt=8
/*
 status = 1;
 id = 4;
 name = JohnLock;
 token = 5ebfcf173717960b25b270f06c401d20;
 avatar = http://f0.ugshop.cn/FilF9WGuUGZW5eX-WtfvpFoeTsaY;
 */

import UIKit
import Alamofire
import CoreLocation

enum DomainType : String  {

    case release  = "http://tpi.bjyltf.com/"//"http://123.207.141.131/"//"http://123.207.141.131/"//
    case develop  = "http://api.xxxbjyltf.cc/"
    case wap = "http://tap.bjyltf.com/" //tap.bjyltf.com，"http://wap.bjyltf.cc/"
}
class DDRequestManager: NSObject {
    let version = "v1/"
    let client = COSClient.init(appId: "1255626690", withRegion: "sh")
    var token : String? = "token"
    static let share : DDRequestManager = {
        let mgr = DDRequestManager()
        mgr.result.session.configuration.timeoutIntervalForRequest = 10
        return mgr
    }()
    
    let result = SessionManager.default
    private func performRequest(url : String,method:HTTPMethod , parameters: Parameters? ,  print : Bool = false  ) -> DataRequest? {
        if let status = NetworkReachabilityManager(host: "www.baidu.com")?.networkReachabilityStatus{
            switch status {
            case .notReachable:
                GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
                return nil
            case .unknown :
                GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
                return nil
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
                break
            case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                break
            }
        }
        
        
        var parameters = parameters == nil ? Parameters() : parameters!
        parameters["l"] = DDLanguageManager.languageIdentifier
        parameters["c"] = DDLanguageManager.countryCode
//        let url = replaceHostSurfix(urlStr: url, surfix: hostSurfix)
        let url = (DomainType.release.rawValue + version) + url
        if let url  = URL(string: url){
            let result = Alamofire.request(url , method: method , parameters: parameters ).responseJSON(completionHandler: { (response) in
                if print{mylog(response.debugDescription.unicodeStr)}
                switch response.result{
                case .success :
                    break
                    
                case .failure :
                    mylog(response.debugDescription.unicodeStr)
                    GDAlertView.alert("请求失败,请重试", image: nil , time: 2, complateBlock: nil )//请求超时处理
                    break
                }
            })
            return result
        
//                .responseJSON(completionHandler: { (response) in
//                mylog(String.init(data: response.data ?? Data(), encoding: String.Encoding.utf8))
//                mylog("print request result -->:\(response.result)")
//                "xx".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
//                let testOriginalStr = "http://www.hailao.com/你好世界"
//                let urlEncode = testOriginalStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
//                let urlDecodeStr = urlEncode?.removingPercentEncoding
//                mylog("encode : \(urlEncode)")
//                mylog("decode : \(urlDecodeStr)")
//                
//                let tt = "\\U751f\\U6210key\\U6210\\U529f"
////                mylog("tttt\(tt.u)")
//            })
        }else{return nil }
    }
    private  func replaceHostSurfix( urlStr : String , surfix : String = "cn") -> String {
//        var urlStr = "http://www.baidu.com/fould/tindex.html?name=name"
        var urlStr  = urlStr
        if let url = URL(string: urlStr) {
            var host = url.host ?? ""
            let http = url.scheme ?? "" //http or https
            let index = host.index(host.endIndex, offsetBy: -3)
            let willReplaceStr = "\(http)://\(host)"
            let willReplaceRange = willReplaceStr.startIndex..<willReplaceStr.endIndex
            host.removeSubrange(index..<host.endIndex)
            if !host.hasSuffix("."){host = "\(host)."}
            host.append(contentsOf: surfix)
            let destinationStr  = "\(http)://\(host)"
            urlStr.replaceSubrange(willReplaceRange, with: destinationStr)
            mylog("converted:\(urlStr)")
        }
        return urlStr
    }
  
 
    /*
     home page api
     */
    @discardableResult
    func homePage(_ print : Bool = false ) -> DataRequest? {
        let url  =  "index"
//        "40d1783fbb98f6ed3b17c661786d5edf"
        let para = ["token" : DDAccount.share.token ?? ""]
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    /*
     func edit page  api
     */
    @discardableResult
    func funcEditPage(_ print : Bool = false ) -> DataRequest? {
        let url  =  "function"
        let para = ["token" : DDAccount.share.token ?? ""]
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    /// message page api
    @discardableResult
    func messagePage(keyword:String? = nil  , page : Int = 1, _ print : Bool = false ) -> DataRequest? {
        dump(DDAccount.share)
        let url  =  "member/\(DDAccount.share.id ?? "0")/message"//TODO 1 要改成真是的memberID
        var para = ["token" : DDAccount.share.token ?? "","page":page] as [String : Any]
        if let  keywordUnwrap = keyword{ para["keyword"] = keywordUnwrap }
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    /// message page api
    @discardableResult
    func changeSquence(json:String , _ print : Bool = false ) -> DataRequest? {
        let url  =  "function"
        let para = ["token" : DDAccount.share.token ?? "","function_content":json]
        return  performRequest(url: url , method: HTTPMethod.post, parameters: para , print : print )
    }
    
    /// partnerPageApi
    @discardableResult
    func partnerPage(keyword : String? , level : String?,page : Int = 1 , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "0")/lower"//TODO 1 替换成真实memberID
        var para = ["token" : DDAccount.share.token ?? "","page":page ] as [String : Any]
        if let keyWord =  keyword {para["keyword"] = keyWord}
        if let level =  level {
            para["level"] = (level)
        }
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    
    
    
    
    
    
    
    /// messageDetail
    @discardableResult
    func messageDetail(messageID:String, _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "0")/message/\(messageID)"//TODO 1 替换成真实memberID
        let para = ["token" : DDAccount.share.token ?? "" ]
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    
    /// partnerDetail
    @discardableResult
    func partnerDetail(targetMemberID:String = "7" , page  : Int = 1 , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "0")/lower/\(targetMemberID)"//TODO 1 替换成真实memberID
        let para = ["token" : DDAccount.share.token ?? "" , "page" : "\(page)"]
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    /// Achievement statistic page
    
    @discardableResult
    func achievementStatistic(create_at:String? , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "0")/account"//TODO 1 替换成真实memberID
        var  para = ["token" : DDAccount.share.token ?? ""]
        if let create_at_unwrap = create_at{
            para["create_at"] = create_at_unwrap
        }
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    /// Achievement statistic page
    
    @discardableResult
    func newAchievementStatistic(create_at:String? , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "0")/account"//TODO 1 替换成真实memberID
        var  para = ["token" : DDAccount.share.token ?? ""]
        if let create_at_unwrap = create_at{
            para["create_at"] = create_at_unwrap
        }
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    /// band bank card
    /// http://123.207.141.131/v1/member/<member_id>/bank
    
    @discardableResult
    func bandBankCard(ownName : String , cardNum:String , mobile:String , bankID : String , verify : String , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "0")/bank"//TODO 1 替换成真实memberID
        let  para = ["token" : DDAccount.share.token ?? "" , "bank_id" : bankID , "number" : cardNum , "mobile" : mobile ,"verify" : verify , "name":ownName]

        return  performRequest(url: url , method: HTTPMethod.post, parameters: para , print : print )
    }
    
    /// get has banded bank card list
    @discardableResult
    func getBandkCard( _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "0")/bank"//TODO 1 替换成真实memberID
        let  para = ["token" : DDAccount.share.token ?? "" ]
        
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    /// untie bank card
    @discardableResult
    func untieBankCard(bankID : String ,  print : Bool = false  ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/bank/\(bankID)"
        let  para = ["token" : DDAccount.share.token ?? "" ]
        return  performRequest(url: url , method: HTTPMethod.delete, parameters: para , print : print )
    }
    
    /// get bank brand name list
    @discardableResult
    func getBankBrandList( _ print : Bool = false ) -> DataRequest? {
        let url  =  "bank"//TODO 1 替换成真实memberID
        let  para = ["token" : DDAccount.share.token ?? "" ]
        
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    
    /// get cash page
    @discardableResult
    func getCashPage( _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/withdraw"
        let  para = ["token" : DDAccount.share.token ?? "" ]
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    
    /// get cash action
    @discardableResult
    func getCashAction(bank_id :String , price:String , payment_password:String , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/withdraw"
        let nsStr  = NSString.init(string: price)
        let priceFloat = nsStr.floatValue
        let  para = [
            "token" : DDAccount.share.token ?? "",
            "bank_id" :bank_id ,
            "price":"\(priceFloat)" ,
            "payment_password":payment_password
            ]
        return  performRequest(url: url , method: HTTPMethod.post, parameters: para , print : print )
    }
    
    /// get jpush notification status
    @discardableResult
    func getNotificationStatus( _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/status"
        let  para = [
            "token" : DDAccount.share.token ?? ""
        ]
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    /// set jpush notification status
    
    @discardableResult
    func setNotificationStatus(push_status:String? ,push_shock:String?,push_voice:String? , _ print : Bool = false ) -> DataRequest? {
//        let url  =  "member/\(DDAccount.share.id ?? "")"
        let url  =  "member/\(DDAccount.share.id ?? "")/push"
        var  para = [
            "token" : DDAccount.share.token ?? ""
        ]
        if let pushStatus = push_status{para["push_status"] = pushStatus}
        if let pushShake = push_shock{para["push_shock"] = pushShake}
        if let pushVoice = push_voice{para["push_voice"] = pushVoice}
        return  performRequest(url: url , method: HTTPMethod.put, parameters: para , print : print )
    }
    /// get auth code
    /// type (1、注册 2、找回密码 3、其他)
    ///http://123.207.141.131/v1/verify
    @discardableResult
    func getAuthCode(type : String = "3" , mobile : String , _ print : Bool = false ) -> DataRequest? {
        let url  =  "verify"//
        let  para = ["token" : DDAccount.share.token ?? "" , "type" : type , "mobile" : mobile]
        
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    /// getOrderList
    ///
    /// - Parameters:
    ///   - type: 订单状态(-1放弃支付 0待支付 1待补交 2预付款已逾期 3已完成) 为空全部订单
    ///   - page: 页码
    ///   - print: whether print responst data
    /// - Returns: return value
    @discardableResult
    func getOrderList(type : String? , page : Int = 1 , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/order"
        var  para = ["token" : DDAccount.share.token ?? "" , "page" : "\(page)"]
//        var  para = ["token" : "e97d7946bb7ae016632ecdff7310262f" , "page" : "\(page)"]
        
        if let typeReal = type {para["type"] = typeReal}
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    @discardableResult
    func orderDetail(order_id : String , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/order/\(order_id)"
                var  para = ["token" : DDAccount.share.token ?? ""]
//        let para = ["token" : "e97d7946bb7ae016632ecdff7310262f" ]/// token要改
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    
    @discardableResult
    func tousuDuijieren(order_id : String ,complain_level: String , complain_content:String? , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/order/fcomplaint2"
        var  para = ["token" : DDAccount.share.token ?? "","complain_level":complain_level, "id" : order_id]
        if let content = complain_content{
            para["complain_content"] = content
        }
//        let para = ["token" : "e97d7946bb7ae016632ecdff7310262f" ]/// token要改
        return  performRequest(url: url , method: HTTPMethod.post, parameters: para , print : print )
    }
    
    
    
    
    
    
    
    
    /// getOrderList
    ///
    /// - Parameters:
    ///   - type: 订单状态(-1放弃支付 0待支付 1待补交 2预付款已逾期 3已完成) 为空全部订单
    ///   - page: 页码
    ///   - print: whether print responst data
    /// - Returns: return value
    @discardableResult
    func saleManGetOrderList(type : String? , page : Int = 1 , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/order"
        var  para = ["token" : DDAccount.share.token ?? "" , "page" : "\(page)" , "order_list" : "1"]
        //        var  para = ["token" : "e97d7946bb7ae016632ecdff7310262f" , "page" : "\(page)"]
        
        if let typeReal = type {para["type"] = typeReal}
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    @discardableResult
    func saleManOrderDetail(order_id : String , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/order/\(order_id)"
        var  para = ["token" : DDAccount.share.token ?? "", "order_list" : "1"]
        //        let para = ["token" : "e97d7946bb7ae016632ecdff7310262f" ]/// token要改
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    
    @discardableResult
    func saleManTousuDuijieren(order_id : String ,complain_level: String , complain_content:String? , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/order/fcomplaint"
        var  para = ["token" : DDAccount.share.token ?? "","complain_level":complain_level, "id" : order_id]
        if let content = complain_content{
            para["complain_content"] = content
        }
        //        let para = ["token" : "e97d7946bb7ae016632ecdff7310262f" ]/// token要改
        return  performRequest(url: url , method: HTTPMethod.post, parameters: para , print : print )
    }
    
    @discardableResult
    func changeSentTime(order_id : String ,start_at: String , end_at:String? , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/orderdata/\(order_id)"
        var  para = ["token" : DDAccount.share.token ?? "","start_at":start_at, "order_id" : order_id]
        if let end = end_at{
            para["end_at"] = end
        }
        return  performRequest(url: url , method: HTTPMethod.put, parameters: para , print : print )
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @discardableResult
    func tousuHezuoren(order_id : String ,complain_level: String , complain_content:String? , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/order/fcomplaint3"
        var  para = ["token" : DDAccount.share.token ?? "","complain_level":complain_level, "id" : order_id]
        if let content = complain_content{
            para["complain_content"] = content
        }
        //        let para = ["token" : "e97d7946bb7ae016632ecdff7310262f" ]/// token要改
        return  performRequest(url: url , method: HTTPMethod.post, parameters: para , print : print )
    }
    
    @discardableResult
    func canclePay(order_id : String ,cancleRease: String , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/ordercannel"
        var  para = ["token" : DDAccount.share.token ?? "","cancel_cause":cancleRease, "order_id" : order_id]
        //        let para = ["token" : "e97d7946bb7ae016632ecdff7310262f" ]/// token要改
        return  performRequest(url: url , method: HTTPMethod.put, parameters: para , print : print )
    }
    
    
    
    @discardableResult
    func orderSelectedArea(order_id : String ,parent_id : String? , _ print : Bool = false ) -> DataRequest? {
        let url  =  "member/\(DDAccount.share.id ?? "")/order/\(order_id)/area"
        var  para = ["token" : DDAccount.share.token ?? "" ]
        if let parentID = parent_id {
            para["parent_id"] = parentID
        }
//        let para = ["token" : "e97d7946bb7ae016632ecdff7310262f" ]/// token要改
        return  performRequest(url: url , method: HTTPMethod.get, parameters: para , print : print )
    }
    
    /// request sign
    private func requestTencentSign( _ print : Bool = false ) -> DataRequest? {
        let url  =  "qcloud"
        let  para = [ "token": DDAccount.share.token ?? "" ]
        return performRequest(url: url , method: HTTPMethod.get, parameters: para, print : print )
    }
    
    
    /*
     let tenxunAppid = "1252043302"
     let tenxunAppKey = "2ae4806abe0f1ae393564456ff1130b5"
     let bukey: String = "hilao"
     let regin: String = "bj"
     http://api.hilao.cc/index/getTencentObjectStorageSignature
     post
     */
    func uploadMediaToTencentYun(image:UIImage ,progressHandler:@escaping ( Int,  Int, Int)->(),compateHandler : @escaping (_ imageUrl:String?)->())  {
        let docuPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        if let realDocuPath = docuPath  {
            var fileNameInServer = "\(Date().timeIntervalSince1970 )"
            if fileNameInServer.contains("."){
                if let index = fileNameInServer.index(of: "."){
                    fileNameInServer.remove(at: index)
                }
            }
            let filePath = realDocuPath + "/\(fileNameInServer).png"
            let filePathUrl = URL(fileURLWithPath: filePath, isDirectory: true )
            do{
                let _ = try UIImageJPEGRepresentation(image, 0.5)?.write(to: filePathUrl)
                self.requestTencentSign(true)?.responseJSON(completionHandler: { (response) in
                    guard  let dict =  response.value as? [String:String] else{
                        compateHandler(nil); return}
                    let signStr = dict["token"]
                    let uploadTask = COSObjectPutTask.init(path: filePath, sign: signStr, bucket: "yulongchuanmei", fileName: fileNameInServer, customAttribute: "temp", uploadDirectory: nil, insertOnly: true)
                    
                    self.client?.completionHandler = {(/*COSTaskRsp **/resp, /*NSDictionary */context) in
                        try? FileManager.default.removeItem(atPath: filePath)
                        if let  resp = resp as? COSObjectUploadTaskRsp{
//                            mylog(context)
//                            mylog(resp.descMsg)
//                            mylog(resp.fileData)
//
                            mylog(resp.data)
//                            mylog(resp.sourceURL)//发给服务器
//                            mylog(resp.httpsURL)
//                            mylog(resp.objectURL)
                            
                            if (resp.retCode == 0) {
                                //sucess
                                compateHandler(resp.sourceURL)
                            }else{
                                
                                compateHandler(nil)
                                GDAlertView.alert("图片上传失败", image: nil, time: 1, complateBlock: nil)
                            }
                        }
                    };
                    self.client?.progressHandler = {( bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                        progressHandler(Int(bytesWritten), Int(totalBytesWritten), Int(totalBytesExpectedToWrite))
                        mylog("\(bytesWritten)---\(totalBytesWritten)---\(totalBytesExpectedToWrite)")
                        //progress
                    }
                    self.client?.putObject(uploadTask)
                    
                    
                })
                
               
                
                
            }catch{
                mylog(error)
                compateHandler(nil)
            }
            
//            let filePath = realDocuPath.append//appendingPathComponent("Account.data")
        }
    }
    
    
    
    
    
    
    /// untie bank card
    func untieBankCard2(bankID : String ,  print : Bool = false  ) -> DataRequest? {
        if let status = NetworkReachabilityManager(host: "www.baidu.com")?.networkReachabilityStatus{
            switch status {
            case .notReachable:
                GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
                return nil
            case .unknown :
                GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
                return nil
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
                break
            case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                break
            }
        }
        
        
        let parameters = ["token" : DDAccount.share.token ?? "" ]
        let url = (DomainType.release.rawValue + version) + "member/\(DDAccount.share.id ?? "")/bank/\(bankID)"
        if let url  = URL(string: url){
            let result = Alamofire.request(url , method: HTTPMethod.delete , parameters: parameters ).responseJSON(completionHandler: { (response) in
                if print{mylog(response.debugDescription.unicodeStr)}
                switch response.result{
                case .success :
                    break
                    
                case .failure :
                    mylog(response.debugDescription.unicodeStr)
                    GDAlertView.alert("请求超时,请重试", image: nil , time: 2, complateBlock: nil )//请求超时处理
                    break
                }
            })
            return result
            
            //                .responseJSON(completionHandler: { (response) in
            //                mylog(String.init(data: response.data ?? Data(), encoding: String.Encoding.utf8))
            //                mylog("print request result -->:\(response.result)")
            //                "xx".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
            //                let testOriginalStr = "http://www.hailao.com/你好世界"
            //                let urlEncode = testOriginalStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
            //                let urlDecodeStr = urlEncode?.removingPercentEncoding
            //                mylog("encode : \(urlEncode)")
            //                mylog("decode : \(urlDecodeStr)")
            //
            //                let tt = "\\U751f\\U6210key\\U6210\\U529f"
            ////                mylog("tttt\(tt.u)")
            //            })
        }else{return nil }
    }
    
    
    
    
}


extension DDRequestManager{
    func test () {
        
        result.session.configuration.timeoutIntervalForRequest = 5
        result.request(URL(string:"http://api.hailao.cc/index/index")!, method: HTTPMethod.post, parameters: ["hi":"lao"] , headers: HTTPHeaders()).responseJSON { (response) in
            switch response.result{
            case .success :
                break
                
            case .failure :
                GDAlertView.alert("error", image: nil , time: 2, complateBlock: nil )//请求超时处理
                dump(response)
                break
            }
            
        }
        
    }
}







class PHPRequestManager : NSObject, URLSessionDelegate{
    static let share = PHPRequestManager()
    var sessiono : URLSession?
    func test() {
        let url = URL(string: "https://wy.local/test1.php?key1=2&key2=4")!
        let request = NSMutableURLRequest(url: url )
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let params
        
        var  session1 = URLSession(configuration: URLSessionConfiguration.default, delegate: self , delegateQueue: OperationQueue.main)
        self.sessiono = session1
        let dataTask = session1.dataTask(with: url) { (data , response , error ) in
            let result = String.init(data: data! , encoding:
                String.Encoding.utf8)
            mylog(result )
            mylog("\(data )--\(response)--\(error )")
        }
//        let dataTask = session1.dataTask(with: request){ (data , response , error ) in
//            mylog("\(data )--\(response)--\(error )")
//        }
        dataTask.resume()
    }
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void){
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let card = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential , card )
        }
    }
}
