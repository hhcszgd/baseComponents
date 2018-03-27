//
//  InStallVC.swift
//  Project
//
//  Created by 张凯强 on 2018/1/10.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class InStallVC: DDNormalVC, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet var searchBarTop: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.request()
        self.setUI()
        self.setAddAction()
        self.requestData(parentid: nil) { (model) in
            if let data = model?.data, data.count > 0{
                self.addressBtn.isEnabled = true
            }else {
                self.addressBtn.isEnabled = false
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBOutlet var searchBtn: UISearchBar!
    @IBOutlet var addressBtn: UIButton!
    
    @IBOutlet var statusBtn: UIButton!
    
    @IBOutlet var timeBtn: UIButton!
    
    @IBOutlet var topView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewBottom: NSLayoutConstraint!
    @IBOutlet var maskLabel: UILabel!
    
    
    
    var keyWord: String?
    ///区域
    var area: Int?
    ///搜索
    var createAt: String?
    ///状态
    var status: Int?
    ///店铺类型
    var shopType: String = "0"
    let bag = DisposeBag()
    
    func setUI() {
        self.searchBarTop.constant = DDNavigationBarHeight
        self.addressBtn.titleLabel?.textAlignment = .center
        self.timeBtn.titleLabel?.textAlignment = .center
        self.statusBtn.titleLabel?.textAlignment = .center
        self.view.layoutIfNeeded()
        self.searchBtn.setImage(UIImage.init(named: "searchicon"), for: UISearchBarIcon.search, state: UIControlState.normal)
        self.tableView.register(UINib.init(nibName: "bussinessCell", bundle: Bundle.main), forCellReuseIdentifier: "bussinessCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.title = "安装业务"

        
        self.searchBtn.delegate = self
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = self.searchBtn.text, text.count > 0 {
            self.keyWord = text
        }else {
            self.keyWord = nil
        }
        self.request()
        searchBar.resignFirstResponder()
        
        
    }
    func setAddAction()  {
        let saveButtonItem =  UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self , action: #selector(addButtonClick(sender:)))
        saveButtonItem.tintColor = UIColor.DDSubTitleColor
        self.navigationItem.rightBarButtonItem = saveButtonItem
    }
    @objc func addButtonClick(sender:UIBarButtonItem){
        self.pushVC(vcIdentifier: "HomeWebVC" , userInfo: DomainType.wap.rawValue +  "shop/create?type=yewu")
//        let web = HomeWebVC()
//        let action = DDActionModel()
//        action.keyParameter =  DomainType.wap.rawValue +  "shop/create?type=yewu"
//        web.showModel = action
//        self.navigationController?.pushViewController(web, animated: true )
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.configmentSelectView(view: searchBar)
    }
    
    func request() {
        let member = DDAccount.share.id ?? "0"
        let token = DDAccount.share.token ?? ""
        
        var paramete = ["token": token, "shop_type": self.shopType, "id": member] as [String: Any]
        if let area = self.area {
            paramete["area"] = area
        }
        if let status = self.status {
            paramete["status"] = status
        }
        if let time = self.createAt {
            paramete["create_at"] = time
        }
        if let key = self.keyWord {
            paramete["keyword"] = key
        }
        
        
        NetWork.manager.requestData(router: Router.get("member/\(member)/shop", .api, paramete)).subscribe(onNext: { (dict) in
             let model = BaseModel<InstallModel<DataListModel, ShopListModel>>.deserialize(from: dict)
            self.model = model?.data
            if let shoplist = model?.data?.shop_list {
                self.dataArr = shoplist
                if self.dataArr.count == 0 {
                    self.maskLabel.isHidden = false
                    self.btnenable(bo: false)
                }else {
                    self.btnenable(bo: true)
                    self.maskLabel.isHidden = true
                }
                self.tableView.reloadData()
            }else {
                self.maskLabel.isHidden = false
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    func btnenable(bo: Bool) {
        self.addressBtn.isEnabled = bo
        self.statusBtn.isEnabled = bo
        self.timeBtn.isEnabled = bo
        
    }
    var model:InstallModel<DataListModel, ShopListModel>?
    var dataArr: [ShopListModel] = []
    
    func configmentSelectView(view: UIView) {
        if view == self.addressBtn {
            self.searchBtn.resignFirstResponder()
            self.keyWord = nil
            self.status = nil
            self.createAt = nil
            self.selectTimeView?.removeFromSuperview()
            self.selectTimeView = nil
            self.selectStatus?.removeFromSuperview()
            self.selectStatus = nil
            self.timeBtn.isSelected = false
            self.statusBtn.isSelected = false
        }
        if view == self.timeBtn {
            self.searchBtn.resignFirstResponder()
            self.selectArea?.removeFromSuperview()
            self.selectArea = nil
            self.selectStatus?.removeFromSuperview()
            self.selectStatus = nil
            self.addressBtn.isSelected = false
            self.statusBtn.isSelected = false
            self.keyWord = nil
            self.status = nil
            self.area = nil
        }
        if view == self.statusBtn {
            self.searchBtn.resignFirstResponder()
            self.selectArea?.removeFromSuperview()
            self.selectArea = nil
            self.selectTimeView?.removeFromSuperview()
            self.selectTimeView = nil
            self.addressBtn.isSelected = false
            self.timeBtn.isSelected = false
            self.keyWord = nil
            self.area = nil
            self.createAt = nil
        }
        if view == self.searchBtn {
            self.selectArea?.removeFromSuperview()
            self.selectArea = nil
            self.selectTimeView?.removeFromSuperview()
            self.selectTimeView = nil
            self.selectStatus?.removeFromSuperview()
            self.selectStatus = nil
            self.addressBtn.isSelected = false
            self.timeBtn.isSelected = false
            self.statusBtn.isSelected = false
            self.area = nil
            self.status = nil
            self.createAt = nil
        }
    }
    
    
    @IBAction func addressBtnAction(_ sender: UIButton) {
        
        
        self.configmentSelectView(view: sender)
        sender.isSelected = !sender.isSelected
        if !sender.isSelected {
            sender.isSelected = false
            self.selectArea?.removeFromSuperview()
            self.selectArea = nil
            return
        }
        let view  = AreaSelectView.init(frame: CGRect.init(x: 0, y: self.topView.max_Y, width: SCREENWIDTH, height: SCREENHEIGHT - self.topView.max_Y), title: "2223152", type: 0)
        self.view.addSubview(view)
        self.selectArea = view
        self.selectArea?.subFinished.subscribe(onNext: { [weak self](title) in
            self?.addressBtn.isSelected = false
            
            }, onError: { (error) in
                
        }, onCompleted: {[weak self] () in
            self?.selectArea?.removeFromSuperview()
            self?.selectArea = nil
        }, onDisposed: {
            mylog("回收")
        })
        self.selectArea?.finished.subscribe(onNext: { [weak self](title, area) in
            self?.area = Int(area) ?? 0
            self?.addressBtn.isSelected = false
            self?.request()
            self?.selectArea?.removeFromSuperview()
            self?.selectArea = nil
        }, onError: nil, onCompleted: nil, onDisposed: nil)
       
        
        
    }
    var selectArea: AreaSelectView?
    var selectStatus: SelectStatusView?
    @IBAction func statusBtnAction(_ sender: UIButton) {
        self.configmentSelectView(view: sender)
        sender.isSelected = !sender.isSelected
        if !sender.isSelected {
            sender.isSelected = false
            self.selectStatus?.removeFromSuperview()
            self.selectStatus = nil
            return
        }
        
        let statusView = SelectStatusView.init(frame: CGRect.init(x: 0, y: self.topView.max_Y, width: SCREENWIDTH, height: SCREENHEIGHT - self.topView.max_Y), dataArr: ["所有", "待审核", "待安装", "被驳回", "已安装"])
        self.view.addSubview(statusView)
        self.selectStatus = statusView
        
        statusView.finished.subscribe(onNext: { [weak self](title) in
            self?.statusBtn.isSelected = false
            self?.selectStatus?.removeFromSuperview()
            self?.selectStatus = nil
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        statusView.send.subscribe(onNext: { [weak self](title) in
            switch title {
            case "所有":
                self?.status = nil
                
            case "待审核":
                self?.status = 0
            case "待安装":
                self?.status = 1
            case "已安装":
                self?.status = 3
            case "被驳回":
                self?.status = 2
            default:
                break
                
                
            }

            self?.request()
            self?.selectStatus?.removeFromSuperview()
            self?.selectStatus = nil
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
    }
    var selectTimeView: SelectTime?
    @IBAction func timeBtnAction(_ sender: UIButton) {
        self.configmentSelectView(view: sender)
        sender.isSelected = !sender.isSelected
        if !sender.isSelected {
            sender.isSelected = false
            self.selectTimeView?.removeFromSuperview()
            self.selectTimeView = nil
            return
        }
        
        if let dataListArr = self.model?.data_list {
            let view = SelectTime.init(frame: CGRect.init(x: 0, y: self.topView.max_Y, width: SCREENWIDTH, height: SCREENHEIGHT - self.topView.max_Y), dataArr: dataListArr)
            self.view.addSubview(view)
            self.selectTimeView = view
            
            self.selectTimeView?.finished.subscribe(onNext: { [weak self](title) in
                self?.timeBtn.isSelected = false
                self?.selectTimeView?.removeFromSuperview()
                self?.selectTimeView = nil
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            
            self.selectTimeView?.send.subscribe(onNext: { [weak self](title) in
                self?.createAt = title
                self?.request()
                self?.timeBtn.isSelected = false
                self?.selectTimeView?.removeFromSuperview()
                self?.selectTimeView = nil
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            
        }else{
            
            sender.isSelected = false
        }
        
        
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: bussinessCell = tableView.dequeueReusableCell(withIdentifier: "bussinessCell", for: indexPath) as! bussinessCell
        cell.keyWorld = self.keyWord
        cell.model = self.dataArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = InstallDetailVC()
        let model = self.dataArr[indexPath.row]
        vc.id = model.id
        vc.type = "install"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        mylog("销毁销毁销毁")
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
extension InStallVC {
    func requestData(parentid: String?, success: @escaping ((BaseModelForArr<AreaModel>?) -> ())) {
        let token = DDAccount.share.token ?? ""
        let id = DDAccount.share.id ?? ""
        
        var paramete = ["token": token] as [String: Any]
        
        if let fatherid = parentid {
            paramete["parent_id"] = fatherid
        }
        NetWork.manager.requestData(router: Router.get("member/\(id)/shop/area", .api, paramete)).subscribe(onNext: { (dict) in
            let model = BaseModelForArr<AreaModel>.deserialize(from: dict)
            
            success(model)
            
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("完成")
        }) {
            mylog("回收")
        }
    }
}


