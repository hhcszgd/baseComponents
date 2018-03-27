//
//  NetWork.swift
//  RxSwiftLearn
//
//  Created by 张凯强 on 2017/9/29.
//  Copyright © 2017年 张凯强. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
enum BaseUrlStr: String {
    case member = "http://member.hilao.cc/passport/"
    case memberNoPassPort = "http://member.hilao.cc/"
    case apiLogin = "http://tpi.hilao.dev/login/"
    case api = "http://tpi.bjyltf.com/v1/"
    case apicc = "http://api.bjyltf.cc/v1/"
//    "http://123.207.141.131/v1/" // "http://api.bjyltf.cc/v1/" “tpi.bjyltf.com”
    case apiMember = "http://api.hilao.dev/member/"
    case interactive = "http://interactive.hilao.cc/"
    case shopShopExamine = "http://shop.hilao.cc/Shopexamine/"
    case web = "http://tap.bjyltf.com/agreement/"
    
}


enum Router: URLRequestConvertible {
    ///get请求
    case get(String, BaseUrlStr, [String: Any]?)
    ///post请求
    case post(String, BaseUrlStr, [String: Any]?)
    
    case put(String, BaseUrlStr, [String: Any]?)
    
    ///URLRequestConvertible 代理方法
    func asURLRequest() throws -> URLRequest {
        ///请求方式
        var method: HTTPMethod {
            switch self {
            case .get:
                return HTTPMethod.get
            case .post:
                return HTTPMethod.post
            case .put:
                return HTTPMethod.put
            }
        }
        ///请求参数
        var params: [String: Any]? {
            switch self {
            case let .get(_, _, dict):
                return dict
            case let .post(_, _, dict):
               return dict
            case let .put(_, _, dict):
                return dict
                
            }
            
        }
        ///请求的网址
        var url: URL {
            var URLStr: String = ""
            switch self {
            case let .get(urlStr, baseUrl, _):
                URLStr = baseUrl.rawValue + urlStr
            case let .post(urlStr, baseUrl, _):
                URLStr = baseUrl.rawValue + urlStr
            case let .put(urlStr, baseUrl, _):
                URLStr = baseUrl.rawValue + urlStr
            }
            
            
            let url = URL.init(string: URLStr)
            return url!
            
            
            
        }
        var request = URLRequest.init(url: url)
        request.httpMethod = method.rawValue
        
        let encoding = URLEncoding.default
        return try encoding.encode(request, with: params)
    }

    
    
    
    
}
enum NetWorkStatus {
    ///不清楚
    case unknow
    ///蜂窝数据
    case wwan
    ///wifi
    case wifi
    ///不可达
    case notReachable
}

enum NetWorkError: Error {
    ///数据格式错误
    case formatError
    ///已经初始化
    case repeadInit
    ///没有连接到网络
    case notReachable
}
class NetWork {
    static let manager = NetWork.init()
    private init() {
        
    }
    
    func requestData(router: Router) -> Observable<[String: AnyObject]> {
        return Observable<[String: AnyObject]>.create({ [weak self](observer) -> Disposable in
            //数据处理
            mylog(router)
            if let status = NetworkReachabilityManager.init(host: "www.baidu.com")?.networkReachabilityStatus {
                switch status {
                case .notReachable, .unknown:
                    GDAlertView.alert("连接失败,请检查网络后重试", image: nil, time: 3, complateBlock: nil )
                    observer.onError(NetWorkError.notReachable)
                    return Disposables.create()
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi), .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                    break
                default:
                    break
                
                }
            }
            let request = Alamofire.request(router).responseJSON(completionHandler: { (result) in
                mylog(result)
                switch result.result {
                case .success(let value):
                    
                    guard let dict = value as? [String: AnyObject] else {
                        observer.onError(NetWorkError.formatError)
                        return
                    }
                    mylog(dict)
                
                    observer.onNext(dict)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            })
            
            
            return Disposables.create {
                request.cancel()
            }
            
            
            
        })
    }
   
    
}


//var appid: String {
//    get {
//        if let result = UserDefaults.standard.value(forKey: APPID) as? String, result.characters.count > 0 {
//            return result
//            
//        }else {
//            return "nil"
//        }
//    }
//}

