//
//  HZPlaceHolderView.swift
//  HZPlaceHolder
//
//  Created by 何志志 on 2019/3/11.
//  Copyright © 2019 何志志. All rights reserved.
//

import UIKit

public enum HZButtonLayoutType {
    case leftRight
    case topBottom
}

public class HZPlaceHolderView: UIView {

    fileprivate var titleString: String?
    fileprivate var titleColor: UIColor = UIColor(red: 155.0 / 255.0, green: 162.0 / 255.0, blue: 181.0 / 255.0, alpha: 1.0)
    fileprivate var titleFont: UIFont = UIFont.systemFont(ofSize: 14.0)
    fileprivate var image: UIImage?
    fileprivate var firstButton: UIButton?
    fileprivate var secondButton: UIButton?
    fileprivate var clickFirstButtonHandler: (() -> Void)?
    fileprivate var clickSecondButtonHandler: (() -> Void)?
    fileprivate var buttonLayoutType: HZButtonLayoutType?
    fileprivate var buttonSpace: CGFloat = 25.0
    fileprivate var buttonSize: CGSize?
    
    fileprivate var imageWidth: CGFloat = 0
    fileprivate var imageHeight: CGFloat = 0
    
    /// 图片 and 文字
    public class func createWithoutButton(_ titleString: String, titleColor: UIColor? = nil, titleFont: UIFont? = nil, image: Any, backgroundColor: UIColor = .white) -> HZPlaceHolderView? {
        return HZPlaceHolderView(titleString, titleColor: titleColor, titleFont: titleFont, image: image, backgroundColor: backgroundColor)
    }
    
    /// 图片 and 文字 and 一个按钮
    public class func createWithOneButton(_ titleString: String, titleColor: UIColor? = nil, titleFont: UIFont? = nil, image: Any, button: UIButton, clickButtonHandler: @escaping () -> Void, buttonSize: CGSize, backgroundColor: UIColor = .white) -> HZPlaceHolderView? {
        return HZPlaceHolderView(titleString, titleColor: titleColor, titleFont: titleFont, image: image, firstButton: button, clickFirstButtonHandler: clickButtonHandler, buttonSize: buttonSize, backgroundColor: backgroundColor)
    }
    
    /// 图片 and 文字 and 两个按钮
    public class func createWithTwoButton(_ titleString: String, titleColor: UIColor? = nil, titleFont: UIFont? = nil, image: Any, firstButton: UIButton, clickFirstButtonHandler: @escaping () -> Void, secondButton: UIButton, clickSecondButtonHandler: @escaping () -> Void, buttonLayoutType: HZButtonLayoutType = .leftRight, buttonSpace: CGFloat = 25.0, buttonSize: CGSize, backgroundColor: UIColor = .white) -> HZPlaceHolderView? {
        return HZPlaceHolderView(titleString, titleColor: titleColor, titleFont: titleFont, image: image, firstButton: firstButton, clickFirstButtonHandler: clickFirstButtonHandler, secondButton: secondButton, clickSecondButtonHandler: clickSecondButtonHandler, buttonLayoutType: buttonLayoutType, buttonSpace: buttonSpace, buttonSize: buttonSize, backgroundColor: backgroundColor)
    }
    
