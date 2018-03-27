//
//  InstallBtn.swift
//  Project
//
//  Created by 张凯强 on 2018/1/10.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class InstallBtn: UIButton {

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        guard let title = self.currentTitle else {
            return CGRect.zero
        }
        let size = title.sizeSingleLine(font: UIFont.systemFont(ofSize: 15))
        let width = size.width + 10
        let height = size.height + 10
        let x: CGFloat = (contentRect.size.width - width) / 2.0 - 10
        let y: CGFloat = (contentRect.size.height - height) / 2.0
        
        
        
        return CGRect.init(x: x, y: y, width: width, height: height)
    }
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        guard let title = self.currentTitle else {
            return CGRect.zero
        }
        let size = title.sizeSingleLine(font: UIFont.systemFont(ofSize: 15))
        let width = size.width + 10
        let x: CGFloat = (contentRect.size.width - width) / 2.0 - 10
        let y: CGFloat = (contentRect.size.height - 5.5) / 2.0
        
        
        return CGRect.init(x: x + width + 10, y: y, width: CGFloat(10), height: CGFloat(5.5))
    }
    
    

}
