![](https://raw.githubusercontent.com/Boxzhi/HZPlaceHolder/master/Images/logo.png)


[![Version](https://img.shields.io/badge/pod-1.3.3-blue.svg)](https://github.com/Boxzhi/HZPlaceHolder) [![Build Status](https://img.shields.io/badge/build-passing-green.svg)]()
![](https://img.shields.io/badge/swift-4.2%2B-orange.svg)
![](https://img.shields.io/badge/platform-iOS%2010.0%2B-yellowgreen.svg) [![License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://github.com/Boxzhi/HZPlaceHolder/blob/master/LICENSE)



# 要求
- iOS 11.0+
- Xcode 14.0+
- Swift 5.0+


# 安装

### CocoaPods
- 如果你只需要MJRefresh的封装工具，在文件 `Podfile` 中加入 `pod 'HZPlaceHolder/Refresh'` 
- 如果你只需要空数据占位图工具，在文件 `Podfile` 中加入 `pod 'HZPlaceHolder/PlaceHolderView'` 
- 如果你两者皆需，则在文件 `Podfile` 中加入 `pod 'HZPlaceHolder'` 

### Swift Package Manager

在 Xcode 中选择 `File` -> `Add Packages...`，然后添加仓库地址：

`https://github.com/Boxzhi/HZPlaceHolder.git`

也可以在 `Package.swift` 中添加：

```swift
dependencies: [
    .package(url: "https://github.com/Boxzhi/HZPlaceHolder.git", from: "1.3.3")
]
```

然后在 target 中引用：

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "HZPlaceHolder", package: "HZPlaceHolder")
        ]
    )
]
```

SPM 当前提供的是单一模块：

`import HZPlaceHolder`

说明：
- `PlaceHolderView` 和 `Refresh` 都包含在 `HZPlaceHolder` 这个模块里
- `Refresh` 依赖 `MJRefresh`，通过 SPM 集成 `HZPlaceHolder` 时会自动拉取，无需单独添加
- CocoaPods 支持按 subspec 拆分；SPM 暂不区分子模块


# 用法

### PlaceHolderView.
<img width="400" src="https://raw.githubusercontent.com/Boxzhi/HZPlaceHolder/master/Images/HZPlaceHolderView_1.png"/>    <img width="400" src="https://raw.githubusercontent.com/Boxzhi/HZPlaceHolder/master/Images/HZPlaceHolderView_2.png"/>
<img width="400" src="https://raw.githubusercontent.com/Boxzhi/HZPlaceHolder/master/Images/HZPlaceHolderView_3.png"/>    <img width="400" src="https://raw.githubusercontent.com/Boxzhi/HZPlaceHolder/master/Images/HZPlaceHolderView_4.png"/>
<img width="800" src="https://raw.githubusercontent.com/Boxzhi/HZPlaceHolder/master/Images/HZPlaceHolderView_5.PNG"/>
<img width="800" src="https://raw.githubusercontent.com/Boxzhi/HZPlaceHolder/master/Images/HZPlaceHolderView_6.PNG"/>


① 普通使用方法：
- 第一步：`UITableView` 或 `UICollectionView` 刷新调用 `hz_reloadData`
- 第二步：`UIViewController` 继承代理 `HZTableViewPlaceHolderDelegate` 或 `HZCollectionViewPlaceHolderDelegate`
- 第三步：实现代理方法：
   - `func makePlaceHolderView() -> UIView?`  ---->  返回自定义View，也可使用 `HZPlaceHolderView`创建返回
   - `func enableScrollWhenPlaceHolderViewShowing() -> Bool`  ---->  当数据为空时是否可滚动，默认为true

示例：

```swift
import HZPlaceHolder

final class DemoViewController: UIViewController, HZTableViewPlaceHolderDelegate {

    @IBOutlet private weak var tableView: UITableView!
    private var dataSource: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.hz_reloadData()
    }

    func makePlaceHolderView() -> UIView? {
        HZPlaceHolderView.create(
            image: UIImage(named: "empty"),
            titleAttr: NSAttributedString(
                string: "暂无数据",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 16),
                    .foregroundColor: UIColor.gray
                ]
            )
        )
    }
}
```


② HZTableViewModel使用方法：
- 第一步：`UITableView` 刷新调用 `hz_reloadData`
- 第二步：调用tableViewModel的 `.makePlaceHolderViewHandler` 或 `.placeHolderView` 设置空态View


PlaceHolderView中已封装了 `HZPlaceHolderView`，使用方法如下：
```
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
```
- 除标题必传以外，其他皆为可选


-----------------------------------------------------------------------


### Refresh.

SPM 或 CocoaPods 集成后都直接：

```swift
import HZPlaceHolder
```

示例：

```swift
tableView.hz.normalRefreshWithHeader(true,
                                     refreshHeader: HZRefreshNormalHeader.self) {
    // 下拉刷新
}
```

```
/**
normal刷新
- parameter isFirstRefresh:  第一次是否自动刷新
- parameter refreshHeader:  刷新的refreshHeader
- parameter refreshFooter:  刷新的refreshFooter
- parameter headerRefreshHandler:  header刷新回调
- parameter footerRefreshHandler:  footer刷新回调
*/
```


- 只有下拉 -> `tableView.hz.normalRefreshWithHeader`
- 带BackNormalFooter
  - 上下拉 -> `tableView.hz.normalRefreshWithHeaderBackFooter`
  - 上拉 -> `tableView.hz.normalRefreshWithBackFooter`
- 带AutoNormalFooter
  - 上下拉 -> `tableView.hz.normalRefreshWithHeaderAutoFooter`
  - 上拉 -> `tableView.hz.normalRefreshWithAutoFooter`



```
/**
gif刷新
- parameter isFirstRefresh:  第一次是否自动刷新
- parameter refreshHeader:  刷新的refreshHeader
- parameter refreshFooter:  刷新的refreshFooter
- parameter headerRefreshHandler:  header刷新回调
- parameter footerRefreshHandler:  footer刷新回调
*/
```


- 只有下拉 -> `tableView.hz.gifRefreshWithHeader`
- 带BackGifFooter
  - 上下拉 -> `tableView.hz.gifRefreshWithHeaderBackFooter`
  - 上拉 -> `tableView.hz.gifRefreshWithBackFooter`
- 带AutoGifFooter
  - 上下拉 -> `tableView.hz.gifRefreshWithHeaderAutoFooter`
  - 上拉 -> `tableView.hz.gifRefreshWithAutoFooter`
