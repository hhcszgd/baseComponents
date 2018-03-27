//
//  UpPayVC.swift
//  Project
//
//  Created by 张凯强 on 2018/3/19.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class UpPayVC: DDNormalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let dict = self.userInfo as? [String: String], let result = dict["result"] {
            switch result {
                ///线下支付成功
            case "underSuccess":
                guard let order = dict["order"] else {
                    return
                }
                let containerView = UnderPayResultView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight))
                self.view.addSubview(containerView)
                containerView.checkOrderDetail.subscribe(onNext: { (result) in
                    if let vc  =  self.navigationController?.popToSpecifyVC(DDOrderDetailVC.self , animate: true ){
                        vc.viewDidLoad()
                    }else{
                        let temp  =  DDOrderListVC()
                        let temp2 = DDOrderDetailVC()
                        temp2.userInfo = order
                        if let _ = self.navigationController?.childViewControllers.first as? DDItem4VC{
                            self.navigationController?.pushViewController(temp , animated: false    )
                        }
                        self.navigationController?.pushViewController(temp2     , animated: false )
                        
                    }
                    
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            case "upSuccess":
                guard let order = dict["orderID"] else {
                    return
                }
                let containerView = UpPaySuccessView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight))
                self.view.addSubview(containerView)
                containerView.checkOrderDetail.subscribe(onNext: { (result) in
                    self.pushVC(vcIdentifier: "DDOrderDetailVC", userInfo: order)
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            case "upFailure":
                let containerView = UpPayFailureVIew.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight))
                self.view.addSubview(containerView)
                containerView.placeAnOrder.subscribe(onNext: { (result) in
                    
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            default:
                break
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
