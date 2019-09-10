//
//  UICollectionViewExtensionn.swift
//  HZPlaceHolder
//
//  Created by 何志志 on 2019/3/11.
//  Copyright © 2019 何志志. All rights reserved.
//

import UIKit

public protocol HZCollectionViewPlaceHolderDelegate: class {
    func makePlaceHolderView() -> UIView?
    func enableScrollWhenPlaceHolderViewShowing() -> Bool?
}

public extension HZCollectionViewPlaceHolderDelegate {
    func enableScrollWhenPlaceHolderViewShowing() -> Bool? {
        return nil
    }
}

extension UICollectionView {
    
    private struct AssociatedKeys {
        static var placeHolderView = "AKPlaceHolderView"
        static var placeHolderDelegate = "AKPlaceHolderDelegate"
    }
    
    //    policy: objc_AssociationPolicy：用于保存对象的策略。可以为：
    //    OBJC_ASSOCIATION_ASSIGN：用弱引用保存对象，retain count 不会加一。
    //    OBJC_ASSOCIATION_RETAIN_NONATOMIC：以非原子方式强引用对象。
    //    OBJC_ASSOCIATION_COPY_NONATOMIC：以非原子方式复制对象。
    //    OBJC_ASSOCIATION_RETAIN：以原子方式强引用对象。
    //    OBJC_ASSOCIATION_COPY：以原子方式复制对象。
    
    private var placeHolderView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.placeHolderView) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.placeHolderView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private weak var placeHolderDelegate: HZCollectionViewPlaceHolderDelegate? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.placeHolderDelegate) as? HZCollectionViewPlaceHolderDelegate
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.placeHolderDelegate, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public func hz_reloadData() {
        self.reloadData()
        hz_checkEmpty()
    }
    
    fileprivate func hz_checkEmpty() {
        
        var isEmpty = true
        
        let src: UICollectionViewDataSource? = self.dataSource
        var sections: Int = 1
        if let _newSection = src?.numberOfSections?(in: self) {
            sections = _newSection
        }
        if let _src = src, self.placeHolderDelegate == nil   {
            self.placeHolderDelegate = _src as? HZCollectionViewPlaceHolderDelegate
        }
        for i in 0 ..< sections {
            let rows = src?.collectionView(self, numberOfItemsInSection: i)
            if let _rows = rows, _rows > 0 {
                isEmpty = false
                break
            }
        }
        
        if isEmpty, self.placeHolderView == nil {
            if let _scrollWasEnabled = self.placeHolderDelegate?.enableScrollWhenPlaceHolderViewShowing() {
                self.isScrollEnabled = _scrollWasEnabled
            }
            if let _placeHolderView = self.placeHolderDelegate?.makePlaceHolderView() {
                _placeHolderView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
                self.placeHolderView = _placeHolderView
                self.addSubview(_placeHolderView)
            }
        }else if self.placeHolderView != nil {
            self.placeHolderView?.removeFromSuperview()
            if isEmpty {
                if let _scrollWasEnabled = self.placeHolderDelegate?.enableScrollWhenPlaceHolderViewShowing() {
                    self.isScrollEnabled = _scrollWasEnabled
                }
                if let _placeHolderView = self.placeHolderDelegate?.makePlaceHolderView() {
                    _placeHolderView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
                    self.placeHolderView = _placeHolderView
                    self.addSubview(_placeHolderView)
                }
            }else {
                self.isScrollEnabled = true
                self.placeHolderView = nil
            }
        }
    }
}
