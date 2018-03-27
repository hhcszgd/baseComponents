//
//  DDSystemMsgVC.swift
//  Project
//
//  Created by WY on 2018/1/12.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDSystemMsgVC: DDNormalVC {
    let time  = UILabel()
    let contentLabel = UILabel()
    let contentContainer = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(time)
        self.view.addSubview(contentContainer)
        self.view.addSubview(contentLabel)
        contentLabel.numberOfLines = 0
        time.textAlignment = .right
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
        let rightMargin : CGFloat = 80
        let containerMaxWidth : CGFloat = self.view.bounds.width - leftMargin - rightMargin
        let contentMaxWidth : CGFloat = containerMaxWidth - leftMargin * 2
        DDRequestManager.share.messageDetail(messageID: messageID)?.responseJSON(completionHandler: { (response ) in
            if let apiModel = DDDecode(DDMsgDetailApiModel.self , from: response){
                if apiModel.data.content == nil {
                    apiModel.data.content = "asldkjf;alsjefoiawejf;olijsldkjf;laskjdfiej;asjdf;lkasjd;flkjasdlfkja;ljflaksjdflkj"
                }
                mylog(apiModel)
                
                let textContentSize = (apiModel.data.content ?? "").sizeWith(font: self.contentLabel.font, maxWidth: contentMaxWidth)
                self.contentLabel.text = apiModel.data.content
                self.time.text = apiModel.data.create_at
                self.contentLabel.frame = CGRect(x: leftMargin * 2, y: DDNavigationBarHeight + 30, width: textContentSize.width, height: textContentSize.height)
                self.contentContainer.frame = CGRect(x: leftMargin , y: DDNavigationBarHeight + 30/2, width: containerMaxWidth, height: textContentSize.height + 30)
                self.time.frame = CGRect(x: self.contentContainer.frame.minX, y: self.contentContainer.frame.maxY, width: self.contentContainer.frame.width, height: 22)
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
