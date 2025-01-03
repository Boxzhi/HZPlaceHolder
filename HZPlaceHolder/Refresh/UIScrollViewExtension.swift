//
//  UIScrollViewExtension.swift
//  HZPlaceHolder
//
//  Created by 何志志 on 2019/9/10.
//  Copyright © 2019 何志志. All rights reserved.
//

import MJRefresh

public typealias HZRefreshScrollView = UIScrollView

public struct RefreshWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol RefreshCompatible: AnyObject { }

extension RefreshCompatible {
    public var hz: RefreshWrapper<Self> {
        get { return RefreshWrapper(self) }
    }
}

extension HZRefreshScrollView: RefreshCompatible { }

extension UIScrollView {
    
    /// 公共方法
    fileprivate func setRefresh<H: MJRefreshHeader, F: MJRefreshFooter>(_ isFirstRefresh: Bool = false,
                                                                                     refreshHeader: H.Type? = nil,
                                                                                     refreshFooter: F.Type? = nil,
                                                                                     headerRefreshHandler: (() -> Void)? = nil,
                                                                                     footerRefreshHandler: (() -> Void)? = nil) {
        if let _refreshHeader = refreshHeader, let _headerRefreshHandler = headerRefreshHandler {
            self.mj_header = _refreshHeader.init(refreshingBlock: {
                _headerRefreshHandler()
            })
            if isFirstRefresh {
                self.mj_header?.beginRefreshing()
            }
        }
        if let _refreshFooter = refreshFooter, let _footerRefreshHandler = footerRefreshHandler {
            self.mj_footer = _refreshFooter.init(refreshingBlock: {
                _footerRefreshHandler()
            })
        }
    }
    
}

public extension RefreshWrapper where Base: UIScrollView {
    
    
    //MARK: - --------------------------------------------- normal刷新 ---------------------------------------------
    /// normal下拉
    func normalRefreshWithHeader<H: MJRefreshNormalHeader>(_ isFirstRefresh: Bool = false,
                                                           refreshHeader: H.Type,
                                                           headerRefreshHandler: @escaping () -> Void) {
        base.setRefresh(isFirstRefresh, refreshHeader: refreshHeader, headerRefreshHandler: headerRefreshHandler)
    }
    
    //MARK: 回弹底部Footer
    /// normal下拉 + backNormal上拉
    func normalRefreshWithHeaderBackFooter<H: MJRefreshNormalHeader, F: MJRefreshBackNormalFooter>(_ isFirstRefresh: Bool = false,
                                                                              refreshHeader: H.Type,
                                                                              refreshFooter: F.Type,
                                                                              headerRefreshHandler: @escaping () -> Void,
                                                                              footerRefreshHandler: @escaping () -> Void) {
        base.setRefresh(isFirstRefresh, refreshHeader: refreshHeader, refreshFooter: refreshFooter, headerRefreshHandler: headerRefreshHandler, footerRefreshHandler: footerRefreshHandler)
    }
    
    /// backNormal上拉
    func normalRefreshWithBackFooter<F: MJRefreshBackNormalFooter>(_ refreshFooter: F.Type,
                                                                   footerRefreshHandler: @escaping () -> Void) {
        base.setRefresh(refreshFooter: refreshFooter, footerRefreshHandler: footerRefreshHandler)
    }
    
    //MARK: 自动刷新Footer
    /// normal下拉 + autoNormal上拉
    func normalRefreshWithHeaderAutoFooter<H: MJRefreshNormalHeader, F: MJRefreshAutoNormalFooter>(_ isFirstRefresh: Bool = false,
                                                                              refreshHeader: H.Type,
                                                                              refreshFooter: F.Type,
                                                                              headerRefreshHandler: @escaping () -> Void,
                                                                              footerRefreshHandler: @escaping () -> Void) {
        base.setRefresh(isFirstRefresh, refreshHeader: refreshHeader, refreshFooter: refreshFooter, headerRefreshHandler: headerRefreshHandler, footerRefreshHandler: footerRefreshHandler)
    }
    
    /// autoNormal上拉
    func normalRefreshWithAutoFooter<F: MJRefreshAutoNormalFooter>(_ refreshFooter: F.Type,
                                                                   footerRefreshHandler: @escaping () -> Void) {
        base.setRefresh(refreshFooter: refreshFooter, footerRefreshHandler: footerRefreshHandler)
    }
    
    //MARK: - --------------------------------------------- gif刷新 ---------------------------------------------
    /// gif下拉
    func gifRefreshWithHeader<H: MJRefreshGifHeader>(_ isFirstRefresh: Bool = false,
                                                           refreshHeader: H.Type,
                                                           headerRefreshHandler: @escaping () -> Void) {
        base.setRefresh(isFirstRefresh, refreshHeader: refreshHeader, headerRefreshHandler: headerRefreshHandler)
    }
    
    //MARK: 回弹底部Footer
    /// gif下拉 + backGif上拉
    func gifRefreshWithHeaderBackFooter<H: MJRefreshGifHeader, F: MJRefreshBackGifFooter>(_ isFirstRefresh: Bool = false,
                                                                              refreshHeader: H.Type,
                                                                              refreshFooter: F.Type,
                                                                              headerRefreshHandler: @escaping () -> Void,
                                                                              footerRefreshHandler: @escaping () -> Void) {
        base.setRefresh(isFirstRefresh, refreshHeader: refreshHeader, refreshFooter: refreshFooter, headerRefreshHandler: headerRefreshHandler, footerRefreshHandler: footerRefreshHandler)
    }
    
    /// backGif上拉
    func gifRefreshWithBackFooter<F: MJRefreshBackGifFooter>(_ refreshFooter: F.Type,
                                                                   footerRefreshHandler: @escaping () -> Void) {
        base.setRefresh(refreshFooter: refreshFooter, footerRefreshHandler: footerRefreshHandler)
    }
    
    //MARK: 自动刷新Footer
    /// gif下拉 + autoGif上拉
    func gifRefreshWithHeaderAutoFooter<H: MJRefreshGifHeader, F: MJRefreshAutoGifFooter>(_ isFirstRefresh: Bool = false,
                                                                              refreshHeader: H.Type,
                                                                              refreshFooter: F.Type,
                                                                              headerRefreshHandler: @escaping () -> Void,
                                                                              footerRefreshHandler: @escaping () -> Void) {
        base.setRefresh(isFirstRefresh, refreshHeader: refreshHeader, refreshFooter: refreshFooter, headerRefreshHandler: headerRefreshHandler, footerRefreshHandler: footerRefreshHandler)
    }
    
    /// autoGif上拉
    func gifRefreshWithAutoFooter<F: MJRefreshAutoGifFooter>(_ refreshFooter: F.Type,
                                                                   footerRefreshHandler: @escaping () -> Void) {
        base.setRefresh(refreshFooter: refreshFooter, footerRefreshHandler: footerRefreshHandler)
    }
    
}
