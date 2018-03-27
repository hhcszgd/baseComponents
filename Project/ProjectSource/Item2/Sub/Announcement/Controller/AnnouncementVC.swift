//
//  AnnouncementVC.swift
//  Project
//
//  Created by WY on 2018/1/12.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class AnnouncementVC: DDNormalVC {
    let time  = UILabel()
    let contentLabel = UILabel()
    let contentContainer = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        
        self.view.addSubview(time)
        self.view.addSubview(contentContainer)
        self.view.addSubview(contentLabel)
        contentLabel.numberOfLines = 0
        time.textAlignment = .center
        time.textColor = UIColor.DDSubTitleColor
        
        contentLabel.textColor = UIColor.colorWithHexStringSwift("#ce7160")
        contentContainer.backgroundColor = UIColor.colorWithHexStringSwift("#ffd8c3")
        if let model = showModel as? DDMessageModel {
            mylog("\(model.title)&\(model.message_type)")
            self.title = model.title
            requestApi(messageID: model.id)
        }
        // Do any additional setup after loading the view.
    }
    func requestApi(messageID:String )  {
        let leftMargin : CGFloat = 20
        let rightMargin : CGFloat = 20
        let containerMaxWidth : CGFloat = self.view.bounds.width - leftMargin - rightMargin
        let contentMaxWidth : CGFloat = containerMaxWidth - leftMargin * 2
        DDRequestManager.share.messageDetail(messageID: messageID)?.responseJSON(completionHandler: { (response ) in
            if let apiModel = DDDecode(DDMsgDetailApiModel.self , from: response){
                if apiModel.data.content == nil {
                    apiModel.data.content = """
                    asld
                    
                        kjf;a8rt.,jh.kjukygkjhgkjh你哈市东方号地回复;奥斯丁哈佛啊;式动画佛;阿斯达飞;公司的合法;时代峰峻阿谁拉的看风景了看来控件
                    gjkgjh
                        iuytg
                    kl
                    """
                }
                mylog(apiModel)
                
                let textContentSize = (apiModel.data.content ?? "").sizeWith(font: self.contentLabel.font, maxWidth: contentMaxWidth)
                self.contentLabel.text = apiModel.data.content
                self.time.text = apiModel.data.create_at
                self.time.frame = CGRect(x: 0, y: DDNavigationBarHeight + 30 , width: self.view.frame.width, height: 29)
                self.contentLabel.frame = CGRect(x: leftMargin * 2, y:  self.time.frame.maxY + 15, width: textContentSize.width, height: textContentSize.height)
                self.contentContainer.frame = CGRect(x: leftMargin , y: self.time.frame.maxY , width: containerMaxWidth, height: textContentSize.height + 30)
                
                self.contentContainer.layer.cornerRadius = 8
                self.contentContainer.layer.masksToBounds = true 
            }else{
                mylog(response.debugDescription)
            }
        })
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
