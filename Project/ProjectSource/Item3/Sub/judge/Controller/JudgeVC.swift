//
//  JudgeVC.swift
//  Project
//
//  Created by 张凯强 on 2018/1/25.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class JudgeVC: GDNormalVC {

    @IBOutlet var top: NSLayoutConstraint!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var nameValue: UILabel!
    @IBOutlet var sexValue: UILabel!
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var idPictureLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var stattusImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.title = "身份认证"
        self.view.backgroundColor = UIColor.colorWithRGB(red: 230, green: 230, blue: 230)
        self.top.constant = DDNavigationBarHeight + 20
        self.view.layoutIfNeeded()
        self.userImage.layer.masksToBounds = true
        self.userImage.layer.cornerRadius = (24.0 / 69.0) * (SCREENWIDTH - 30) * 0.5 * 0.5
        self.userImage.sd_setImage(with: imgStrConvertToUrl(DDAccount.share.avatar ?? ""), completed: nil)
        self.naviBar.backgroundColor = UIColor.white
        self.userImage.sd_setImage(with: imgStrConvertToUrl(DDAccount.share.avatar ?? ""))
        
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet var statusBtn: UIButton!
    @IBAction func statusAction(_ sender: UIButton) {
        if (self.account?.examineStatus == "-1") || (self.account?.examineStatus == "2") || (self.account?.examineDesc == nil) {
            let id = IDVC()
            id.sex = self.account?.sex ?? "0"
            id.name = self.account?.name ?? ""
            id.id = self.account?.idNumber ?? ""
            self.navigationController?.pushViewController(id, animated: true)
            
            
        }
    }
    
    let redColor = UIColor.colorWithHexStringSwift("ea6e61")
    let blackColor = UIColor.colorWithHexStringSwift("333333")
    func requestGet() {
        let token: String = DDAccount.share.token ?? ""
        let memberID: String = DDAccount.share.id ?? ""
        
        var paramete: [String: Any] = ["token": token]
        NetWork.manager.requestData(router: Router.get("member/\(memberID)/id", .api, paramete)).subscribe(onNext: { (dict) in
            let model = BaseModel<DDAccount>.deserialize(from: dict)
            if model?.status == 200 {
                if let data = model?.data {
                    DDAccount.share.setPropertisOfShareBy(otherAccount: data)
                    self.account = data
                    if let name = data.name, name.count > 0 {
                        self.nameValue.text = name
                        self.nameValue.textColor = self.blackColor
                    }else {
                        self.nameValue.textColor = self.redColor
                        self.nameValue.text = "未完善"
                    }
                    if let idNumber = data.idNumber, idNumber.count >= 18 {
                        let prefix: String = NSString.init(string: idNumber).substring(to: 4)
                        let sub: String = NSString.init(string: idNumber).substring(from: 14)

                        let id = prefix + "**********" + sub
                        self.idLabel.text = id
                        self.idLabel.textColor = self.blackColor
                    }else {
                        self.idLabel.text = "未完善"
                        self.idLabel.textColor = self.redColor
                    }
                    if let sex = data.sex, sex.count > 0 {
                        if sex == "1" {
                            self.sexValue.text = "男"
                        }
                        if sex == "2" {
                            self.sexValue.text = "女"
                        }
                        self.sexValue.textColor = self.blackColor
                        if sex == "0" {
                            self.sexValue.text = "未完善"
                            self.sexValue.textColor = self.redColor

                        }

                    }else {
                        self.sexValue.text = "未完善"
                        self.sexValue.textColor = self.redColor
                    }

                    if let idback = data.idBackImage, idback.count > 0, let idfont = data.idFrontImage, idfont.count > 0, let idhand = data.idHandImage, idhand.count > 0 {
                        
                        self.idPictureLabel.text = "已完善"
                        self.idPictureLabel.textColor = self.blackColor
                    }else {
                        self.idPictureLabel.text = "未完善"
                        self.idPictureLabel.textColor = self.redColor
                    }
                    var status: String = ""
                    switch (data.examineStatus ?? "") {
                    case "-1":
                        status = "进行身份认证"
                        self.descLabel.text = ""
                    case "0":
                        status = "身份待审核"
                        self.descLabel.text = ""
                    case "1":
                        status = "身份已认证"
                        self.descLabel.text = ""
                    case "2":
                        status = "重新认证"
                        self.descLabel.text = "资料审核不通过，请重新认证"
                    default:
                        break
                    }
                    self.statusBtn.setTitle(status, for: .normal)
                    
                }else {
                    self.statusBtn.setTitle("待认证", for: .normal)
                    self.nameValue.text = "未完善"
                    self.sexValue.text = "未完善"
                    self.idLabel.text = "未完善"
                    self.idPictureLabel.text = "待完善"
                    
                }
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    var account: DDAccount?


    override func gdAddSubViews() {
        
    }
    @IBAction func userImageTapAction(_ sender: UITapGestureRecognizer) {
    }
    @IBAction func nameTapAction(_ sender: UITapGestureRecognizer) {
    }
    
    @IBAction func sexTapAction(_ sender: UITapGestureRecognizer) {
    }
    @IBAction func idTapAction(_ sender: UITapGestureRecognizer) {
    }
    @IBAction func idPictureTapAction(_ sender: UITapGestureRecognizer) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestGet()
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
