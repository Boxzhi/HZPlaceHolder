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
    
    private var image: UIImage? // 占位图
    private var itSpace: CGFloat = 0 // 占位图距标题间距
    private var titleAttr: NSAttributedString? // 标题富文本
    private var titleYMultiplier: CGFloat = 1.0 // 标题偏移比
    private var titleYConstant: CGFloat = 0 //  标题偏移量
    private var tbSpace: CGFloat = 0 // 标题与按钮间距
    private var beforeButton: UIButton? // 前按钮
    private var clickBeforeButtonHandler: HZPlaceHolderViewClickButtonHandler? // 前按钮点击事件回调
    private var afterButton: UIButton? // 后按钮
    private var clickAfterButtonHandler: HZPlaceHolderViewClickButtonHandler? // 后按钮点击事件回调
    private var buttonSize: CGSize = CGSize(width: 120.0, height: 44.0) // 按钮宽高
    private var buttonSpace: CGFloat = 25.0 // 俩按钮间距
    private var buttonLayoutType: HZButtonLayoutType = .leftRight // 俩按钮布局样式
    private var clickBackgroundHandler: HZPlaceHolderViewClickBackgroundHandler? // 背景点击事件回调
    
    private init(_ image: Any?, itSpace: CGFloat, titleAttr: NSAttributedString, titleYMultiplier: CGFloat, titleYConstant: CGFloat, tbSpace: CGFloat, beforeButton: UIButton?, clickBeforeButtonHandler: HZPlaceHolderViewClickButtonHandler?, afterButton: UIButton?, clickAfterButtonHandler: HZPlaceHolderViewClickButtonHandler?, buttonSize: CGSize, buttonSpace: CGFloat, buttonLayoutType: HZButtonLayoutType, backgroundColor: UIColor, clickBackgroundHandler: HZPlaceHolderViewClickBackgroundHandler?) {
        super.init(frame: .zero)
        
        if let _imageString = image as? String {
            self.image = UIImage(named: _imageString)
        }else if let _image = image as? UIImage {
            self.image = _image
        }
        self.itSpace = itSpace
        self.titleAttr = titleAttr
        self.titleYMultiplier = titleYMultiplier
        self.titleYConstant = titleYConstant
        self.tbSpace = tbSpace
        self.beforeButton = beforeButton
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
    
    private func setupUI() {

        // 占位标题Label
        let titleLabel = UILabel(attributedText: titleAttr)
        titleLabel.numberOfLines = 0
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleLabelCenterX = NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        let titleLabelCenterY = NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: titleYMultiplier, constant: titleYConstant)
        addConstraints([titleLabelCenterX, titleLabelCenterY])
        
        // 占位ImageView
        if let _image = self.image {
            let imageView = UIImageView(image: _image)
            self.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            let imageViewWidth = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: _image.size.width)
            let imageViewHeight = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: _image.size.height)
            let imageViewCenterX = NSLayoutConstraint( item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
            let imageViewBottom = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: titleLabel, attribute: .top, multiplier: 1.0, constant: -itSpace)
            addConstraints([imageViewCenterX, imageViewWidth, imageViewHeight, imageViewBottom])
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
            let beforeButtonTop = NSLayoutConstraint(item: _beforeButton, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: tbSpace)
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
    
    @objc private func clickBackgroundAction(_ tap: UITapGestureRecognizer) {
        clickBackgroundHandler?(self)
    }
    
    @objc private func clickBeforeButtonAction(_ sender: UIButton) {
        clickBeforeButtonHandler?(sender, self)
    }
    
    @objc private func clickAfterButtonAction(_ sender: UIButton) {
        clickAfterButtonHandler?(sender, self)
    }
    
}

extension HZPlaceHolderView {
    
    /// 创建空态页HZPlaceHolderView
    /// - Parameters:
    ///   - image: 占位图
    ///   - itSpace: 占位图与标题间距
    ///   - titleAttr: 标题富文本
    ///   - titleYMultiplier: 标题垂直偏移比
    ///   - titleYConstant: 标题垂直偏移量
    ///   - tbSpace: 标题与按钮间距
    ///   - beforeButton: 前按钮
    ///   - clickBeforeButtonHandler: 前按钮点击事件回调
    ///   - afterButton: 后按钮
    ///   - clickAfterButtonHandler: 后按钮点击事件回调
    ///   - buttonSize: 按钮宽高
    ///   - buttonSpace: 俩按钮间距
    ///   - buttonLayoutType: 俩按钮布局样式
    ///   - backgroundColor: 背景色
    ///   - clickBackgroundHandler: 背景点击事件回调
    public class func create(image: Any? = nil, itSpace: CGFloat = 15.0, titleAttr: NSAttributedString, titleYMultiplier: CGFloat = 1.0, titleYConstant: CGFloat = 0, tbSpace: CGFloat = 35.0, beforeButton: UIButton? = nil, clickBeforeButtonHandler: HZPlaceHolderViewClickButtonHandler? = nil, afterButton: UIButton? = nil, clickAfterButtonHandler: HZPlaceHolderViewClickButtonHandler? = nil, buttonSize: CGSize = CGSize(width: 120.0, height: 44.0), buttonSpace: CGFloat = 25.0, buttonLayoutType: HZButtonLayoutType = .leftRight, backgroundColor: UIColor = .white, clickBackgroundHandler: HZPlaceHolderViewClickBackgroundHandler? = nil) -> HZPlaceHolderView {
        return HZPlaceHolderView(image, itSpace: itSpace, titleAttr: titleAttr, titleYMultiplier: titleYMultiplier, titleYConstant: titleYConstant, tbSpace: tbSpace, beforeButton: beforeButton, clickBeforeButtonHandler: clickBeforeButtonHandler, afterButton: afterButton, clickAfterButtonHandler: clickAfterButtonHandler, buttonSize: buttonSize, buttonSpace: buttonSpace, buttonLayoutType: buttonLayoutType, backgroundColor: backgroundColor, clickBackgroundHandler: clickBackgroundHandler)
    }
    
    /// 更新标题偏移量
    /// - Parameter constant: 标题垂直偏移量
    public func updateTitleLabelCenterYConstraint(_ constant: CGFloat) {
        self.titleYConstant = constant
        self.constraints.forEach { layoutConstraint in
            if layoutConstraint.firstItem is UILabel, layoutConstraint.firstAttribute == .centerY {
                layoutConstraint.constant = constant
            }
        }
        self.updateConstraintsIfNeeded()
    }
    
}
