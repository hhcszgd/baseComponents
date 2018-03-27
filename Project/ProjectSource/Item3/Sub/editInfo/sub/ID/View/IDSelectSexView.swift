//
//  IDSelectSexView.swift
//  Project
//
//  Created by 张凯强 on 2018/1/26.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class IDSelectSexView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    init(frame: CGRect, array: [String]) {
        super.init(frame: frame)
        self.topView.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: 0.7 * frame.size.height)
        self.bottomView.frame = CGRect.init(x: 0, y: self.topView.max_Y, width: frame.size.width, height: frame.size.height - self.topView.max_Y)
        self.bottomView.addSubview(self.cancleBtn)
        self.bottomView.addSubview(self.sure)
        self.cancleBtn.frame = CGRect.init(x: 0, y: 0, width: 80, height: 40)
        self.sure.frame = CGRect.init(x: frame.size.width - 80, y: 0, width: 80, height: 40)
        self.bottomView.addSubview(self.pickView)
        self.pickView.frame = CGRect.init(x: 0, y: self.cancleBtn.max_Y, width: frame.size.width, height: self.bottomView.frame.size.height - self.cancleBtn.max_Y)
        
        self.dataArr = array
        self.pickView.reloadAllComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var dataArr: [String] = []
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataArr.count
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if let  label = view as? UILabel {
            label.text = self.dataArr[row]
            return label
        }else {
            let label = UILabel.init()
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = UIColor.colorWithHexStringSwift("333333")
            label.textAlignment = .center
            label.backgroundColor = UIColor.white
            label.text = self.dataArr[row]
            return label
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.frame.size.width
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            self.selectType = 1
        }
        if row == 1 {
            self.selectType = 2
        }
    }
    var selectType: Int = 1
    @objc func cancleAction(btn: UIButton) {
        self.hiddenFromSuperView(type: -1)
    }
    @objc func sureAction(btn: UIButton) {
        self.hiddenFromSuperView(type: self.selectType)
    }
    
    var finished: PublishSubject<Int> = PublishSubject<Int>.init()
    @objc func hiddenFromSuperView(type: Int) {
        UIView.animate(withDuration: 0.3, animations: {
            self.topView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }) { (finished) in
            self.finished.onNext(type)
            self.finished.onCompleted()
        }
    }
    
    lazy var cancleBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("333333"), for: .normal)
        btn.addTarget(self, action: #selector(cancleAction(btn:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()
    lazy var sure: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("ea9061"), for: .normal)
        btn.addTarget(self, action: #selector(sureAction(btn:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()
    
    
    lazy var topView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.addSubview(view)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hiddenFromSuperView))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        return view
        
        
        
    }()
    lazy var bottomView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        return view
    }()
    
    lazy var pickView: UIPickerView = {
        let view = UIPickerView.init()
        view.dataSource = self
        view.delegate = self
        return view
    }()

}