    fileprivate init(_ titleString: String, titleColor: UIColor?, titleFont: UIFont?, image: Any, firstButton: UIButton? = nil, clickFirstButtonHandler: (() -> Void)? = nil, secondButton: UIButton? = nil, clickSecondButtonHandler: (() -> Void)? = nil, buttonLayoutType: HZButtonLayoutType? = nil, buttonSpace: CGFloat? = nil, buttonSize: CGSize? = nil, backgroundColor: UIColor) {
        super.init(frame: .zero)
        
        self.titleString = titleString
        if let _titleColor = titleColor {
            self.titleColor = _titleColor
        }
        if let _titleFont = titleFont {
            self.titleFont = _titleFont
        }
        if let _imageString = image as? String {
            self.image = UIImage(named: _imageString)
        }else if let _image = image as? UIImage {
            self.image = _image
        }else {
            return
        }
        self.firstButton = firstButton
        self.clickFirstButtonHandler = clickFirstButtonHandler
        self.secondButton = secondButton
        self.clickSecondButtonHandler = clickSecondButtonHandler
        self.buttonLayoutType = buttonLayoutType
        if let _buttonSpace = buttonSpace {
            self.buttonSpace = _buttonSpace
        }
        self.buttonSize = buttonSize
        
        if let _image = self.image {
            self.imageWidth = _image.size.width
            self.imageHeight = _image.size.height
        }
        
        self.backgroundColor = backgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {

        // 占位文字
        let titleLabel = UILabel(text: titleString, textColor: titleColor, font: titleFont, textAlignment: .center)
        titleLabel.numberOfLines = 0
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleLabelLeading = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        let titleLabelTrailing = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        let titleLabelVertical = NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -(self.bounds.size.height * 0.1))
        addConstraints([titleLabelLeading, titleLabelTrailing, titleLabelVertical])
        
        // 占位图片
        let imageView = UIImageView(image: self.image)
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageViewHorizontal = NSLayoutConstraint( item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        let imageViewWidth = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.imageWidth)
        let imageViewHeight = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.imageHeight)
        let imageViewBottom = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: titleLabel, attribute: .top, multiplier: 1.0, constant: -20)
        addConstraints([imageViewHorizontal, imageViewWidth, imageViewHeight, imageViewBottom])
        
        // 占位按钮
        if let _buttonSize = buttonSize, let _firstButton = firstButton {
            _firstButton.addTarget(self, action: #selector(clickFirstButtonAction(_:)), for: .touchUpInside)
            self.addSubview(_firstButton)
            _firstButton.translatesAutoresizingMaskIntoConstraints = false
            
            let firstButtonWidth = NSLayoutConstraint(item: _firstButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: _buttonSize.width)
            let firstButtonHeight = NSLayoutConstraint(item: _firstButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: _buttonSize.height)
            let firstButtonCenterX = NSLayoutConstraint(item: _firstButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: buttonLayoutType == .topBottom ? 0 : -((buttonSpace + _buttonSize.width) / 2.0))
            let firstButtonTop = NSLayoutConstraint(item: _firstButton, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 25.0)
            addConstraints([firstButtonWidth, firstButtonHeight, firstButtonCenterX, firstButtonTop])

            if let _secondButton = secondButton {
                _secondButton.addTarget(self, action: #selector(clickSecondButtonAction(_:)), for: .touchUpInside)
                self.addSubview(_secondButton)
                _secondButton.translatesAutoresizingMaskIntoConstraints = false
                
                let secondButtonWidth = NSLayoutConstraint(item: _secondButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: _buttonSize.width)
                let secondButtonHeight = NSLayoutConstraint(item: _secondButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: _buttonSize.height)
                let secondButtonTop = NSLayoutConstraint(item: _secondButton, attribute: .top, relatedBy: .equal, toItem: _firstButton, attribute: .top, multiplier: 1.0, constant: buttonLayoutType == .leftRight ? 0 : (buttonSpace + _buttonSize.height))
                let secondButtonLeft = NSLayoutConstraint(item: _secondButton, attribute: .left, relatedBy: .equal, toItem: _firstButton, attribute: .left, multiplier: 1.0, constant: buttonLayoutType == .leftRight ? (buttonSpace + _buttonSize.width) : 0)
                addConstraints([secondButtonWidth, secondButtonHeight, secondButtonTop, secondButtonLeft])
            }
        }
    }
}

extension HZPlaceHolderView {
    
    @objc fileprivate func clickFirstButtonAction(_ sender: UIButton) {
        if let _clickFirstButtonHandler = clickFirstButtonHandler {
            _clickFirstButtonHandler()
        }
    }
    
    @objc fileprivate func clickSecondButtonAction(_ sender: UIButton) {
        if let _clickSecondButtonHandler = clickSecondButtonHandler {
            _clickSecondButtonHandler()
        }
    }
}
