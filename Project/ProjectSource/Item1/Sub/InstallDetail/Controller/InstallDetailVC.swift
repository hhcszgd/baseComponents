//
//  InstallDetailVC.swift
//  Project
//
//  Created by 张凯强 on 2018/1/10.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class InstallDetailVC: DDNormalVC, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewBottom: NSLayoutConstraint!
    
    @IBOutlet var tableViewTop: NSLayoutConstraint!
    var id: String? {
        didSet{
            self.request()
        }
    }
    var type: String = "install"
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.automaticallyAdjustsScrollViewInsets = false
        self.tableViewTop.constant = DDNavigationBarHeight
        self.tableViewBottom.constant = TabBarHeight
        self.view.layoutIfNeeded()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib.init(nibName: "InstallDetailShopInfoCell", bundle: Bundle.main), forCellReuseIdentifier: "InstallDetailShopInfoCell")
        self.tableView.register(UINib.init(nibName: "InstallShopImageCell", bundle: Bundle.main), forCellReuseIdentifier: "InstallShopImageCell")
        self.tableView.register(UINib.init(nibName: "ApplicationCell", bundle: Bundle.main), forCellReuseIdentifier: "ApplicationCell")
        self.tableView.register(UINib.init(nibName: "AuditCell", bundle: Bundle.main), forCellReuseIdentifier: "AuditCell")
        self.tableView.register(UINib.init(nibName: "ManagerCell", bundle: Bundle.main), forCellReuseIdentifier: "ManagerCell")
        self.tableView.register(UINib.init(nibName: "ScreenCell", bundle: Bundle.main), forCellReuseIdentifier: "ScreenCell")
        
        
        if type == "install" {
            self.title = "安装业务"
        }
        if type == "screen" {
            self.title = "屏幕管理"
        }
        if type == "chaxun" {
            self.title = "业务查询"
        }
        // Do any additional setup after loading the view.
    }
    func request() {
        let token = DDAccount.share.token ?? ""
        guard let id = self.id else {
            return
        }
        
        let paramete = ["token": token, "shop_type": 0] as [String: Any]
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
       
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.shopModel?.shop?.status == "0" {
            return 3
        }else {
            return 4
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell: InstallDetailShopInfoCell = tableView.dequeueReusableCell(withIdentifier: "InstallDetailShopInfoCell", for: indexPath) as! InstallDetailShopInfoCell
            cell.model = self.shopModel?.shop
            return cell
        }
        if indexPath.row == 1 {
            let cell: InstallShopImageCell = tableView.dequeueReusableCell(withIdentifier: "InstallShopImageCell", for: indexPath) as! InstallShopImageCell
            if let dataArr = self.shopModel?.imageArr {
                cell.dataArr = dataArr
            }
            
            return cell
        }
        if indexPath.row == 2 {
            if self.type == "screen" {
                let cell: ManagerCell = tableView.dequeueReusableCell(withIdentifier: "ManagerCell", for: indexPath) as! ManagerCell
                
                cell.model = self.shopModel?.shop
                return cell
            }else if self.type == "install" {
                let cell: ApplicationCell = tableView.dequeueReusableCell(withIdentifier: "ApplicationCell", for: indexPath) as! ApplicationCell
                cell.type = "install"
                cell.model = self.shopModel?.shop
                return cell
            }else if self.type == "chaxun"{
                let cell: ApplicationCell = tableView.dequeueReusableCell(withIdentifier: "ApplicationCell", for: indexPath) as! ApplicationCell
                cell.model = self.shopModel?.shop
                return cell
            }
            
            
        }
        if indexPath.row == 3 {
            let cell: AuditCell = tableView.dequeueReusableCell(withIdentifier: "AuditCell", for: indexPath) as! AuditCell
            cell.model = self.shopModel?.shop
            return cell
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
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
