//
//  IDVC.swift
//  Project
//
//  Created by 张凯强 on 2018/1/14.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class IDVC: GDNormalVC {

    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var subtitleLabel: UILabel!
    
    @IBOutlet var textfield: CustomTextfield!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var top: NSLayoutConstraint!
    
    @IBOutlet var nameTextfield: CustomTextfield!
    
    @IBOutlet var sexLabel: UILabel!
    @IBAction func nextBtnAction(_ sender: UIButton) {
        
        if !self.judgeIdentityStringValid(id: self.id) {
            GDAlertView.alert("身份证号格式不对", image: nil, time: 1, complateBlock: nil)
            return
        }
        
        if sex == "0" {
            GDAlertView.alert("没有选择性别", image: nil, time: 1, complateBlock: nil)
            return
        }
        if !self.nameLawful(name: self.name) {
            GDAlertView.alert("姓名格式不对", image: nil, time: 1, complateBlock: nil)
            return
        }
        
        let addID = IDPictureVC()
        addID.idNumber = self.id
        addID.name = self.name
        addID.sex = self.sex
        self.navigationController?.pushViewController(addID, animated: true)
        
    }
    override func gdAddSubViews() {
        
    }
    var sex: String = "0"
    var name: String = ""
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.top.constant = DDNavigationBarHeight + 60
        self.view.layoutIfNeeded()
        self.textfield.text = self.id
        self.textfield.rx.text.orEmpty.subscribe(onNext: { (text) in
            self.id = text
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.nameTextfield.text = self.name
        self.nameTextfield.rx.text.orEmpty.subscribe(onNext: { (text) in
            self.name = text
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        switch self.sex {
        case "0":
            self.sexLabel.text = "未填写"
        case "1":
            self.sexLabel.text = "男"
        case "2":
            self.sexLabel.text = "女"
        default:
            break
        }
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    var selecrSex: IDSelectSexView?
    @IBAction func sexAction(_ sender: UITapGestureRecognizer) {
        self.nameTextfield.resignFirstResponder()
        self.textfield.resignFirstResponder()
        let sex: IDSelectSexView  = IDSelectSexView.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENHEIGHT), array: ["男", "女"])
        
        self.view.addSubview(sex)
        self.selecrSex = sex
        sex.finished.subscribe(onNext: { [weak self](type) in
            if type == 1 {
                self?.sex = "1"
                self?.sexLabel.text = "男"
            }else
            if type == 2 {
                self?.sex = "2"
                self?.sexLabel.text = "女"
            }else {
                self?.sex = "0"
            }
            
            
        }, onError: nil, onCompleted: {[weak self] () in
            self?.selecrSex?.removeFromSuperview()
            self?.selecrSex = nil
            }, onDisposed: {
                
        })
        UIView.animate(withDuration: 0.3, animations: {
            sex.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        }) { (finised) in
            
        }
        
        
        
        
    }
    func nameLawful(name: String) -> Bool {
        let nnn = "^[\\u4e00-\\u9fa5]{2,6}$"
        let regextext = NSPredicate.init(format: "SELF MATCHES %@", nnn)
        let result: Bool = regextext.evaluate(with: name)
        if result {
            return true
        }else {
            return false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func judgeIdentityStringValid(id: String) -> Bool {
        if (id.count != 18) {
            return false
        }
        // 正则表达式判断基本 身份证号是否满足格式
        let regex = "^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";

        let identityStringPredicate = NSPredicate.init(format: "SELF MATCHES %@", regex)
        //如果通过该验证，说明身份证格式正确，但准确性还需计算
        if identityStringPredicate.evaluate(with: id) {
            return true
        }else {
            return false
        }


        
        
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
