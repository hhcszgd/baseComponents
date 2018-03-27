//
//  AddIDBtn.swift
//  Project
//
//  Created by 张凯强 on 2018/1/14.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class AddIDBtn: UIButton {

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        guard let title = self.currentTitle else {
            return CGRect.zero
        }
        let size = title.sizeSingleLine(font: UIFont.systemFont(ofSize: 15))
        
        let x: CGFloat = (contentRect.size.width - size.width) / 2.0
        let y: CGFloat = 44 + 10
        return CGRect.init(x: x, y: y, width: size.width + 20, height: size.height)
    }
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        guard let image = self.currentImage else { return CGRect.zero }
        let size = image.size
        
        let x: CGFloat = (contentRect.size.width - size.width) / 2.0
        let y: CGFloat = 10
        return CGRect.init(x: x, y: y, width: size.width, height: size.height)
    }

}
