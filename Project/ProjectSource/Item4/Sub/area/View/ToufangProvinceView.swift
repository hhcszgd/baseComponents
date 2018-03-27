//
//  ToufangProvinceView.swift
//  Project
//
//  Created by 张凯强 on 2018/3/7.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift

class ToufangProvinceView: UIView, UITableViewDelegate, UITableViewDataSource {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.leftTableview.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH * 0.4, height: frame.size.height)
        self.rightTable.frame = CGRect.init(x: SCREENWIDTH * 0.4, y: 0, width: SCREENWIDTH * 0.6, height: frame.size.height)
        
        
        self.interactive()
        
        
    }
    func interactive() {
        parentID.asObservable().subscribe(onNext: { (parentID) in
            self.request(parentID: parentID)
        }, onError: nil, onCompleted: nil, onDisposed: {
            mylog("回收")
        }).disposed(by: bag)
    }
    let bag = DisposeBag.init()
    
    var leftDataArr: [AreaModel] = []
    var rightDataArr: [String: [AreaModel]] = [String: [AreaModel]]()
    let parentID: Variable<String?> = Variable<String?>.init(nil)
    ///请求数据
    func request(parentID: String?) {
        let token = DDAccount.share.token ?? ""
        var paremete = ["token":token]
        if let parentID = parentID {
            paremete["parent_id"] = parentID
        }
        if !self.rightDataArr.keys.contains("101") {
            let gangaotaiModel = AreaModel.init()
            gangaotaiModel.name = "全国（港澳台除外）"
            gangaotaiModel.id = "101"
            self.rightDataArr["101"] = [gangaotaiModel]
        }
        
        if parentID == "101" {
            self.rightTable.reloadData()
            return
        }
        if (parentID != nil) && (self.rightDataArr.keys.contains(parentID!)) {
            self.rightTable.reloadData()
            return
        }
        
        
        NetWork.manager.requestData(router: Router.get("area", .api, paremete)).subscribe(onNext: { (dict) in
            if parentID == nil {
                if let model = BaseModelForArr<AreaModel>.deserialize(from: dict), let arr = model.data {
                    let allCountryModel = AreaModel.init()
                    allCountryModel.name = "全国"
                    allCountryModel.id = "101"
                    
                    self.leftDataArr = arr
                    self.leftDataArr.insert(allCountryModel, at: 0)
                    if let subModel = self.leftDataArr.first {
                        subModel.isSelected = true
                        if subModel.id == "101" {
                            let gangaotaiModel = AreaModel.init()
                            gangaotaiModel.name = "全国（港澳台除外）"
                            gangaotaiModel.id = "101"
                            self.rightDataArr["101"] = [gangaotaiModel]
                        }
                        
                    }
                    self.leftTableview.reloadData()
                    self.rightTable.reloadData()
                    self.leftDataArr.forEach({ (model) in
                        self.request(parentID: model.id)
                    })
                    
                }
            }else {
                if let model = BaseModelForArr<AreaModel>.deserialize(from: dict) {
                    if var arr = model.data {
                        let subModel = AreaModel.init()
                        subModel.name = "全选"
                        subModel.id = parentID ?? "101"
                        arr.insert(subModel, at: 0)
                        if !self.rightDataArr.keys.contains(parentID!) {
                            self.rightDataArr[parentID!] = arr
                        }
                        self.rightTable.reloadData()
                    }else {
                        if !self.rightDataArr.keys.contains(parentID!) {
                            self.rightDataArr[parentID!] = [AreaModel]()
                        }
                        self.rightTable.reloadData()
                    }
                }
            }
            
        }, onError: { (error) in
            mylog(error)
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.leftTableview == tableView {
            return self.leftDataArr.count
        }else {
            if parentID.value == nil {
                if let arr = self.rightDataArr["101"] {
                    return arr.count
                }else {
                    return 0
                }
            }else {
                if let arr = self.rightDataArr[parentID.value!] {
                    return arr.count
                }else {
                    return 0
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.leftTableview == tableView {
            let cell: ProvinceCell = tableView.dequeueReusableCell(withIdentifier: "ProvinceCell", for: indexPath) as! ProvinceCell
            cell.model = self.leftDataArr[indexPath.row]
            return cell
        }else {
            let cell: CityCell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
            if parentID.value == nil {
                if let arr = self.rightDataArr["101"] {
                    cell.model = arr[indexPath.row]
                }
                
            }else {
                if let arr = self.rightDataArr[parentID.value!] {
                    cell.model = arr[indexPath.row]
                }
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.leftTableview == tableView {
            self.leftDataArr.forEach({ (model) in
                if model.isSelected{
                    model.isSelected = false
                }
            })
            
            let model = self.leftDataArr[indexPath.row]
            model.isSelected = true
            tableView.reloadData()
            parentID.value = model.id
        }else {
            
            if let arr = self.rightDataArr[parentID.value ?? "101"] {
                let model = arr[indexPath.row]
                model.isSelected = !model.isSelected
                ///如果是选中第一个全选按钮
                if indexPath.row == 0 {
                    ///点击全国的时候对其他的数据全选和取消全选
                    if (parentID.value == nil) || (parentID.value == "101") {
                        for (_, arr) in self.rightDataArr.values.enumerated() {
                            arr.forEach({ (subModel) in
                                subModel.isSelected = model.isSelected
                            })
                            
                        }
                    }else {
                        ///点击的不是全国是其他省的全选按钮
                        if !model.isSelected {
                            //全选选中
                            let arr = self.rightDataArr["101"]
                            let model = arr?.first
                            model?.isSelected = false
                        }
                        arr.forEach({ (otherModel) in
                            otherModel.isSelected = model.isSelected
                        })
                    }
                    
                    
                }else {
                    ///选中除全选以为的model
                    if !model.isSelected{
                        //如果取消选中，那么就取消全选按钮
                        let model = arr.first
                        model?.isSelected = false
                        //全国选中也取消选中
                        if let arr = self.rightDataArr["101"], let model = arr.first {
                            if model.isSelected {
                                //选中全国之后，取消其中一个市
                                model.isSelected = false
                            }
                            
                        }
                        
                        
                        
                    }else{
                        ///全部选中的话全选也选中
                        let arr = arr.filter({ (model) -> Bool in
                            return !model.isSelected
                        })
                        if arr.count == 1 {
                            let model = arr.first
                            model?.isSelected = true
                        }
                        
                        let resultArr = self.rightDataArr.values.filter({ (arr ) -> Bool in
                            let subArr = arr.filter({ (model) -> Bool in
                                return !model.isSelected
                            })
                            if subArr.count > 1 {
                                return true
                            }else {
                                return false
                            }
                            
                        })
                        ///没有全部选中
                        if resultArr.count > 1 {
                            
                        }else {
                            if let arr = self.rightDataArr["101"], let model = arr.first {
                                model.isSelected = true
                                
                            }
                        }
                        
                        
                    }
                }
            }
            
            self.rightTable.reloadData()
        }
    }
    
    //选定数据
    func selectFinished(success: @escaping (String, String) -> (), failure: @escaping () -> ()) {
        
        
        
        
        //判断有没有选中全国
        let arr1 = self.rightDataArr["101"]
        var area: String = ""
        var areaName: String = ""
        
        
        
        
        
        
        if let model = arr1?.first {
            if model.isSelected {
                //选中全国那就就上传所有的省份
                self.leftDataArr.forEach({ (model) in
                    if model.id != "101" {
                        area += model.id + ","
                        areaName += model.name + ","
                    }
                })
                if area.hasSuffix(",") {
                    area = area.substring(to: area.index(area.endIndex, offsetBy: -1))
                    areaName = areaName.substring(to: areaName.index(areaName.endIndex, offsetBy: -1))
                }
                
            }else {
                //不选中全国上传选中的市
                
                for (_, arr) in self.rightDataArr.values.enumerated() {
                    for (i, model) in arr.enumerated() {
                        if i != 0 {
                            if model.isSelected {
                                area += model.id + ","
                                areaName += model.name + ","
                            }
                            
                        }
                    }
                    
                }
                if area.hasSuffix(",") {
                    area = area.substring(to: area.index(area.endIndex, offsetBy: -1))
                    areaName = areaName.substring(to: areaName.index(areaName.endIndex, offsetBy: -1))
                }
                
                
                
            }
        }
        
        let token = DDAccount.share.token ?? ""
        let id = DDAccount.share.id ?? ""
        let paramete = ["token": token, "area": area, "area_type": "2"]
        NetWork.manager.requestData(router: Router.post("member/\(id)/order/area", .api, paramete)).subscribe(onNext: { (dict) in
            let model = BaseModel<GDModel>.deserialize(from: dict)
            if model?.status == 200 {
                success(area, areaName)
            }else {
                failure()
            }
        }, onError: { (error) in
            failure()
        }, onCompleted: {
            mylog("结束")
        }, onDisposed: {
            mylog("回收")
        })
        
        
        
        
    }
    
    
    
    
    lazy var leftTableview: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.register(ProvinceCell.self, forCellReuseIdentifier: "ProvinceCell")
        table.showsVerticalScrollIndicator = false
        self.addSubview(table)
        return table
    }()
    lazy var rightTable: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.showsVerticalScrollIndicator = false
        table.register(UINib.init(nibName: "CityCell", bundle: Bundle.main), forCellReuseIdentifier: "CityCell")
        self.addSubview(table)
        return table
    }()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
        /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
extension ToufangProvinceView {
    //清空已经选择的数据
    func clearData() {
        for (index, arr) in self.rightDataArr.values.enumerated() {
            arr.forEach({ (model) in
                model.isSelected = false
            })
        }
        self.rightTable.reloadData()
    }
}


