//
//  MingXiVC.swift
//  Project
//
//  Created by 张凯强 on 2018/1/24.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class MingXiVC: DDNormalVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var top: NSLayoutConstraint!
    @IBOutlet var topView: UIView!
    @IBOutlet var withDrawalBtn: InstallBtn!
    var withDrawView: WithDrawalView?
    var selectTimeView: SelectTime?
    
    
    @IBAction func withDrawalAction(_ sender: InstallBtn) {
        if sender.isSelected {
            UIView.animate(withDuration: 0.3, animations: {
                self.withDrawView?.bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            }, completion: { (finised) in
                self.withDrawView?.removeFromSuperview()
                self.withDrawView = nil
                sender.isSelected = false
            })
            
            
            return
        }
        sender.isSelected = !sender.isSelected
        self.selectTimeView?.removeFromSuperview()
        self.selectTimeView = nil
        
        
        
        let targetView = WithDrawalView.init(frame: CGRect.init(x: 0, y: self.withDrawalBtn.max_Y, width: SCREENWIDTH, height: SCREENHEIGHT - self.withDrawalBtn.max_Y), dataArr: ["a0", "b"], rect: CGRect.init(x: 120, y: 0, width: 20, height: 20))
        self.view.addSubview(targetView)
        self.withDrawView = targetView
        self.withDrawView?.finished.subscribe(onNext: { [weak self](type) in
            if type == 1 {
                self?.withDrawalBtn.setTitle("收入", for: .normal)
            }else if type == 0{
                self?.withDrawalBtn.setTitle("全部", for: .normal)
            }else if type == 2{
                self?.withDrawalBtn.setTitle("提现", for: .normal)
                
            }
            self?.request(time: nil, type: type)
        }, onError: nil, onCompleted: { [weak self] in
            self?.withDrawView?.removeFromSuperview()
            self?.withDrawView = nil
            self?.withDrawalBtn.isSelected = false
            
            }, onDisposed: {
                mylog("结束")
        })
        
        
        
        
    }
    @IBOutlet var timeBtn: InstallBtn!
    @IBAction func timeAction(_ sender: InstallBtn) {
        if sender.isSelected {
            UIView.animate(withDuration: 0.3, animations: {
                self.withDrawView?.bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            }, completion: { (finised) in
                self.withDrawView?.removeFromSuperview()
                self.withDrawView = nil
            })
            
            sender.isSelected = false
            return
       }
        sender.isSelected = !sender.isSelected
        self.withDrawView?.removeFromSuperview()
        self.withDrawView = nil
        let targetView = SelectTime.init(frame: CGRect.init(x: 0, y: self.withDrawalBtn.max_Y, width: SCREENWIDTH, height: SCREENHEIGHT - self.withDrawalBtn.max_Y), dataArr: self.timeArr)
        self.view.addSubview(targetView)
        self.selectTimeView = targetView
        targetView.send.subscribe(onNext: { [weak self](title) in
            self?.request(time: title, type: nil)
        }, onError: nil, onCompleted: {
            targetView.removeFromSuperview()
            self.selectTimeView = nil
            self.timeBtn.isSelected = false
            
        }) {
            mylog("回收")
        }
        
        
        
    }
    var timeArr: [DataListModel] = []
    var itemArr: [MingXiItem] = []

    @IBOutlet var tableView: UITableView!
    @IBOutlet var bottom: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "业绩明细"
        self.top.constant = DDNavigationBarHeight
        self.bottom.constant = TabBarHeight
        self.view.layoutIfNeeded()
        self.tableView.register(UINib.init(nibName: "MingXiCell", bundle: Bundle.main), forCellReuseIdentifier: "MingXiCell")
        self.dataArr = []
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.reloadData()
        self.request(time: nil, type: 0)
        self.withDrawalBtn.setTitle("全部", for: .normal)
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet var incomeLabel: UILabel!
    @IBOutlet var withDrawallabel: UILabel!
    func request(time: String?, type: Int?) {
        let token = DDAccount.share.token ?? ""
        var paramete = ["token": token] as [String: Any]
        if let time = time {
            paramete["create_at"] = time
        }
        if let type = type {
            paramete["type"] = type
        }
        let memberid = DDAccount.share.id ?? ""
        
        
        NetWork.manager.requestData(router: Router.get("member/\(memberid)/account/list", .api, paramete)).subscribe(onNext: { (dict) in
            let model = BaseModel<MingXIModel<DataListModel, MingXiItem>>.deserialize(from: dict)
            if model?.status == 200 {
                if let data = model?.data, let list = data.date_list, let item = data.item {
                    self.timeArr = list
                    self.itemArr = item
                    self.tableView.reloadData()
                    self.incomeLabel.text = "收入:" + (data.income ?? "")
                    self.withDrawallabel.text = "支出：" + (data.pay ?? "")
                    
                }
            }else {
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
            }
        }, onError: { (error) in
            mylog(error)
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
    }
    
    
    
    var dataArr: [String] = []
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MingXiCell = tableView.dequeueReusableCell(withIdentifier: "MingXiCell", for: indexPath) as! MingXiCell
        cell.model = self.itemArr[indexPath.row]
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
