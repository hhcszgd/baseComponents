//
//  DDChooseBankListVC.swift
//  Project
//
//  Created by WY on 2018/1/29.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
class DDChooseBankListVC: DDNormalVC {
    var doneHandle : ((DDGetCsahApiDataModel)->())?
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    var apiModel = DDAdbankCardCellModel()
    
    let noBankCardNoticeLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择银行卡"
        _configSubviews()
        self.requestApi()
        // Do any additional setup after loading the view.
    }
    
    func requestApi() {
        DDRequestManager.share.getBandkCard()?.responseJSON(completionHandler: { (response) in
            mylog(response.debugDescription)
            if let apiModel = DDDecode(DDAdbankCardCellModel.self , from: response){
                self.apiModel = apiModel
                self.tableView.reloadData()
            }
            
        })
    }
    func _configSubviews()  {
        self.view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.reloadData()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    class DDChooseBankCell: UITableViewCell {
        var model : DDBankCardModel = DDBankCardModel(){
            didSet{
                if let url  = URL(string:model.bank_logo) {
                    bankLogo.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
                }else{
                    bankLogo.image = DDPlaceholderImage
                }
                bankName.text = model.bank_name
                let bankNum  = model.number
                if bankNum.count >= 4{
                    let num = bankNum.suffix(from:bankNum.index(bankNum.endIndex, offsetBy: -4) )
                    self.bankNumber.text = "尾号 (\(num))"
                }else{
                    self.bankNumber.text = "尾号 (\(model.number))"
                }
            }
        }
        let getCashContainer : UIView = UIView()
        let bankLogo = UIImageView()
        let bankName = UILabel()
        let bankNumber = UILabel()
        let arrowBtn = UIButton()
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(getCashContainer)
            getCashContainer.addSubview(bankLogo)
            getCashContainer.addSubview(bankName)
            getCashContainer.addSubview(bankNumber)
            getCashContainer.addSubview(arrowBtn)
            bankName.textColor = UIColor.DDSubTitleColor
            bankNumber.textColor = UIColor.DDSubTitleColor
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let containerMargin : CGFloat = 10
            getCashContainer.frame = CGRect(x: containerMargin, y: containerMargin / 2, width: self.contentView.bounds.width - containerMargin * 2, height: self.contentView.bounds.height - containerMargin )
            getCashContainer.layer.borderWidth = 2
            getCashContainer.layer.borderColor = UIColor.DDLightGray.cgColor
            
            bankLogo.frame = CGRect(x: containerMargin, y: containerMargin, width: getCashContainer.bounds.height - containerMargin * 2, height: getCashContainer.bounds.height - containerMargin * 2)
            bankLogo.layer.cornerRadius = bankLogo.bounds.width/2
            bankLogo.layer.masksToBounds = true
            bankName.frame = CGRect(x: bankLogo.frame.maxX + 10, y: bankLogo.frame.minY, width: getCashContainer.bounds.width
                - (bankLogo.frame.maxX + 10), height: 30)
            
            bankNumber.frame = CGRect(x: bankName.frame.minX, y: bankLogo.frame.midY, width: bankName.frame.width, height: bankName.frame.height)
            
            arrowBtn.frame = CGRect(x: getCashContainer.bounds.width - 44 - containerMargin, y: bankLogo.frame.midY - 44/2, width: 44, height: 44)
            
            arrowBtn.setImage(UIImage(named:"enterthearrow"), for: UIControlState.normal)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    deinit {
        mylog("choose bank over ")
    }
}



extension DDChooseBankListVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.apiModel.data?[indexPath.row]{
            let tempModel = DDGetCsahApiDataModel()
            tempModel.id = model.id
            tempModel.bank_logo = model.bank_logo
            tempModel.number = model.number
            tempModel.bank_name = model.bank_name
            self.doneHandle?(tempModel)
            self.navigationController?.popViewController(animated: true )
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiModel.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell : DDChooseBankCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDChooseBankCell") as? DDChooseBankCell{
            returnCell = cell
        }else{
            let cell = DDChooseBankCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDChooseBankCell")
            returnCell = cell
        }
        if let model = self.apiModel.data?[indexPath.row]{
            returnCell.model = model
        }
        returnCell.textLabel?.textColor = UIColor.DDSubTitleColor
        returnCell.selectionStyle = .none
        return returnCell
    }
}
