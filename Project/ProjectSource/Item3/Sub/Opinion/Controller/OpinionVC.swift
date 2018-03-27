//
//  OpinionVC.swift
//  Project
//
//  Created by 张凯强 on 2018/1/15.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class OpinionVC: GDNormalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func gdAddSubViews() {
        self.scrollTop.constant = DDNavigationBarHeight
        self.top.constant = 15
        self.view.layoutIfNeeded()
        
        self.textView.rx.didBeginEditing.subscribe { (_) in
            self.placeholder1.isHidden = true
            self.subTextView.resignFirstResponder()
        }
        self.textView.rx.didEndEditing.subscribe { (_) in
            if self.textView.text.count <= 0 {
                self.placeholder1.isHidden = false
            }
        }
        
        self.subTextView.rx.didBeginEditing.subscribe { (_) in
            self.textView.resignFirstResponder()
            self.placeholder2.isHidden = true
        }
        self.subTextView.rx.didEndEditing.subscribe { (_) in
            if self.subTextView.text.count <= 0 {
                self.placeholder2.isHidden = false
            }
        }
        self.naviBar.title = "意见栏"
    }
    @IBOutlet var scrollTop: NSLayoutConstraint!
    @IBOutlet var top: NSLayoutConstraint!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textView: UITextView!
    
    @IBOutlet var placeholder1: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var subTextView: UITextView!
    @IBOutlet var placeholder2: UILabel!
    
    @IBOutlet var finidhedBtn: UIButton!
    @IBAction func finishededBtnAction(_ sender: UIButton) {
        let question = self.textView.text ?? ""
        let content = self.subTextView.text ?? ""
        let paramete = ["token": (DDAccount.share.token ?? ""), "question": question, "content": content]
        NetWork.manager.requestData(router: Router.post("feedback", .api, paramete)).subscribe(onNext: { (dict) in
            let model = BaseModel<GDModel>.deserialize(from: dict)
            if model?.status == 200 {
                self.isUpload = true
                GDAlertView.alert("您的意见已成功提交， 感谢您的支持与配合", image: nil, time: 1, complateBlock: {
                    self.navigationController?.popViewController(animated: true)
                })
                
            }else {
                let view =  MyAreaAlertView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT), title: "您的意见提交失败请重新提交", type: MyAreaAlertType.alertThree)
                view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                self.view.addSubview(view)
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        

        
    }
    var isUpload: Bool = false
    override func popToPreviousVC() {
        if !self.isUpload {
            let view =  MyAreaAlertView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT), title: "您的意见还未提交，退出不可保存", type: MyAreaAlertType.alertTwo)
            view.cancleBtn.setTitle("取消", for: .normal)
            view.sureBtn.setTitle("确定", for: .normal)
            view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.view.addSubview(view)
            view.finished.subscribe(onNext: { [weak self](type) in
                if type != 0 {
                    self?.navigationController?.popViewController(animated: true)
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        }
      
        
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
