//
//  DDBankCardManageVC.swift
//  Project
//
//  Created by WY on 2018/1/23.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
class DDBankCardManageVC: DDNormalVC {
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    var apiModel = DDAdbankCardCellModel()
    
    let noBankCardNoticeLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "银行卡管理"
        let rightBtn = UIBarButtonItem.init(image: UIImage(named:"addBankCardicon"), style: UIBarButtonItemStyle.plain, target: self , action: #selector(addBankCardClick(sender:)))
        self.navigationItem.rightBarButtonItem = rightBtn
        _configSubviews()
        layoutNobankNotice()
        self.requestApi()
        // Do any additional setup after loading the view.
    }
    
    func switchNobankNoticeStatus(_ hidden:Bool) {
        self.noBankCardNoticeLabel.isHidden = hidden
    }
    func layoutNobankNotice() {
        self.view.addSubview(noBankCardNoticeLabel)
        switchNobankNoticeStatus(true)
        noBankCardNoticeLabel.numberOfLines = 4
        noBankCardNoticeLabel.textColor = UIColor.DDSubTitleColor
        noBankCardNoticeLabel.textAlignment = .center
        noBankCardNoticeLabel.text = """
        您还未绑定银行卡无法体现
        点击右上角\"+\"绑定银行卡
        """
        noBankCardNoticeLabel.frame = CGRect(x: 40, y: DDNavigationBarHeight + 200, width: SCREENWIDTH - 80, height: 100)
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addBankCardClick(sender:UIBarButtonItem){
        mylog("add bank card click")
        let vc = DDAdBankCardVC()
        vc.doneHandle = {self.requestApi()}
        self.navigationController?.pushViewController(vc, animated: true )
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    class BankCardCell: DDTableViewCell {
        var model : DDBankCardModel = DDBankCardModel(){
            didSet{
                if let url  = URL(string:model.bank_logo) {
                    bankLogo.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
                }else{
                    bankLogo.image = DDPlaceholderImage
                }
                if let url  = URL(string:model.bank_back ?? "") {
                    backImage.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
                }else{
                    backImage.image = DDPlaceholderImage
                }
                bankName.text = model.bank_name
                bankType.text = "储蓄卡"
                bandCardNum.text = model.number
            }
        }
        weak var delegate : BankCardCellDelegate?
        let backImage = UIImageView()
        let bankLogo = UIImageView()
        let bankName = UILabel()
        let bankType = UILabel()
        let bandCardNum = UILabel()
        let UntieButton = UIButton()
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(backImage)
            self.contentView.addSubview(bankLogo)
            self.contentView.addSubview(bankName)
            self.contentView.addSubview(bankType)
            self.contentView.addSubview(bandCardNum)
            self.contentView.addSubview(UntieButton)
            UntieButton.addTarget(self , action: #selector(untieButtonClick(sender:)), for: UIControlEvents.touchUpInside)
            bankName.textColor = .white
            bankType.textColor = .white
            bandCardNum.textColor = .white
            
            bankName.text = "招商银行"
            bankType.text = "储蓄卡"
            bandCardNum.text = "**** **** **** 2238"
            UntieButton.setTitle("解除绑定", for: UIControlState.normal)
            UntieButton.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            bankLogo.image = UIImage(named:"installbusinessicons")
            backImage.image = UIImage(named:"bankcardbackground_blue")
        }
        @objc func untieButtonClick(sender:UIButton){
            self.delegate?.untieBankCard(cell: self )
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let logoMargin : CGFloat = 10
            backImage.frame = CGRect(x: 10, y: 0, width: self.contentView.bounds.width - 10 * 2, height: self.contentView.bounds.height - 20)
            bankLogo.frame = CGRect(x: backImage.frame.minX + logoMargin, y: backImage.frame.minY + logoMargin, width: 64, height: 64)
            bankLogo.layer.cornerRadius = bankLogo.bounds.width/2
            bankLogo.layer.masksToBounds = true
            UntieButton.ddSizeToFit()
            let untieButtonW = UntieButton.bounds.width + 5
            UntieButton.frame = CGRect(x: self.contentView.bounds.width - 10 - untieButtonW - 10, y: bankLogo.frame.minY, width: untieButtonW, height: 30)
            bankName.frame = CGRect(x:bankLogo.frame.maxX + logoMargin, y: bankLogo.frame.minY, width: UntieButton.frame.minX - bankLogo.frame.maxX - logoMargin, height: 30)
            
            bankType.frame = CGRect(x: bankName.frame.minX, y: bankLogo.frame.midY, width: 100, height: 30)
            bandCardNum.frame = CGRect(x: bankName.frame.minX, y: bankLogo.frame.maxY, width: self.contentView.bounds.width - bankName.frame.minX, height: 30)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
protocol BankCardCellDelegate : NSObjectProtocol {
    func untieBankCard(cell : DDBankCardManageVC.BankCardCell)
}
extension DDBankCardManageVC : UITableViewDelegate , UITableViewDataSource , BankCardCellDelegate{
    func untieBankCard(cell : DDBankCardManageVC.BankCardCell){
        
        let alertVC = UIAlertController.init(title: "确定解除绑定", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let cancleAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action ) in
            
        }
        let confirmAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.destructive) { (action ) in
            
            if let indexPath = self.tableView.indexPath(for: cell){
                guard let model  = self.apiModel.data?[indexPath.row] else {return}
                DDRequestManager.share.untieBankCard(bankID: model.id)?.responseJSON(completionHandler: { (response ) in
                    switch response.result{
                    case .success:
                        if let dict  = response.value as? [String : Any]{
                            guard let code = dict["status"] as? Int else{return}
                            guard let msg = dict["message"] as? String else {return}
                            if code == 200 {
                                self.requestApi()
                            }else {
                                GDAlertView.alert(msg, image: nil , time: 2, complateBlock: nil )
                            }
                        } else {
                            GDAlertView.alert("数据格式有误", image: nil , time: 2, complateBlock: nil )
                            return
                        }
                        
                    case .failure:
                        GDAlertView.alert("操作失败", image: nil , time: 2, complateBlock: nil )
                        break
                    }
                })
            }
        }
        alertVC.addAction(cancleAction)
        alertVC.addAction(confirmAction)
        self.present(alertVC, animated: true , completion: nil )
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOrRows = self.apiModel.data?.count , numberOrRows > 0{
            switchNobankNoticeStatus(true )

            return numberOrRows
        }else{
            switchNobankNoticeStatus(false)
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell : BankCardCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: "systemCell") as? BankCardCell{
            returnCell = cell
        }else{
            let cell = BankCardCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "systemCell")
            returnCell = cell
        }
        if let model = self.apiModel.data?[indexPath.row]{
            returnCell.model = model
        }
        returnCell.delegate = self
        returnCell.textLabel?.textColor = UIColor.DDSubTitleColor
        returnCell.selectionStyle = .none
        return returnCell
    }
}
