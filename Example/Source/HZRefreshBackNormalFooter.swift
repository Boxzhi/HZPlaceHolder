//
//  HZRefreshBackNormalFooter.swift
//  HZPlaceHolder
//
//  Created by 何志志 on 2018/6/26.
//  Copyright © 2018年 何志志. All rights reserved.
//

import UIKit
import MJRefresh

public class HZRefreshBackNormalFooter: MJRefreshBackNormalFooter {

    override public func prepare() {
        super.prepare()
        self.isAutomaticallyChangeAlpha = true
        self.stateLabel.isHidden = true
//        self.setTitle("上拉加载", for: .idle)
//        self.setTitle("松开加载", for: .pulling)
//        self.setTitle("正在加载数据", for: .refreshing)
        self.setTitle("我是有底线的", for: .noMoreData)
        self.stateLabel.font = UIFont.systemFont(ofSize: 13)
    }

}
