//
//  UILabelExtension.swift
//  HZPlaceHolder
//
//  Created by 何志志 on 2019/9/10.
//  Copyright © 2019 何志志. All rights reserved.
//

import UIKit

public extension UILabel {
    
    convenience init(text: String?, textColor: UIColor, font: UIFont, textAlignment: NSTextAlignment? = nil) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
        if let _textAlignment = textAlignment {
            self.textAlignment = _textAlignment
        }
    }
    
    convenience init(attributedText: NSAttributedString?) {
        self.init()
        self.attributedText = attributedText
    }
    
}
