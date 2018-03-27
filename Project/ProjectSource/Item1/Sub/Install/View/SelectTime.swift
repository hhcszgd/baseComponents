//
//  SelectTime.swift
//  Project
//
//  Created by 张凯强 on 2018/1/17.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class SelectTime: UIView, UITableViewDataSource, UITableViewDelegate {
    
    lazy var containerView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        view.isUserInteractionEnabled = true
        self.addSubview(view)
        return view
    }()
    lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(removeFrom))
        self.bottomView.isUserInteractionEnabled = true
        
        return tap
    }()
    let bottomView = UIView.init()
    @objc func removeFrom() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        }) { (finished) in
            self.finished.onNext("finished")
            self.finished.onCompleted()
        }
    }
    
    
    init(frame: CGRect, dataArr: [DataListModel]) {
        super.init(frame: frame)
        self.dataArr = dataArr
        for (index, supermodel) in dataArr.enumerated() {
            let model = TimeModel.init()
            
            model.title = supermodel.years ?? ""
            if index == 0 {
                self.year = model.title ?? ""
                model.isSelected = true
                self.leftSelectIndex = IndexPath.init(row: 0, section: 0)
                if let monthArr = supermodel.month {
                    for (index, str) in monthArr.enumerated() {
                        let model = TimeModel.init()
                        model.title = str
                        self.monthArr.append(model)
                    }
                }
                
            }
            self.yearArr.append(model)
            
        }
        let width: CGFloat = frame.size.width
        let height: CGFloat = frame.size.height
        self.containerView.frame = CGRect.init(x: 0, y: 0, width: width, height: height * 0.7)
        self.leftTableView.frame = CGRect.init(x: 0, y: 0, width: 150 * SCALE, height: self.containerView.frame.size.height)
        self.rightTableView.frame = CGRect.init(x: self.leftTableView.max_X, y: 0, width: self.containerView.frame.size.width - self.leftTableView.max_X, height: self.containerView.frame.size.height)
        self.bottomView.addGestureRecognizer(self.tap)
        self.addSubview(self.bottomView)
        self.bottomView.frame = CGRect.init(x: 0, y: self.containerView.max_Y, width: width, height: height - self.containerView.max_Y)
        self.bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
       
        
    }
    var dataArr: [DataListModel] = []
    var yearArr: [TimeModel] = []
    var monthArr: [TimeModel] = []
    lazy var leftTableView: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.backgroundColor = UIColor.colorWithHexStringSwift("f2f2f2")
        table.register(UINib.init(nibName: "LeftTableCell", bundle: Bundle.main), forCellReuseIdentifier: "LeftTableCell")
        self.containerView.addSubview(table)
        return table
    }()
    
    lazy var rightTableView: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        table.delegate = self
        table.dataSource = self
        
        table.register(UINib.init(nibName: "RightTableCell", bundle: Bundle.main), forCellReuseIdentifier: "RightTableCell")
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.backgroundColor = UIColor.white
        self.containerView.addSubview(table)
        return table
    }()
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.leftTableView == tableView {
            return self.yearArr.count
        }else {
            return self.monthArr.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.leftTableView == tableView {
            let cell: LeftTableCell = tableView.dequeueReusableCell(withIdentifier: "LeftTableCell", for: indexPath) as! LeftTableCell
            cell.model = self.yearArr[indexPath.row]
            return cell
        }else {
            let cell: RightTableCell = tableView.dequeueReusableCell(withIdentifier: "RightTableCell", for: indexPath) as! RightTableCell
            cell.model = self.monthArr[indexPath.row]
            return cell
        }
    }
    var leftSelectIndex: IndexPath?
    var rightSelectIndex: IndexPath?
    var year: String?
    var month: String?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.leftTableView == tableView {
            if self.leftSelectIndex != nil {
                let model = self.yearArr[(self.leftSelectIndex?.row)!]
                model.isSelected = false
            }
            let model = self.yearArr[indexPath.row]
            model.isSelected = true
            self.leftSelectIndex = indexPath
            self.leftTableView.reloadData()
            year = model.title
            
            let superModel = self.dataArr[indexPath.row]
            if let monthArr = superModel.month {
                self.monthArr = []
                for (index, str) in monthArr.enumerated() {
                    let model = TimeModel.init()
                    model.title = str
                    self.monthArr.append(model)
                }
            }
            self.rightTableView.reloadData()
        }else {
            if self.rightSelectIndex != nil {
                let model = self.monthArr[(self.rightSelectIndex?.row)!]
                model.isSelected = false
            }
            let model = self.monthArr[indexPath.row]
            model.isSelected = true
            self.rightSelectIndex = indexPath
            self.rightTableView.reloadData()
            month = model.title
        }
        if let yearStr = self.year, let monthStr = self.month {
            let time = yearStr + "-" + monthStr
            self.send.onNext(time)
            self.send.onCompleted()
        }
        
        
        
    }
    var send: PublishSubject<String> = PublishSubject<String>.init()
    var finished: PublishSubject<String> = PublishSubject<String>.init()
    
    deinit {
        mylog("销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
