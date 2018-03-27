//
//  IDPictureVC.swift
//  Project
//
//  Created by 张凯强 on 2018/1/14.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
class IDPictureVC: GDNormalVC {
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var maskView1: UIView!
    @IBOutlet var progressLabel1: UILabel!
    
    @IBOutlet var loadImage1: UIImageView!
    
    @IBOutlet var maskView2: UIView!
    
    @IBOutlet var progresslabel2: UILabel!
    
    @IBOutlet var loadImage2: UIImageView!
    
    @IBOutlet var maskView3: UIView!
    @IBOutlet var progressLabel3: UILabel!
    @IBOutlet var loadImage3: UIImageView!
    
    
    
    
    @IBOutlet var fullFacePhoto: UIImageView!
    @IBOutlet var addFullFacePhotoBtn: AddIDBtn!
    let upload = UploadPicturesTool.init()
    @IBAction func addFullFacePhotoAction(_ sender: AddIDBtn) {
        
        upload.current = self
        upload.changeHeadPortrait()
        
        upload.finished = { (image) in
            self.maskView1.isHidden = false
            if let img = image {
                DDRequestManager.share.uploadMediaToTencentYun(image: img, progressHandler: { (a, b, c) in
                    let progress = Int(CGFloat(b) / CGFloat(a) * 100)
                    self.progressLabel1.text = String(progress) + "%"
                    
                }, compateHandler: { (imageStr) in
                    if imageStr != nil {
                        sender.isHidden = true
                    }
                    
                    self.fullFace = imageStr ?? ""
                    
                    self.fullFacePhoto.sd_setImage(with: imgStrConvertToUrl(imageStr ?? ""), placeholderImage: DDPlaceholderImage, options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed])
                    self.maskView1.isHidden = true
                    
                })
            }
            
        }
        
    }
    
    var fullFace: String = ""
    @IBOutlet var backsidePhoto: UIImageView!
    @IBOutlet var backSidePhotoBtn: AddIDBtn!
    @IBAction func backSidePhotoAction(_ sender: AddIDBtn) {
        upload.current = self
        upload.changeHeadPortrait()
        upload.finished = { (image) in
            self.maskView2.isHidden = false
            if let img = image {
                DDRequestManager.share.uploadMediaToTencentYun(image: img, progressHandler: { (a, b, c) in
                    let progress = Int(CGFloat(b) / CGFloat(a) * 100)
                    self.progresslabel2.text = String(progress) + "%"
                }, compateHandler: { (imageStr) in
                    if imageStr != nil {
                        sender.isHidden = true
                    }
                    
                    self.maskView2.isHidden = true
                    self.backsideImage = imageStr ?? ""
                    self.backsidePhoto.sd_setImage(with: imgStrConvertToUrl(imageStr ?? ""), placeholderImage: DDPlaceholderImage, options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed])
                    
                   
                    
                })
            }
            
        }
    }
    var backsideImage: String = ""
    @IBOutlet var peoplePhone: UIImageView!
    
    @IBAction func peoplePhoneAction(_ sender: AddIDBtn) {
        
        upload.current = self
        upload.changeHeadPortrait()
        upload.finished = { (image) in
            self.maskView3.isHidden = false
            if let img = image {
                
                DDRequestManager.share.uploadMediaToTencentYun(image: img, progressHandler: { (a, b, c) in
                    let progress = Int(CGFloat(b) / CGFloat(a) * 100)
                    self.progressLabel3.text = String(progress) + "%"
                }, compateHandler: { (imageStr) in
                    if imageStr != nil {
                        sender.isHidden = true
                    }
                    self.maskView3.isHidden = true
                    self.peopleImage = imageStr ?? ""
                    self.peoplePhone.sd_setImage(with: imgStrConvertToUrl(imageStr ?? ""), placeholderImage: DDPlaceholderImage, options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed])
                    
                    
                })
            }
            
        }
    }
    var peopleImage: String = ""
    @IBOutlet var finishedBtn: UIButton!
    var name: String = ""
    var sex: String = "1"
    @IBAction func finidhedAction(_ sender: UIButton) {
        
       
        
        let id = DDAccount.share.id ?? "0"
        let token = DDAccount.share.token ?? ""
        let paramete = ["token": token, "id_number": self.idNumber, "id_front_image": self.fullFace, "id_back_image": self.backsideImage, "id_hand_image": self.peopleImage, "sex": self.sex, "name": self.name]
        NetWork.manager.requestData(router: Router.put("member/\(id)/id", .api, paramete)).subscribe(onNext: { (dict) in
            let model = BaseModel<GDModel>.deserialize(from: dict)
            if model?.status == 200 {
                GDAlertView.alert("上传成功", image: nil, time: 1, complateBlock: nil)
                DDAccount.share.idNumber = self.idNumber
                DDAccount.share.save()
                self.navigationController?.viewControllers.remove(at: (self.navigationController?.viewControllers.count)! - 2)
                self.navigationController?.popViewController(animated: true)
            }
        }, onError: { (error) in

        }, onCompleted: {

        }, onDisposed: {

        })
        
        
        
        
    }
    @IBOutlet var top: NSLayoutConstraint!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.top.constant = DDNavigationBarHeight 
        self.view.layoutIfNeeded()
        // Do any additional setup after loading the view.
    }
    override func gdAddSubViews() {
        
    }
    var idNumber: String = ""
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
