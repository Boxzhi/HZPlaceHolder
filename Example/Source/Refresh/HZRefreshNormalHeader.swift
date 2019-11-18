//
//  HZRefreshNormalHeader.swift
//  HZPlaceHolder
//
//  Created by 何志志 on 2018/6/26.
//  Copyright © 2018年 何志志. All rights reserved.
//

import UIKit
import MJRefresh

public class HZRefreshNormalHeader: MJRefreshNormalHeader {

    override public func prepare() {
        super.prepare()
        // 自动切换透明度
        self.isAutomaticallyChangeAlpha = true
        self.setTitle("下拉刷新", for: .idle)
        self.setTitle("松开刷新", for: .pulling)
        self.setTitle("刷新中", for: .refreshing)
        self.stateLabel?.font = UIFont.systemFont(ofSize: 13)
    }
    
}
