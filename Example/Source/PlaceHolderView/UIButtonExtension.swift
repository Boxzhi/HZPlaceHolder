//
//  UIButtonExtension.swift
//  HZPlaceHolder
//
//  Created by 何志志 on 2019/3/11.
//  Copyright © 2019 何志志. All rights reserved.
//

import UIKit

public enum HZButtonEdgeInsetsStyle: Int {
    case top = 0  // image在上，label在下
    case bottom = 1  // image在下，label在上
    case left = 2  // image在左，label在右
    case right = 3  // image在右，label在左
}

public extension UIButton {
    
    convenience init(title: String, selectedTitle: String? = nil, titleColor: UIColor, selectedColor: UIColor? = nil, font: UIFont, backgroundColor: UIColor? = nil) {
        self.init()
        self.setTitle(title, for: .normal)
        if let _selectedTitle = selectedTitle {
            self.setTitle(_selectedTitle, for: .selected)
        }
        self.setTitleColor(titleColor, for: .normal)
        if let _selectedColor = selectedColor {
            self.setTitleColor(_selectedColor, for: .selected)
        }
        self.titleLabel?.font = font
        self.backgroundColor = backgroundColor
    }
    
    convenience init(image: UIImage?, selectedImage: UIImage? = nil, backgroundColor: UIColor? = nil) {
        self.init()
        self.setImage(image, for: .normal)
        self.setImage(selectedImage, for: .selected)
        self.backgroundColor = backgroundColor
    }
    
    convenience init(title: String, selectedTitle: String? = nil, image: UIImage?, selectedImage: UIImage? = nil, backgroundColor: UIColor? = nil, style: HZButtonEdgeInsetsStyle = .top, space: CGFloat = 0) {
        self.init()
        self.setTitle(title, for: .normal)
        if let _selectedTitle = selectedTitle {
            self.setTitle(_selectedTitle, for: .selected)
        }
        self.setImage(image, for: .normal)
        if let _selectedImage = selectedImage {
            self.setImage(_selectedImage, for: .selected)
        }
        self.backgroundColor = backgroundColor
        self.layoutButtonWithEdgeInsetsStyle(style: style, space: space)
    }
    
}

extension UIButton {
    
    override open var isHighlighted: Bool {
        set {
        }
        get {
            return false
        }
    }
    
    
    /**
     - parameter style: 类型
     - parameter space: image与titleLabel的间距
     */
    public func layoutButtonWithEdgeInsetsStyle(style: HZButtonEdgeInsetsStyle, space: CGFloat) {
        
        /**
         *  拿到imageView和titleLabel的宽、高
         */
        let imageWidth: CGFloat = (self.imageView?.intrinsicContentSize.width)!
        let imageHeight: CGFloat = (self.imageView?.intrinsicContentSize.height)!
        
        var labelWidth: CGFloat = 0.0
        var labelHeight: CGFloat = 0.0
        
        if #available(iOS 8.0, *) {
            labelWidth = (self.titleLabel?.intrinsicContentSize.width)!
            labelHeight = (self.titleLabel?.intrinsicContentSize.height)!
        }else{
            labelWidth = (self.titleLabel?.frame.size.width)!
            labelHeight = (self.titleLabel?.frame.size.height)!
        }
        
        /**
         *  声明全局的imageEdgeInsets和labelEdgeInsets
         */
        var imageEdgeInsets: UIEdgeInsets = .zero
        var labelEdgeInsets: UIEdgeInsets = .zero
        
        /**
         *  根据style和space算出imageEdgeInsets和labelEdgeInsets的值
         */
        switch style {
        case .top:
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight - space / 2.0, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight - space / 2.0, right: 0)
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space / 2.0, bottom: 0, right: space / 2)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: space / 2, bottom: 0, right: -space / 2)
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight - space / 2.0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -(imageHeight + space / 2.0), left: -imageWidth, bottom: 0, right: 0)
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth + space / 2.0, bottom: 0, right: -labelWidth - space / 2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - space / 2.0, bottom: 0, right: imageWidth + space / 2.0)
        }
        
        /**
         *  赋值
         */
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
        
    }
    
}


// MARK: - UIButton IB Extension
@IBDesignable
public extension UIButton  {
    
    @IBInspectable var hz_corner: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = false
        }
    }
    
    // MARK: button的image位置间隔 上0 下1 左2 右3     如：0,7   代表image在上 、title与image间隔为7
    @IBInspectable var hz_edgeInsetsStyleSpace: String {
        get {
            return self.hz_edgeInsetsStyleSpace
        }
        
        set {
//            guard newValue.contains(",", compareOption: .caseInsensitive) else {
//                return
//            }
            self.setEdgeInsetsStyleSpace(newValue: newValue)
        }
    }
    
    
    fileprivate func setEdgeInsetsStyleSpace(newValue: String) {
        guard newValue.contains(",") else { return }
        
        let array = newValue.components(separatedBy: ",")
        guard array.count == 2 else {
            return
        }
        
        let style = NumberFormatter().number(from: array[0])?.intValue
        let space = CGFloat(Double(array[1])!)
        
        guard let _style = style else { return }
        
        if _style <= 3 {
            /**
             *  拿到imageView和titleLabel的宽、高
             */
            let imageWidth: CGFloat = (self.imageView?.intrinsicContentSize.width)!
            let imageHeight: CGFloat = (self.imageView?.intrinsicContentSize.height)!
            
            var labelWidth: CGFloat = 0.0
            var labelHeight: CGFloat = 0.0
            
            if #available(iOS 8.0, *) {
                labelWidth = (self.titleLabel?.intrinsicContentSize.width)!
                labelHeight = (self.titleLabel?.intrinsicContentSize.height)!
            }else{
                labelWidth = (self.titleLabel?.frame.size.width)!
                labelHeight = (self.titleLabel?.frame.size.height)!
            }
            
            /**
             *  声明全局的imageEdgeInsets和labelEdgeInsets
             */
            var imageEdgeInsets: UIEdgeInsets = .zero
            var labelEdgeInsets: UIEdgeInsets = .zero
            
            /**
             *  根据style和space算出imageEdgeInsets和labelEdgeInsets的值
             */
            switch _style {
            case 0:  // 上
                imageEdgeInsets = UIEdgeInsets(top: -labelHeight - space / 2.0, left: 0, bottom: 0, right: -labelWidth)
                labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight - space / 2.0, right: 0)
            case 1:  // 下
                imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight - space / 2.0, right: -labelWidth)
                labelEdgeInsets = UIEdgeInsets(top: -(imageHeight + space / 2.0), left: -imageWidth, bottom: 0, right: 0)
            case 2:  // 左
                imageEdgeInsets = UIEdgeInsets(top: 0, left: -space / 2.0, bottom: 0, right: space / 2)
                labelEdgeInsets = UIEdgeInsets(top: 0, left: space / 2, bottom: 0, right: -space / 2)
            case 3:  // 右
                imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth + space / 2.0, bottom: 0, right: -labelWidth - space / 2.0)
                labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - space / 2.0, bottom: 0, right: imageWidth + space / 2.0)
            default: break
                
            }
            
            /**
             *  赋值
             */
            self.titleEdgeInsets = labelEdgeInsets
            self.imageEdgeInsets = imageEdgeInsets
        }
    }
    
}
