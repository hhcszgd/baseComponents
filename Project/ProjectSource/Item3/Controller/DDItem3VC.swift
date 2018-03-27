//
//  DDItem3VC.swift
//  ZDLao
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
let mainColor = UIColor.colorWithHexStringSwift("fe5f5f")
class DDItem3VC: GDNormalVC {

    let viewModel = ProfileViewModel()
    
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    
    @IBOutlet var jobNumber: UILabel!
    
    @IBOutlet var mobile: UILabel!
    
    @IBOutlet var containerTop: NSLayoutConstraint!
    
    @IBOutlet var headerTop: NSLayoutConstraint!
    @IBOutlet var scrollBottom: NSLayoutConstraint!
    @IBOutlet var verifiediconImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        18500971054
        self.userImage.layer.masksToBounds = true
        self.userImage.layer.cornerRadius = 30
        self.naviBar.title = "我的"
        self.naviBar.showLineview = true
        self.naviBar.backgroundColor = UIColor.white
        
    }
    func login() {
        let loginVC = LoginVC()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    let upload = UploadPicturesTool.init()
    @IBAction func uploadPicture(_ sender: Any) {
        if !DDAccount.share.isLogin {
            self.login()
            return
        }
        upload.current = self
        upload.changeHeadPortrait()
        upload.finished = { (image) in
            if let img = image {
                DDRequestManager.share.uploadMediaToTencentYun(image: img, progressHandler: { (a, b, c) in
                    
                }, compateHandler: { (imageStr) in
                    mylog(imageStr)
                    DDAccount.share.avatar = imageStr
                    DDAccount.share.save()
                    
                    self.userImage.sd_setImage(with: imgStrConvertToUrl(imageStr ?? ""))
                    let id = DDAccount.share.id ?? "0"
                    let token = DDAccount.share.token ?? ""
                    let image = imageStr ?? ""
                    let paramete = ["token": token, "avatar": image]
                    NetWork.manager.requestData(router: Router.put("member/\(id)", .api, paramete)).subscribe(onNext: { (dict) in
                        let model = BaseModel<GDModel>.deserialize(from: dict)
                        if model?.status == 200 {
                            GDAlertView.alert("上传成功", image: nil, time: 1, complateBlock: nil)
                        }
                    }, onError: { (error) in
                        
                    }, onCompleted: {
                        
                    }, onDisposed: {
                        
                    })
                    
                })
            }
            
        }
        
        
    }
    override func gdAddSubViews () {
        self.headerTop.constant = DDNavigationBarHeight
        self.scrollBottom.constant = DDTabBarHeight
        self.view.layoutIfNeeded()
    }
    
    @IBAction func dingdanAction(_ sender: UITapGestureRecognizer) {
        
        self.pushVC(vcIdentifier: "DDOrderListVC", userInfo: nil)
        
    }
    
    @IBAction func editAction(_ sender: UITapGestureRecognizer) {
        if !DDAccount.share.isLogin {
            self.login()
            return
        }
        let vc = EditInfoVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    @IBAction func opinionTap(_ sender: UITapGestureRecognizer) {
        if !DDAccount.share.isLogin {
            self.login()
            return
        }
        let vc = OpinionVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func areaTapAction(_ sender: UITapGestureRecognizer) {
        if !DDAccount.share.isLogin {
            self.login()
            return
        }
        let vc = MyArea()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func protocolTapAction(_ sender: UITapGestureRecognizer) {
       let about = AboutVC()
        self.navigationController?.pushViewController(about, animated: true)
        
        
    }
    @IBAction func setTapAction(_ sender: UITapGestureRecognizer) {
        let set = SetVC()
        self.navigationController?.pushViewController(set, animated: true)
    }
    
    
    
    @IBAction func judgeAction(_ sender: UITapGestureRecognizer) {
        let vc = JudgeVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @objc func uploadPicture(tap: UITapGestureRecognizer) {
        upload.viewController = self
        upload.changeHeadPortrait()
    }

    func request() {
        let id = DDAccount.share.id ?? "0"
        NetWork.manager.requestData(router: Router.get("member/\(id)", .api, ["token": DDAccount.share.token ?? ""])).subscribe(onNext: { (dict) in
            let model = BaseModel<DDAccount>.deserialize(from: dict)
            
            if let data = model?.data {
                DDAccount.share.setPropertisOfShareBy(otherAccount: data)
                self.userName.text = data.name ?? ""
//                let jobNumberStr = data.number ?? ""
//                self.jobNumber.text = "工号：" + jobNumberStr
                let mobileStr = data.mobile ?? ""
                self.mobile.text = "电话：" + mobileStr
                let imageStr = data.head_images ?? ""
                self.userImage.sd_setImage(with: imgStrConvertToUrl(imageStr))
                
            }
        }, onError: { (error) in
            if let networkError = error as? NetWorkError, networkError == NetWorkError.notReachable  {
                
            }else {
                
            }
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.request()
        if DDAccount.share.examineStatus == "1" {
            self.verifiediconImage.isHidden = false
        }else {
            self.verifiediconImage.isHidden = true
        }
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    
    
    
}
