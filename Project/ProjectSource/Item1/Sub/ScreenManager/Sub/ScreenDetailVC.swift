//
//  ScreenDetailVC.swift
//  Project
//
//  Created by 张凯强 on 2018/1/18.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class ScreenDetailVC: DDNormalVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewBottom: NSLayoutConstraint!
    
    @IBOutlet var tableViewTop: NSLayoutConstraint!
    var id: String? {
        didSet{
            self.request()
        }
    }
    var type: String = "screen"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewTop.constant = DDNavigationBarHeight
        self.tableViewBottom.constant = TabBarHeight
        self.view.layoutIfNeeded()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib.init(nibName: "InstallDetailShopInfoCell", bundle: Bundle.main), forCellReuseIdentifier: "InstallDetailShopInfoCell")
        self.tableView.register(UINib.init(nibName: "InstallShopImageCell", bundle: Bundle.main), forCellReuseIdentifier: "InstallShopImageCell")
        self.tableView.register(UINib.init(nibName: "ApplicationCell", bundle: Bundle.main), forCellReuseIdentifier: "ApplicationCell")
        self.tableView.register(UINib.init(nibName: "AuditCell", bundle: Bundle.main), forCellReuseIdentifier: "AuditCell")
        self.tableView.register(UINib.init(nibName: "ManagerCell", bundle: Bundle.main), forCellReuseIdentifier: "ManagerCell")
        self.tableView.register(UINib.init(nibName: "ScreenCell", bundle: Bundle.main), forCellReuseIdentifier: "ScreenCell")
        self.title = "屏幕管理"
        // Do any additional setup after loading the view.
    }
    func request() {
        let token = DDAccount.share.token ?? ""
        guard let id = self.id else {
            return
        }
        
        let paramete = ["token": token, "shop_type": 1] as [String: Any]
        NetWork.manager.requestData(router: Router.get("shop/\(id)", .api, paramete)).subscribe(onNext: { (dict) in
            let model = BaseModel<ShopDetailModel<ShopInfoModel, ShopImagesModel, ScreensModel>>.deserialize(from: dict)
            
            if let data = model?.data {
                self.shopModel = data
                self.tableView.reloadData()
            }
            
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
    }
    var shopModel: ShopDetailModel<ShopInfoModel, ShopImagesModel, ScreensModel>?
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let arr = self.shopModel?.screens, arr.count > 0 {
            return 2
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }else {
            let arr  = self.shopModel?.screens ?? []
            return arr.count
            
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) && (indexPath.section == 0){
            let cell: InstallDetailShopInfoCell = tableView.dequeueReusableCell(withIdentifier: "InstallDetailShopInfoCell", for: indexPath) as! InstallDetailShopInfoCell
            cell.type = 1
            cell.model = self.shopModel?.shop
            
            return cell
        }
        if (indexPath.row == 1) && (indexPath.section == 0) {
            let cell: InstallShopImageCell = tableView.dequeueReusableCell(withIdentifier: "InstallShopImageCell", for: indexPath) as! InstallShopImageCell
            if let dataArr = self.shopModel?.imageArr {
                cell.dataArr = dataArr
            }
            
            return cell
        }
        if (indexPath.row == 2) && (indexPath.section == 0) {
            let cell: ManagerCell = tableView.dequeueReusableCell(withIdentifier: "ManagerCell", for: indexPath) as! ManagerCell
            cell.model = self.shopModel?.shop
            return cell
            
        }
        if indexPath.section == 1 {
            let cell: ScreenCell = tableView.dequeueReusableCell(withIdentifier: "ScreenCell", for: indexPath) as! ScreenCell
            if let arr = self.shopModel?.screens {
                cell.model = arr[indexPath.row]
            }
            
            return cell
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = ScreenHeaderView.init(frame: CGRect.zero)
            return view
        }
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 30
        }
        return 0.001
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
