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
    fileprivate var centerYOffset: CGFloat = 0
    fileprivate var image: UIImage?
    fileprivate var previousButton: UIButton?
    fileprivate var nextButton: UIButton?
    fileprivate var clickPreviousButtonHandler: ((_ button: UIButton, _ placeHolderView: HZPlaceHolderView) -> Void)?
    fileprivate var clickNextButtonHandler: ((_ button: UIButton, _ placeHolderView: HZPlaceHolderView) -> Void)?
    fileprivate var buttonLayoutType: HZButtonLayoutType?
    fileprivate var buttonSpace: CGFloat = 25.0
    fileprivate var buttonSize: CGSize?
    
    fileprivate var imageWidth: CGFloat = 0
    fileprivate var imageHeight: CGFloat = 0
    
    /// 图片 and 文字
    public class func createWithoutButton(_ titleString: String, titleColor: UIColor? = nil, titleFont: UIFont? = nil, centerYOffset: CGFloat = 0, image: Any, backgroundColor: UIColor = .white) -> HZPlaceHolderView? {
        return HZPlaceHolderView(titleString, titleColor: titleColor, titleFont: titleFont, centerYOffset: centerYOffset, image: image, backgroundColor: backgroundColor)
    }
    
    /// 图片 and 文字 and 一个按钮
    public class func createWithOneButton(_ titleString: String, titleColor: UIColor? = nil, titleFont: UIFont? = nil, centerYOffset: CGFloat = 0, image: Any, button: UIButton, clickButtonHandler: @escaping (_ button: UIButton, _ placeHolderView: HZPlaceHolderView) -> Void, buttonSize: CGSize = CGSize(width: 120.0, height: 44.0), backgroundColor: UIColor = .white) -> HZPlaceHolderView? {
        return HZPlaceHolderView(titleString, titleColor: titleColor, titleFont: titleFont, centerYOffset: centerYOffset, image: image, previousButton: button, clickPreviousButtonHandler: clickButtonHandler, buttonSize: buttonSize, backgroundColor: backgroundColor)
    }
    
    /// 图片 and 文字 and 两个按钮
    public class func createWithTwoButton(_ titleString: String, titleColor: UIColor? = nil, titleFont: UIFont? = nil, centerYOffset: CGFloat = 0, image: Any, previousButton: UIButton, clickPreviousButtonHandler: @escaping (_ button: UIButton, _ placeHolderView: HZPlaceHolderView) -> Void, nextButton: UIButton, clickNextButtonHandler: @escaping (_ button: UIButton, _ placeHolderView: HZPlaceHolderView) -> Void, buttonLayoutType: HZButtonLayoutType = .leftRight, buttonSpace: CGFloat = 25.0, buttonSize: CGSize = CGSize(width: 120.0, height: 44.0), backgroundColor: UIColor = .white) -> HZPlaceHolderView? {
        return HZPlaceHolderView(titleString, titleColor: titleColor, titleFont: titleFont, centerYOffset: centerYOffset, image: image, previousButton: previousButton, clickPreviousButtonHandler: clickPreviousButtonHandler, nextButton: nextButton, clickNextButtonHandler: clickNextButtonHandler, buttonLayoutType: buttonLayoutType, buttonSpace: buttonSpace, buttonSize: buttonSize, backgroundColor: backgroundColor)
    }
    
    fileprivate init(_ titleString: String, titleColor: UIColor?, titleFont: UIFont?, centerYOffset: CGFloat, image: Any, previousButton: UIButton? = nil, clickPreviousButtonHandler: ((_ button: UIButton, _ placeHolderView: HZPlaceHolderView) -> Void)? = nil, nextButton: UIButton? = nil, clickNextButtonHandler: ((_ button: UIButton, _ placeHolderView: HZPlaceHolderView) -> Void)? = nil, buttonLayoutType: HZButtonLayoutType? = nil, buttonSpace: CGFloat? = nil, buttonSize: CGSize? = nil, backgroundColor: UIColor) {
        super.init(frame: .zero)
        
        self.titleString = titleString
        if let _titleColor = titleColor {
            self.titleColor = _titleColor
        }
        if let _titleFont = titleFont {
            self.titleFont = _titleFont
        }
        self.centerYOffset = centerYOffset
        if let _imageString = image as? String {
            self.image = UIImage(named: _imageString)
        }else if let _image = image as? UIImage {
            self.image = _image
        }else {
            return
        }
        self.previousButton = previousButton
        self.clickPreviousButtonHandler = clickPreviousButtonHandler
        self.nextButton = nextButton
        self.clickNextButtonHandler = clickNextButtonHandler
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
        let titleLabelCenterY = NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: centerYOffset)
        addConstraints([titleLabelLeading, titleLabelTrailing, titleLabelCenterY])
        
        // 占位图片
        let imageView = UIImageView(image: self.image)
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageViewWidth = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.imageWidth)
        let imageViewHeight = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.imageHeight)
        let imageViewCenterX = NSLayoutConstraint( item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        let imageViewBottom = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: titleLabel, attribute: .top, multiplier: 1.0, constant: -10)
        addConstraints([imageViewCenterX, imageViewWidth, imageViewHeight, imageViewBottom])
        
        // 占位按钮
        if let _buttonSize = buttonSize, let _previousButton = previousButton {
            _previousButton.addTarget(self, action: #selector(clickPreviousButtonAction(_:)), for: .touchUpInside)
            self.addSubview(_previousButton)
            _previousButton.translatesAutoresizingMaskIntoConstraints = false
            
            let previousButtonWidth = NSLayoutConstraint(item: _previousButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: _buttonSize.width)
            let previousButtonHeight = NSLayoutConstraint(item: _previousButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: _buttonSize.height)
            let previousButtonCenterX = NSLayoutConstraint(item: _previousButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: (buttonLayoutType == .topBottom || nextButton == nil) ? 0 : -((buttonSpace + _buttonSize.width) / 2.0))
            let previousButtonTop = NSLayoutConstraint(item: _previousButton, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 25.0)
            addConstraints([previousButtonWidth, previousButtonHeight, previousButtonCenterX, previousButtonTop])

            if let _nextButton = nextButton {
                _nextButton.addTarget(self, action: #selector(clickNextButtonAction(_:)), for: .touchUpInside)
                self.addSubview(_nextButton)
                _nextButton.translatesAutoresizingMaskIntoConstraints = false
                
                let nextButtonWidth = NSLayoutConstraint(item: _nextButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: _buttonSize.width)
                let nextButtonHeight = NSLayoutConstraint(item: _nextButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: _buttonSize.height)
                let nextButtonTop = NSLayoutConstraint(item: _nextButton, attribute: .top, relatedBy: .equal, toItem: _previousButton, attribute: .top, multiplier: 1.0, constant: buttonLayoutType == .leftRight ? 0 : (buttonSpace + _buttonSize.height))
                let nextButtonLeft = NSLayoutConstraint(item: _nextButton, attribute: .left, relatedBy: .equal, toItem: _previousButton, attribute: .left, multiplier: 1.0, constant: buttonLayoutType == .leftRight ? (buttonSpace + _buttonSize.width) : 0)
                addConstraints([nextButtonWidth, nextButtonHeight, nextButtonTop, nextButtonLeft])
            }
        }
    }
}

extension HZPlaceHolderView {
    
    @objc fileprivate func clickPreviousButtonAction(_ sender: UIButton) {
        if let _clickPreviousButtonHandler = clickPreviousButtonHandler {
            _clickPreviousButtonHandler(sender, self)
        }
    }
    
    @objc fileprivate func clickNextButtonAction(_ sender: UIButton) {
        if let _clickNextButtonHandler = clickNextButtonHandler {
            _clickNextButtonHandler(sender, self)
        }
    }
}
