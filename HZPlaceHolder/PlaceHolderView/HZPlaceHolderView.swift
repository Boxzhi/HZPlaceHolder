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

public typealias HZPlaceHolderViewClickButtonHandler = ((_ button: UIButton, _ placeHolderView: HZPlaceHolderView) -> Void)
public typealias HZPlaceHolderViewClickBackgroundHandler = ((_ placeHolderView: HZPlaceHolderView) -> Void)

public class HZPlaceHolderView: UIView {
    
    fileprivate var image: UIImage? // 占位图
    fileprivate var ibSpace: CGFloat = 0 // 占位图距标题间距
    fileprivate var titleAttributedString: NSAttributedString? // 标题
    fileprivate var titleCenterYOffset: CGFloat = 0 // 标题居中偏移量
    fileprivate var subtitleAttributedString: NSAttributedString?// 副标题
    fileprivate var stSpace: CGFloat = 0 // 副标题距标题间距
    fileprivate var beforeButton: UIButton? // 前按钮
    fileprivate var btSpace: CGFloat = 0 // 前按钮距标题(副标题)间距
    fileprivate var clickBeforeButtonHandler: HZPlaceHolderViewClickButtonHandler? // 前按钮点击事件回调
    fileprivate var afterButton: UIButton? // 后按钮
    fileprivate var clickAfterButtonHandler: HZPlaceHolderViewClickButtonHandler? // 后按钮点击事件回调
    fileprivate var buttonSize: CGSize = CGSize(width: 120.0, height: 44.0) // 按钮宽高
    fileprivate var buttonSpace: CGFloat = 25.0 // 俩按钮间距
    fileprivate var buttonLayoutType: HZButtonLayoutType = .leftRight // 俩按钮布局样式
    fileprivate var clickBackgroundHandler: HZPlaceHolderViewClickBackgroundHandler? // 背景点击事件回调
    
    /// 创建空态页HZPlaceHolderView
    /// - Parameters:
    ///   - image: 占位图
    ///   - ibSpace: 占位图底部距标题顶部间距
    ///   - titleAttributedString: 标题富文本
    ///   - titleCenterYOffset: 标题水平居中偏移量
    ///   - subtitleAttributedString: 副标题富文本
    ///   - stSpace: 副标题顶部距标题底部间距
    ///   - beforeButton: 前按钮
    ///   - btSpace: 前按钮顶部距标题(副标题)底部间距
    ///   - clickBeforeButtonHandler: 前按钮点击事件回调
    ///   - afterButton: 后按钮
    ///   - clickAfterButtonHandler: 后按钮点击事件回调
    ///   - buttonSize: 按钮宽高
    ///   - buttonSpace: 俩按钮间距
    ///   - buttonLayoutType: 俩按钮布局样式
    ///   - backgroundColor: 背景色
    ///   - clickBackgroundHandler: 背景点击事件回调
    public class func create(image: Any? = nil, ibSpace: CGFloat = 15.0, titleAttributedString: NSAttributedString, titleCenterYOffset: CGFloat = 0, subtitleAttributedString: NSAttributedString? = nil, stSpace: CGFloat = 5.0, beforeButton: UIButton? = nil, btSpace: CGFloat = 35.0, clickBeforeButtonHandler: HZPlaceHolderViewClickButtonHandler? = nil, afterButton: UIButton? = nil, clickAfterButtonHandler: HZPlaceHolderViewClickButtonHandler? = nil, buttonSize: CGSize = CGSize(width: 120.0, height: 44.0), buttonSpace: CGFloat = 25.0, buttonLayoutType: HZButtonLayoutType = .leftRight, backgroundColor: UIColor = .white, clickBackgroundHandler: HZPlaceHolderViewClickBackgroundHandler? = nil) -> HZPlaceHolderView {
        return HZPlaceHolderView(image, ibSpace: ibSpace, titleAttributedString: titleAttributedString, titleCenterYOffset: titleCenterYOffset, subtitleAttributedString: subtitleAttributedString, stSpace: stSpace, beforeButton: beforeButton, btSpace: btSpace, clickBeforeButtonHandler: clickBeforeButtonHandler, afterButton: afterButton, clickAfterButtonHandler: clickAfterButtonHandler, buttonSize: buttonSize, buttonSpace: buttonSpace, buttonLayoutType: buttonLayoutType, backgroundColor: backgroundColor, clickBackgroundHandler: clickBackgroundHandler)
    }
    
