//
//  CustomTextfield.swift
//  Project
//
//  Created by 张凯强 on 2018/1/14.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class CustomTextfield: UITextField {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(lineColor.cgColor)
        context?.fill(CGRect.init(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1))
    }

}
