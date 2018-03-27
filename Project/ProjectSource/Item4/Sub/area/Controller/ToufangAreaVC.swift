//
//  ToufangAreaVC.swift
//  Project
//
//  Created by 张凯强 on 2018/3/7.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class ToufangAreaVC: DDNormalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configmentView()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func configmentView() {
        
        self.topViewTop.constant = DDNavigationBarHeight
        self.bottomViewBottom.constant = TabBarHeight
        self.view.layoutIfNeeded()
        self.view.addSubview(self.provinceView)
        self.view.addSubview(self.cityView)
        self.configBtn(btn: self.provinceBtn, isSelected: true, otherBtn: self.cityBtn)
      
        
        
    }
    
    lazy var provinceView: ToufangProvinceView = {
        
        let subView = ToufangProvinceView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight + 50 , width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - 100 - TabBarHeight ))
        
        return subView
    }()
    lazy var cityView: ToufangQuView = {
        
        let subView = ToufangQuView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight + 50, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - 100 - TabBarHeight))
        
        return subView
    }()
    @IBOutlet var topViewTop: NSLayoutConstraint!
    
    @IBOutlet var bottomViewBottom: NSLayoutConstraint!
    
    @IBOutlet var topView: UIView!
    
    @IBOutlet var bottomView: UIView!
    
    @IBAction func eleminateaction(_ sender: UIButton) {
        if provinceBtn.isSelected {
            self.provinceView.clearData()
        }else {
            self.cityView.clearData()
        }
        //清除
    }
    
    @IBAction func sureAction(_ sender: UIButton) {
        //确定
        if provinceBtn.isSelected {
            self.provinceView.selectFinished(success: { [weak self](area, areaName) in
                mylog("成功")
                self?.selectArea.onNext(["area": area, "areaName": areaName])
                self?.selectArea.onCompleted()
                self?.navigationController?.popViewController(animated: true)
            }, failure: {
                mylog("失败")
            })
        }else {
            self.cityView.selectFinished(success: {[weak self](area, areaName) in
                mylog("成功")
                self?.selectArea.onNext(["area": area, "areaName": areaName])
                self?.selectArea.onCompleted()
                self?.navigationController?.popViewController(animated: true)
            }, failure: {
                mylog("四百")
            })
        }
    }
    var selectArea: PublishSubject<[String: String]> = PublishSubject<[String: String]>.init()
    @IBOutlet var provinceBtn: UIButton!
    
    @IBAction func provinceBtnAction(_ sender: UIButton) {
        self.configBtn(btn: sender, isSelected: true, otherBtn: self.cityBtn)
    }
    
    @IBOutlet var cityBtn: UIButton!
    
    @IBAction func cityBtnAction(_ sender: UIButton) {
        self.configBtn(btn: sender, isSelected: true, otherBtn: self.provinceBtn)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///点击的时候按钮状态的改变
    func configBtn(btn: UIButton, isSelected: Bool = true, otherBtn: UIButton) {
        btn.isSelected = isSelected
        btn.backgroundColor = UIColor.colorWithHexStringSwift("ed8102")
        if btn == self.provinceBtn {
            self.provinceView.isHidden = false
            self.cityView.isHidden = true
        }else {
            self.provinceView.isHidden = true
            self.cityView.isHidden = false
        }
        otherBtn.isSelected = !isSelected
        otherBtn.backgroundColor = UIColor.white
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
extension UIButton {
    //设置在不同状态下按钮的背景颜色
    
}