    fileprivate init(_ image: Any?, ibSpace: CGFloat, titleAttributedString: NSAttributedString, titleCenterYOffset: CGFloat, subtitleAttributedString: NSAttributedString?, stSpace: CGFloat, beforeButton: UIButton?, btSpace: CGFloat, clickBeforeButtonHandler: HZPlaceHolderViewClickButtonHandler?, afterButton: UIButton?, clickAfterButtonHandler: HZPlaceHolderViewClickButtonHandler?, buttonSize: CGSize, buttonSpace: CGFloat, buttonLayoutType: HZButtonLayoutType, backgroundColor: UIColor, clickBackgroundHandler: HZPlaceHolderViewClickBackgroundHandler?) {
        super.init(frame: .zero)
        
        if let _imageString = image as? String {
            self.image = UIImage(named: _imageString)
        }else if let _image = image as? UIImage {
            self.image = _image
        }
        self.ibSpace = ibSpace
        self.titleAttributedString = titleAttributedString
        self.titleCenterYOffset = titleCenterYOffset
        self.subtitleAttributedString = subtitleAttributedString
        self.stSpace = stSpace
        self.beforeButton = beforeButton
        self.btSpace = btSpace
        self.clickBeforeButtonHandler = clickBeforeButtonHandler
        self.afterButton = afterButton
        self.clickAfterButtonHandler = clickAfterButtonHandler
        self.buttonSize = buttonSize
        self.buttonSpace = buttonSpace
        self.buttonLayoutType = buttonLayoutType
        self.backgroundColor = backgroundColor
        self.clickBackgroundHandler = clickBackgroundHandler
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {

        // 占位标题Label
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = self.titleAttributedString
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleLabelLeading = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        let titleLabelTrailing = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        let titleLabelCenterY = NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: titleCenterYOffset)
        addConstraints([titleLabelLeading, titleLabelTrailing, titleLabelCenterY])
        
        // 占位ImageView
        if let _image = self.image {
            let imageView = UIImageView(image: _image)
            self.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            let imageViewWidth = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: _image.size.width)
            let imageViewHeight = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: _image.size.height)
            let imageViewCenterX = NSLayoutConstraint( item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
            let imageViewBottom = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: titleLabel, attribute: .top, multiplier: 1.0, constant: -ibSpace)
            addConstraints([imageViewCenterX, imageViewWidth, imageViewHeight, imageViewBottom])
        }
        
        var _subtitleLabel: UILabel?
        // 占位副标题Label
        if let _subtitleAttributedString = self.subtitleAttributedString {
            let subtitleLabel = UILabel()
            subtitleLabel.numberOfLines = 0
            subtitleLabel.attributedText = _subtitleAttributedString
            self.addSubview(subtitleLabel)
            _subtitleLabel = subtitleLabel
            subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
            let subtitleLabelLeading = NSLayoutConstraint(item: subtitleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
            let subtitleLabelTrailing = NSLayoutConstraint(item: subtitleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
            let subtitleLabelTop = NSLayoutConstraint(item: subtitleLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: stSpace)
            addConstraints([subtitleLabelLeading, subtitleLabelTrailing, subtitleLabelTop])
        }
        
        // 交互背景View
        if clickBackgroundHandler != nil {
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            let tap = UITapGestureRecognizer(target: self, action: #selector(clickBackgroundAction(_:)))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            backgroundView.isUserInteractionEnabled = true
            backgroundView.addGestureRecognizer(tap)
            self.addSubview(backgroundView)
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            let backgroundViewTop = NSLayoutConstraint(item: backgroundView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
            let backgroundViewBottom = NSLayoutConstraint(item: backgroundView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
            let backgroundViewLeft = NSLayoutConstraint( item: backgroundView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0)
            let backgroundViewRight = NSLayoutConstraint(item: backgroundView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0)
            addConstraints([backgroundViewTop, backgroundViewBottom, backgroundViewLeft, backgroundViewRight])
        }
        
        // 前按钮
        if let _beforeButton = self.beforeButton {
            _beforeButton.addTarget(self, action: #selector(clickBeforeButtonAction(_:)), for: .touchUpInside)
            self.addSubview(_beforeButton)
            _beforeButton.translatesAutoresizingMaskIntoConstraints = false
            let beforeButtonWidth = NSLayoutConstraint(item: _beforeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonSize.width)
            let beforeButtonHeight = NSLayoutConstraint(item: _beforeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonSize.height)
            let beforeButtonCenterX = NSLayoutConstraint(item: _beforeButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: (buttonLayoutType == .topBottom || afterButton == nil) ? 0 : -((buttonSpace + buttonSize.width) / 2.0))
            let beforeButtonTop = NSLayoutConstraint(item: _beforeButton, attribute: .top, relatedBy: .equal, toItem: _subtitleLabel == nil ? titleLabel : _subtitleLabel!, attribute: .bottom, multiplier: 1.0, constant: btSpace)
            addConstraints([beforeButtonWidth, beforeButtonHeight, beforeButtonCenterX, beforeButtonTop])
            
            // 后按钮
            if let _afterButton = self.afterButton {
                _afterButton.addTarget(self, action: #selector(clickAfterButtonAction(_:)), for: .touchUpInside)
                self.addSubview(_afterButton)
                _afterButton.translatesAutoresizingMaskIntoConstraints = false
                let afterButtonWidth = NSLayoutConstraint(item: _afterButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonSize.width)
                let afterButtonHeight = NSLayoutConstraint(item: _afterButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonSize.height)
                let afterButtonTop = NSLayoutConstraint(item: _afterButton, attribute: .top, relatedBy: .equal, toItem: _beforeButton, attribute: .top, multiplier: 1.0, constant: buttonLayoutType == .leftRight ? 0 : (buttonSpace + buttonSize.height))
                let afterButtonLeft = NSLayoutConstraint(item: _afterButton, attribute: .left, relatedBy: .equal, toItem: _beforeButton, attribute: .left, multiplier: 1.0, constant: buttonLayoutType == .leftRight ? (buttonSpace + buttonSize.width) : 0)
                addConstraints([afterButtonWidth, afterButtonHeight, afterButtonTop, afterButtonLeft])
            }
        }
        
    }
}

extension HZPlaceHolderView {
    
    @objc fileprivate func clickBackgroundAction(_ tap: UITapGestureRecognizer) {
        clickBackgroundHandler?(self)
    }
    
    @objc fileprivate func clickBeforeButtonAction(_ sender: UIButton) {
        clickBeforeButtonHandler?(sender, self)
    }
    
    @objc fileprivate func clickAfterButtonAction(_ sender: UIButton) {
        clickAfterButtonHandler?(sender, self)
    }
    
}
