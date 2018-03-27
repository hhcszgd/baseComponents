//
//  MyArea.swift
//  Project
//
//  Created by 张凯强 on 2018/1/15.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class MyArea: GDNormalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.request()
        
        
        
        // Do any additional setup after loading the view.
    }
    func request() {
        let id = DDAccount.share.id ?? "0"
        let token = DDAccount.share.token ?? ""
        let url = "member/\(id)/area"
        let paramete = ["token": token]
        NetWork.manager.requestData(router: Router.get(url, .api, paramete)).subscribe(onNext: { (dict) in
            let model = BaseModel<MyAreaModel<AreaListModel>>.deserialize(from: dict)
            if model?.status == 200 {
                if let data = model?.data {
                    self.uploadUI(model: data)
                }
            }
            
        }, onError: { (error) in
            
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        self.naviBar.title = "我的区域"
    }
    
    var examineStatus: String = ""
    func uploadUI(model: MyAreaModel<AreaListModel>) {
        if let dataArr = model.area_list {
            self.dataArr = dataArr
            self.table.reloadData()
        }
        if let imageStr = model.avatar {
            self.userImage.sd_setImage(with: imgStrConvertToUrl(imageStr))
        }
        self.userName.text = "姓名：" + (model.name ?? "")
        self.jobNumber.text = "工号：" + (model.number ?? "")
        self.mobile.text = "电话：" + (model.mobile ?? "")
        if model.admin_area == "0"{
            self.area.text = "管理区域：" + "待选择"
        }else {
            self.area.text = "管理区域：" + (model.admin_area ?? "")
            
        }
        
        if model.member_type == "1" {
            self.backView.isHidden = true
            self.propmtLabel.text = "您还未成为兼职业务员，不可选择管理区域"
        }
        
        if model.admin_area != "0" {
            self.propmtLabel.text = "点击 “工作”—“屏幕管理”查看我负责的店铺情况"
            self.backView.isHidden = true
        }
    
        self.examineStatus = model.examine_status ?? ""
        
        
        
        
        
    }
    
    
    
    override func gdAddSubViews() {
        self.top.constant = DDNavigationBarHeight + 15
        self.bottom.constant = TabBarHeight
        self.view.layoutIfNeeded()
        self.table.register(UINib.init(nibName: "MyAreaCell", bundle: Bundle.main), forCellReuseIdentifier: "MyAreaCell")
       
       
        
    }
    @IBOutlet var bottom: NSLayoutConstraint!
    var dataArr: [AreaListModel] = []
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyAreaCell = tableView.dequeueReusableCell(withIdentifier: "MyAreaCell", for: indexPath) as! MyAreaCell
        cell.model = self.dataArr[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.examineStatus == "-1") || (self.examineStatus == "2") {
            
            self.alert(type: .alertTwo)
            return
        }
        if self.examineStatus == "0" {
            self.alert(type: .alertThree)
            return
        }
        
        
        for model in self.dataArr {
            model.isSelected = false
        }
        let model = self.dataArr[indexPath.row]
        model.isSelected = true
        tableView.reloadData()
        self.selectModel = model
        
    }
    func alert(type: MyAreaAlertType) {

//        self.selectModel = AreaListModel()
//        self.selectModel?.area = "0"
        
        
        ///////////////////
        var title: String = ""
        if type == MyAreaAlertType.alertTwo {
            title = "您的基本信息不完整进行区域管理需要个人相关信息认证请您补充个人基本信息"
        }
        if type == MyAreaAlertType.alertThree {
            title = "您的基本信息正在审核中请等待审核通过后再进行区域选择"
        }
        if type == MyAreaAlertType.alertOne {
            title = self.selectModel?.name ?? ""
        }
        
        let view = MyAreaAlertView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT), title: (title), type: type, model: self.selectModel)
        view.selectTitle = (self.selectModel?.name ?? "")
        view.selectFinished = { (title) in
            
        }
       
        self.view.addSubview(view)
        let oldTransform = view.backView.transform
        view.backView.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
        UIView.animate(withDuration: 0.4, animations: {
            view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            view.backView.transform = oldTransform
        }) { (finished) in
            
        }
        view.finished.subscribe(onNext: { [weak self](action) in
            if action != 0 {
                self?.navigationController?.pushViewController(JudgeVC(), animated: true)
            }
            
        }, onError: nil, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        view.selectAreaSuccess.subscribe(onNext: { [weak self](status) in
            self?.request()
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    var selectModel: AreaListModel?
    @IBOutlet var top: NSLayoutConstraint!
    
    
    @IBOutlet var titlleLabel: UILabel!
    
    @IBOutlet var backImage: UIImageView!
    @IBOutlet var userImage: UIImageView!
    
    @IBOutlet var userName: UILabel!
    
    @IBOutlet var jobNumber: UILabel!
    
    @IBOutlet var mobile: UILabel!
    @IBOutlet var area: UILabel!
    
    @IBOutlet var subTitle: UILabel!
    
    @IBOutlet var backView: UIView!
    
    @IBOutlet var backViewTitle: UILabel!
    
    @IBOutlet var submitBtn: UIButton!
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        
    }
    @IBOutlet var finishedBtn: UIButton!
    
    @IBOutlet var propmtLabel: UILabel!
    @IBAction func finishedBtnAction(_ sender: UIButton) {
        if self.selectModel == nil {
            GDAlertView.alert("您还没有选择区域,请选择", image: nil, time: 1, complateBlock: nil)
            return
        }
        self.alert(type: .alertOne)
        
    }
    @IBOutlet var table: UITableView!
    
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
