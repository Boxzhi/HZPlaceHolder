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

public extension UILabel {
    
    /// UILabel设置圆角 (不传值默认切全圆)
    func hz_labelWithCornerRadius(radius: CGFloat = 0, corners: UIRectCorner = .allCorners, backgroundColor: UIColor? = nil) {
        self.hz_labelWithCornerRadiusBorder(radius: radius, corners: corners, backgroundColor: backgroundColor)
    }
    
    /// UILabel设置圆角、边框
    func hz_labelWithCornerRadiusBorder(radius: CGFloat = 0, borderColor: UIColor? = nil, borderWidth: CGFloat = 0, corners: UIRectCorner = .allCorners, backgroundColor: UIColor? = nil) {
        if radius == 0 {
            self.layer.cornerRadius = self.bounds.size.height / 2.0
        }else {
            self.layer.cornerRadius = radius
        }
        
        if let _borderColor = borderColor, borderWidth > 0 {
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = _borderColor.cgColor
        }
        
        var cornerMasks: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        if !(corners.contains(.topLeft)) {
            cornerMasks.remove(.layerMinXMinYCorner)
        }
        if !(corners.contains(.topRight)) {
            cornerMasks.remove(.layerMaxXMinYCorner)
        }
        if !(corners.contains(.bottomLeft)) {
            cornerMasks.remove(.layerMinXMaxYCorner)
        }
        if !(corners.contains(.bottomRight)) {
            cornerMasks.remove(.layerMaxXMaxYCorner)
        }
        if let _backgroundColor = backgroundColor {
            self.layer.backgroundColor = _backgroundColor.cgColor
        }
        self.layer.maskedCorners = cornerMasks
        
    }
    
}
