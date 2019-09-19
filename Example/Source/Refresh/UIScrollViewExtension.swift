//
//  UIScrollViewExtension.swift
//  HZPlaceHolder
//
//  Created by 何志志 on 2019/9/10.
//  Copyright © 2019 何志志. All rights reserved.
//

import MJRefresh

extension UIScrollView {
    
    //MARK: - normal刷新
    /// 上下拉
    public func hz_normalRefreshWithHeaderFooter<H: MJRefreshNormalHeader, F: MJRefreshFooter>(_ isFirstRefresh: Bool = false,
                                                                                               refreshHeader: H.Type = HZRefreshNormalHeader.self as! H.Type,
                                                                                               refreshFooter: F.Type = HZRefreshBackNormalFooter.self as! F.Type,
                                                                                               headerRefreshHandler: @escaping () -> Void,
                                                                                               footerRefreshHandler: @escaping () -> Void) {
        self.setNormalRefresh(isFirstRefresh, refreshHeader: refreshHeader, refreshFooter: refreshFooter, headerRefreshHandler: headerRefreshHandler, footerRefreshHandler: footerRefreshHandler)
    }
    
    /// 下拉
    public func hz_normalRefreshWithHeader<H: MJRefreshNormalHeader>(_ isFirstRefresh: Bool = false,
                                                                     refreshHeader: H.Type = HZRefreshNormalHeader.self as! H.Type,
                                                                     headerRefreshHandler: @escaping () -> Void) {
        self.setNormalRefresh(isFirstRefresh, refreshHeader: refreshHeader, headerRefreshHandler: headerRefreshHandler)
    }
    
    /// 上拉
    public func hz_normalRefreshWithFooter<F: MJRefreshFooter>(_ refreshFooter: F.Type = HZRefreshBackNormalFooter.self as! F.Type,
                                                               footerRefreshHandler: @escaping () -> Void) {
        self.setNormalRefresh(refreshFooter: refreshFooter, footerRefreshHandler: footerRefreshHandler)
    }
    
    fileprivate func setNormalRefresh<H: MJRefreshNormalHeader, F: MJRefreshFooter>(_ isFirstRefresh: Bool = false,
                                                                                    refreshHeader: H.Type? = nil,
                                                                                    refreshFooter: F.Type? = nil,
                                                                                    headerRefreshHandler: (() -> Void)? = nil,
                                                                                    footerRefreshHandler: (() -> Void)? = nil) {
        if let _refreshHeader = refreshHeader, let _headerRefreshHandler = headerRefreshHandler {
            self.mj_header = _refreshHeader.init(refreshingBlock: {
                _headerRefreshHandler()
            })
            if isFirstRefresh {
                self.mj_header.beginRefreshing()
            }
        }
        if let _refreshFooter = refreshFooter, let _footerRefreshHandler = footerRefreshHandler {
            self.mj_footer = _refreshFooter.init(refreshingBlock: {
                _footerRefreshHandler()
            })
        }
    }
    
    //MARK: - gif刷新
    /// 上下拉
    public func hz_gifRefreshWithHeaderFooter<H: MJRefreshGifHeader, F: MJRefreshBackGifFooter>(_ isFirstRefresh: Bool = false,
                                                                                                refreshHeader: H.Type,
                                                                                                refreshFooter: F.Type,
                                                                                                headerRefreshHandler: @escaping () -> Void,
                                                                                                footerRefreshHandler: @escaping () -> Void) {
        self.setGifRefresh(isFirstRefresh, refreshHeader: refreshHeader, refreshFooter: refreshFooter, headerRefreshHandler: headerRefreshHandler, footerRefreshHandler: footerRefreshHandler)
    }
    
    /// 下拉
    public func hz_gifRefreshWithHeader<H: MJRefreshGifHeader>(_ isFirstRefresh: Bool = false,
                                                               refreshHeader: H.Type,
                                                               headerRefreshHandler: @escaping () -> Void) {
        self.setGifRefresh(isFirstRefresh, refreshHeader: refreshHeader, headerRefreshHandler: headerRefreshHandler)
    }
    
    /// 上拉
    public func hz_gifRefreshWithFooter<F: MJRefreshBackGifFooter>(_ refreshFooter: F.Type,
                                                                   footerRefreshHandler: @escaping () -> Void) {
        self.setGifRefresh(refreshFooter: refreshFooter, footerRefreshHandler: footerRefreshHandler)
    }
    
    fileprivate func setGifRefresh<H: MJRefreshGifHeader, F: MJRefreshBackGifFooter>(_ isFirstRefresh: Bool = false,
                                                                                     refreshHeader: H.Type? = nil,
                                                                                     refreshFooter: F.Type? = nil,
                                                                                     headerRefreshHandler: (() -> Void)? = nil,
                                                                                     footerRefreshHandler: (() -> Void)? = nil) {
        if let _refreshHeader = refreshHeader, let _headerRefreshHandler = headerRefreshHandler {
            self.mj_header = _refreshHeader.init(refreshingBlock: {
                _headerRefreshHandler()
            })
            if isFirstRefresh {
                self.mj_header.beginRefreshing()
            }
        }
        if let _refreshFooter = refreshFooter, let _footerRefreshHandler = footerRefreshHandler {
            self.mj_footer = _refreshFooter.init(refreshingBlock: {
                _footerRefreshHandler()
            })
        }
    }
    
}
