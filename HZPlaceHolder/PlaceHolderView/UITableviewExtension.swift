//
//  UITableviewExtension.swift
//  HZPlaceHolder
//
//  Created by 何志志 on 2019/3/11.
//  Copyright © 2019 何志志. All rights reserved.
//

import UIKit

public struct UITableViewWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol UITableViewCompatible: AnyObject { }

extension UITableViewCompatible {

    public var hz: UITableViewWrapper<Self> {
        get { return UITableViewWrapper(self) }
    }
    
}

extension UITableView: UITableViewCompatible {}

public extension UITableViewWrapper where Base: UITableView {
    
    func reload() {
        base.hz_reloadData()
    }
    
}

public protocol HZTableViewPlaceHolderDelegate: AnyObject {
    func makePlaceHolderView() -> UIView?
    func enableScrollWhenPlaceHolderViewShowing() -> Bool
}

public extension HZTableViewPlaceHolderDelegate {
    func enableScrollWhenPlaceHolderViewShowing() -> Bool {
        return true
    }
}

final class WeakBox {
    weak var value: AnyObject?
    init(_ value: AnyObject?) {
        self.value = value
    }
}

extension UITableView {
    
    private struct AssociatedKeys {
        static var placeHolderView: UInt8 = 0
        static var placeHolderDelegate: UInt8 = 0
    }
    
    private var placeHolderView: UIView? {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.placeHolderView) as? UIView
        }
        set {
            objc_setAssociatedObject(
                self, &AssociatedKeys.placeHolderView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    private var placeHolderDelegate: HZTableViewPlaceHolderDelegate? {
        get {
            (objc_getAssociatedObject(self, &AssociatedKeys.placeHolderDelegate) as? WeakBox)?.value as? HZTableViewPlaceHolderDelegate
        }
        set {
            objc_setAssociatedObject(
                self, &AssociatedKeys.placeHolderDelegate, WeakBox(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func hz_reloadData() {
        self.reloadData()
        hz_checkEmpty()
    }
    
    fileprivate func hz_checkEmpty() {
        
        // 是否要显示空数据视图
        var isEmpty = true
        
        let src: UITableViewDataSource? = self.dataSource
        let delegate: UITableViewDelegate? = self.delegate
        
        if placeHolderDelegate == nil, let _src = src as? HZTableViewPlaceHolderDelegate {
            self.placeHolderDelegate = _src
        }
        
        if let sections = src?.numberOfSections?(in: self) {   // 若代理实现了numberOfSections方法, 默认有多个分组, 需先判断section是否为0
            isEmpty = sections == 0
            if sections == 1 {  // tableview的分组数是否为1, 用于判断外部实现了numberOfSections并写死==1的情况
                if let row = src?.tableView(self, numberOfRowsInSection: (sections - 1)), row == 0 {  // tableview在分组为1的情况下, row个数是否为0
                    // tableview在分组为1的情况下, row个数为0的情况下, 判断headerView的高度是否为0.01
                    if let _ = delegate?.tableView?(self, viewForHeaderInSection: (sections - 1)), let headHeight = delegate?.tableView?(self, heightForHeaderInSection: (sections - 1)), headHeight > 0.01 {
                        isEmpty = false
                    }else {
                        isEmpty = true
                    }
                }else {
                    isEmpty = false
                }
            }
        }else {
            let rows = src?.tableView(self, numberOfRowsInSection: 0)
            if let _rows = rows, _rows > 0 {
                isEmpty = false
            }
        }
        
        if isEmpty, self.placeHolderView == nil {
            if let _scrollWasEnabled = self.placeHolderDelegate?.enableScrollWhenPlaceHolderViewShowing() {
                self.isScrollEnabled = _scrollWasEnabled
            }
            if let _placeHolderView = self.placeHolderDelegate?.makePlaceHolderView() {
//                _placeHolderView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
                self.placeHolderView = _placeHolderView
                self.addSubview(_placeHolderView)
                addPlaceHolderViewConstraints(_placeHolderView)
            }
        }else if self.placeHolderView != nil {
            self.placeHolderView?.removeFromSuperview()
            if isEmpty {
                if let _scrollWasEnabled = self.placeHolderDelegate?.enableScrollWhenPlaceHolderViewShowing() {
                    self.isScrollEnabled = _scrollWasEnabled
                }
                if let _placeHolderView = self.placeHolderDelegate?.makePlaceHolderView() {
//                    _placeHolderView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
                    self.placeHolderView = _placeHolderView
                    self.addSubview(_placeHolderView)
                    addPlaceHolderViewConstraints(_placeHolderView)
                }
            }else {
                self.isScrollEnabled = true
                self.placeHolderView = nil
            }
        }
    }
    
}

