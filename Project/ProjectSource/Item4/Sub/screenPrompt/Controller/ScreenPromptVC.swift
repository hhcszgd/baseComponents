//
//  ScreenPromptVC.swift
//  Project
//
//  Created by 张凯强 on 2018/3/12.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ScreenPromptVC: DDNormalVC, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.table)
        self.configHeaderAndFooter()
        
        self.title = "广告位预览"
        self.table.rowHeight = UITableViewAutomaticDimension
        self.table.estimatedRowHeight = 100
        
        

        // Do any additional setup after loading the view.
    }
    
    ///设置头和尾视图
    func configHeaderAndFooter() {
        
        let tableHeaderView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 225.5 + 30))
        tableHeaderView.image = UIImage.init(named: "screenselection")
        tableHeaderView.contentMode = .center
        
        let tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 80))
        let titleLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexStringSwift("333333"), text: "广告说明")
        titleLabel.textAlignment = NSTextAlignment.center
    
        let detailLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexStringSwift("b3b3b3"), text: "最终解释权在北京玉龙腾飞影视有限公司")
        detailLabel.textAlignment = NSTextAlignment.center
        
        tableFooterView.addSubview(titleLabel)
        tableFooterView.addSubview(detailLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
        }
        titleLabel.sizeToFit()
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            
        }
        self.table.tableHeaderView = tableHeaderView
        self.table.tableFooterView = tableFooterView
        
    }
    var items: [AdvertisModel]? {
        didSet{
            self.table.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ScreentPromptCell = tableView.dequeueReusableCell(withIdentifier: "ScreentPromptCell", for: indexPath) as! ScreentPromptCell
        
        cell.model = self.items?[indexPath.row]
        if (cell.model?.id == "1") || (cell.model?.id == "2") {
            cell.backView.backgroundColor = UIColor.colorWithHexStringSwift("ffb9a9")
        }

        if (cell.model?.id == "3") {
            cell.backView.backgroundColor = UIColor.colorWithHexStringSwift("b9eff6")
        }
        if (cell.model?.id == "4") {
            cell.backView.backgroundColor = UIColor.colorWithHexStringSwift("f6e7b0")
        }
        return cell
    }
    lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight ), style: UITableViewStyle.plain)
        table.delegate = self
        table.dataSource = self
        table.register(UINib.init(nibName: "ScreentPromptCell", bundle: Bundle.main), forCellReuseIdentifier: "ScreentPromptCell")
        
        table.separatorStyle = UITableViewCellSeparatorStyle.none
        table.showsVerticalScrollIndicator = false
        return table
    }()
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
