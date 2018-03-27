//
//  SelectStatusView.swift
//  Project
//
//  Created by 张凯强 on 2018/1/17.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class SelectStatusView: UIView, UITableViewDelegate, UITableViewDataSource {

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
    
    var finished: PublishSubject<String> = PublishSubject<String>.init()
    
    init(frame: CGRect, dataArr: [String]) {
        super.init(frame: frame)
        for (index, str) in dataArr.enumerated() {
            let model = StatusModel.init()
            model.title = str
            self.status.append(model)
            
        }
        let height: CGFloat = frame.size.height
        self.containerView.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: height * 0.7)
        self.addSubview(self.bottomView)
        self.bottomView.frame = CGRect.init(x: 0, y: self.containerView.max_Y, width: frame.size.width, height: height - self.containerView.max_Y)
        self.bottomView.addGestureRecognizer(self.tap)
        self.bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.rightTableView.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: self.containerView.frame.size.height)
        
        
        
        
    }
    var status: [StatusModel] = []
    
    
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
        return self.status.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: RightTableCell = tableView.dequeueReusableCell(withIdentifier: "RightTableCell", for: indexPath) as! RightTableCell
        cell.statusModel = self.status[indexPath.row]
        return cell
        
    }
    var leftSelectIndex: IndexPath?
    var rightSelectIndex: IndexPath?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if self.rightSelectIndex != nil {
            let model = self.status[(self.rightSelectIndex?.row)!]
            model.isSelected = false
        }
        let model = self.status[indexPath.row]
        model.isSelected = true
        self.rightSelectIndex = indexPath
        self.rightTableView.reloadData()
        self.send.onNext(model.title)
        self.send.onCompleted()
        
    
    }
    var send: PublishSubject<String> = PublishSubject<String>.init()
    deinit {
        mylog("销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁销毁")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


}
