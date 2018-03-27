//
//  ContactAddress.swift
//  Project
//
//  Created by 张凯强 on 2018/1/15.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ContactAddress: GDNormalVC {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var addressDetail: CustomTextfield!
    @IBOutlet var btn: UIButton!
    
    @IBAction func btnAction(_ sender: UIButton) {
        if !juedgeAddressDetail(address: (self.addressStr + self.detailAddress)) {
            GDAlertView.alert("地址限制在15字之内", image: nil, time: 1, complateBlock: nil)
            return
        }
        let paramete = ["token": DDAccount.share.token ?? "", "address":  (self.addressStr + self.detailAddress)]
        let memberid = DDAccount.share.id ?? "0"
        NetWork.manager.requestData(router: Router.put("member/\(memberid)/basic", .api, paramete)).subscribe(onNext: { (dict) in
            let model = BaseModel<GDModel>.deserialize(from: dict)
            if model?.status == 200 {
                DDAccount.share.address = self.addressStr + self.detailAddress
                DDAccount.share.save()
                self.navigationController?.popViewController(animated: true)
            }
        }, onError: { (error) in
            mylog(error)
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
        
        
        
        
        
    }
    
    func juedgeAddressDetail(address: String) -> Bool {
        let regex = "^[a-zA-Z0-9\\u4e00-\\u9fa5]{0,15}$"
        let regextext = NSPredicate.init(format: "SELF MATCHES %@", regex)
        let result: Bool = regextext.evaluate(with: address)
        if result {
            return true
        }else {
            return false
        }
    }
    
    var detailAddress: String = ""
    @IBAction func action(_ sender: UITapGestureRecognizer) {
        sender.view?.isUserInteractionEnabled = false
        let frame = CGRect.init(x: 0, y: SCREENHEIGHT - 400 - TabBarHeight, width: SCREENWIDTH, height: 400)
        let view = AreaSelectView.init(frame: frame, title: "jj", type: 100, url: "area", subFrame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        self.view.addSubview(view)
        
        view.finished.subscribe(onNext: { [weak self](address, id) in
            self?.addressStr = address
            self?.area = Int(id) ?? 0
            self?.address.text = address
            sender.view?.isUserInteractionEnabled = true
            view.removeFromSuperview()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
    }
    
    var addressStr: String = ""
    var area: Int = 0
    @IBOutlet var top: NSLayoutConstraint!
    
    func createEnterAlertView(title: String?, type: EnterAlertViewStyle, selectTitle: String?, result: @escaping (String) -> ()) {
        let view = EnterAlertView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT), title: title, alertStyle: type)
        view.selectTitle = selectTitle
        view.selectFinished = result
        self.view.addSubview(view)
        let oldTransform = view.backView.transform
        view.backView.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
        UIView.animate(withDuration: 0.4, animations: {
            view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            view.backView.transform = oldTransform
        }) { (finished) in
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.top.constant = DDNavigationBarHeight + 60
        self.view.layoutIfNeeded()
        // Do any additional setup after loading the view.
    }
    override func gdAddSubViews() {
        self.addressDetail.rx.text.orEmpty.subscribe(onNext: { (address) in
            self.detailAddress = address
        }, onError: nil, onCompleted: nil, onDisposed: nil)
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
