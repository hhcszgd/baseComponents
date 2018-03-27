//
//  UILabel+extension.swift
//  Project
//
//  Created by 张凯强 on 2017/11/21.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import Foundation
import UIKit
extension UILabel {
    class func configlabel(font: UIFont, textColor: UIColor, text: String) -> UILabel {
        let label = UILabel.init()
        label.font = font
        label.textColor = textColor
        label.text = text
        label.sizeToFit()
        return label
    }
}
