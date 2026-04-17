//
//  ViewController.swift
//  HZPlaceHolder
//
//  Created by 何志志 on 2019/9/10.
//  Copyright © 2019 何志志. All rights reserved.
//

import UIKit
import HZPlaceHolder
import MJRefresh

final class ViewController: UIViewController {

    private enum DemoMode: Int {
        case table
        case collection
    }

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "支持 TableView / CollectionView 双示例。下拉刷新加载第一页，上拉加载更多，点击“清空数据”可重新查看空态页。"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    private let modeControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Table", "Collection"])
        control.selectedSegmentIndex = 0
        return control
    }()

    private let emptyButton: UIButton = {
        let button = UIButton(title: "清空数据",
                              titleColor: .white,
                              font: .systemFont(ofSize: 15, weight: .medium),
                              backgroundColor: .red)
        button.hz_corner = 10
        return button
    }()

    private let fillButton: UIButton = {
        let button = UIButton(title: "填充10条",
                              titleColor: .white,
                              font: .systemFont(ofSize: 15, weight: .medium),
                              backgroundColor: .blue)
        button.hz_corner = 10
        return button
    }()

    private let tableView = UITableView(frame: .zero, style: .plain)
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.dataSource = collectionAdapter
        view.delegate = collectionAdapter
        view.alwaysBounceVertical = true
        return view
    }()
    private lazy var collectionAdapter = CollectionDemoAdapter(owner: self)

    fileprivate var tableItems: [String] = []
    fileprivate var collectionItems: [String] = []
    fileprivate var tablePage = 0
    fileprivate var collectionPage = 0
    private let pageSize = 10
    private let maxPage = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefresh()
        render()
    }

    private func setupUI() {
        title = "HZPlaceHolder Demo"
        view.backgroundColor = .white

        emptyButton.addTarget(self, action: #selector(showEmptyState), for: .touchUpInside)
        fillButton.addTarget(self, action: #selector(fillFirstPage), for: .touchUpInside)
        modeControl.addTarget(self, action: #selector(modeChanged), for: .valueChanged)

        let buttonStack = UIStackView(arrangedSubviews: [emptyButton, fillButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = true

        collectionView.register(DemoCollectionCell.self, forCellWithReuseIdentifier: DemoCollectionCell.reuseIdentifier)

        [infoLabel, modeControl, buttonStack, tableView, collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
            infoLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16),

            modeControl.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 12),
            modeControl.leadingAnchor.constraint(equalTo: infoLabel.leadingAnchor),
            modeControl.trailingAnchor.constraint(equalTo: infoLabel.trailingAnchor),

            buttonStack.topAnchor.constraint(equalTo: modeControl.bottomAnchor, constant: 12),
            buttonStack.leadingAnchor.constraint(equalTo: infoLabel.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: infoLabel.trailingAnchor),
            buttonStack.heightAnchor.constraint(equalToConstant: 44),

            tableView.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            collectionView.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView.isHidden = true
    }

    private func setupRefresh() {
        tableView.hz.normalRefreshWithHeaderBackFooter(false,
                                                       refreshHeader: HZRefreshNormalHeader.self,
                                                       refreshFooter: HZRefreshBackNormalFooter.self) { [weak self] in
            self?.loadFirstPage(for: .table)
        } footerRefreshHandler: { [weak self] in
            self?.loadNextPage(for: .table)
        }

        collectionView.hz.normalRefreshWithHeaderBackFooter(false,
                                                            refreshHeader: HZRefreshNormalHeader.self,
                                                            refreshFooter: HZRefreshBackNormalFooter.self) { [weak self] in
            self?.loadFirstPage(for: .collection)
        } footerRefreshHandler: { [weak self] in
            self?.loadNextPage(for: .collection)
        }
    }

    private func render() {
        tableView.hz_reloadData()
        collectionView.hz_reloadData()
        tableView.mj_footer?.isHidden = tableItems.isEmpty
        collectionView.mj_footer?.isHidden = collectionItems.isEmpty
        tableView.isHidden = currentMode != .table
        collectionView.isHidden = currentMode != .collection
    }

    private var currentMode: DemoMode {
        DemoMode(rawValue: modeControl.selectedSegmentIndex) ?? .table
    }

    private func loadFirstPage(for mode: DemoMode) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            guard let self else { return }
            switch mode {
            case .table:
                self.tablePage = 1
                self.tableItems = self.makeItems(for: self.tablePage, prefix: "列表")
                self.tableView.mj_header?.endRefreshing()
                self.tableView.mj_footer?.resetNoMoreData()
            case .collection:
                self.collectionPage = 1
                self.collectionItems = self.makeItems(for: self.collectionPage, prefix: "卡片")
                self.collectionView.mj_header?.endRefreshing()
                self.collectionView.mj_footer?.resetNoMoreData()
            }
            self.render()
        }
    }

    private func loadNextPage(for mode: DemoMode) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            guard let self else { return }
            switch mode {
            case .table:
                guard !self.tableItems.isEmpty else {
                    self.tableView.mj_footer?.endRefreshing()
                    return
                }
                if self.tablePage >= self.maxPage {
                    self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    return
                }
                self.tablePage += 1
                self.tableItems.append(contentsOf: self.makeItems(for: self.tablePage, prefix: "列表"))
                self.tableView.mj_footer?.endRefreshing()
                if self.tablePage >= self.maxPage {
                    self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                }
            case .collection:
                guard !self.collectionItems.isEmpty else {
                    self.collectionView.mj_footer?.endRefreshing()
                    return
                }
                if self.collectionPage >= self.maxPage {
                    self.collectionView.mj_footer?.endRefreshingWithNoMoreData()
                    return
                }
                self.collectionPage += 1
                self.collectionItems.append(contentsOf: self.makeItems(for: self.collectionPage, prefix: "卡片"))
                self.collectionView.mj_footer?.endRefreshing()
                if self.collectionPage >= self.maxPage {
                    self.collectionView.mj_footer?.endRefreshingWithNoMoreData()
                }
            }
            self.render()
        }
    }

    private func makeItems(for page: Int, prefix: String) -> [String] {
        let start = (page - 1) * pageSize + 1
        let end = start + pageSize - 1
        return (start...end).map { "\(prefix)示例 \($0)" }
    }

    fileprivate func makePlaceHolderView(for mode: DemoMode) -> UIView {
        let buttonTitle = mode == .table ? "点击加载" : "填充卡片"
        let message = mode == .table
            ? "当前没有列表数据\n可以下拉刷新，或者点击按钮快速填充示例数据"
            : "当前没有卡片数据\n切到 Collection 模式时可以直接看到这个空态"

        let actionButton = UIButton(title: buttonTitle,
                                    titleColor: .white,
                                    font: .systemFont(ofSize: 15, weight: .medium),
                                    backgroundColor: .blue)
        actionButton.hz_corner = 10

        return HZPlaceHolderView.create(
            titleAttr: NSAttributedString(
                string: message,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 16),
                    .foregroundColor: UIColor.gray
                ]
            ),
            tbSpace: 20,
            beforeButton: actionButton,
            clickBeforeButtonHandler: { [weak self] _, _ in
                self?.fillFirstPage()
            },
            backgroundColor: UIColor(white: 0.96, alpha: 1.0)
        )
    }

    @objc private func showEmptyState() {
        switch currentMode {
        case .table:
            tablePage = 0
            tableItems.removeAll()
            tableView.mj_header?.endRefreshing()
            tableView.mj_footer?.resetNoMoreData()
            tableView.mj_footer?.endRefreshing()
        case .collection:
            collectionPage = 0
            collectionItems.removeAll()
            collectionView.mj_header?.endRefreshing()
            collectionView.mj_footer?.resetNoMoreData()
            collectionView.mj_footer?.endRefreshing()
        }
        render()
    }

    @objc private func fillFirstPage() {
        switch currentMode {
        case .table:
            tablePage = 1
            tableItems = makeItems(for: tablePage, prefix: "列表")
            tableView.mj_footer?.resetNoMoreData()
        case .collection:
            collectionPage = 1
            collectionItems = makeItems(for: collectionPage, prefix: "卡片")
            collectionView.mj_footer?.resetNoMoreData()
        }
        render()
    }

    @objc private func modeChanged() {
        render()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseID = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: reuseID)
        cell.textLabel?.text = tableItems[indexPath.row]
        cell.detailTextLabel?.text = "第 \(tablePage) 页 · 第 \(indexPath.row + 1) 行"
        return cell
    }
}

extension ViewController: HZTableViewPlaceHolderDelegate {

    func makePlaceHolderView() -> UIView? {
        makePlaceHolderView(for: .table)
    }

    func enableScrollWhenPlaceHolderViewShowing() -> Bool {
        true
    }
}

private final class DemoCollectionCell: UICollectionViewCell {

    static let reuseIdentifier = "DemoCollectionCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(red: 0.93, green: 0.97, blue: 1.0, alpha: 1.0)
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true

        [titleLabel, subtitleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}

private final class CollectionDemoAdapter: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HZCollectionViewPlaceHolderDelegate {

    weak var owner: ViewController?

    init(owner: ViewController) {
        self.owner = owner
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        owner?.collectionItems.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DemoCollectionCell.reuseIdentifier, for: indexPath)
        if let owner, let cell = cell as? DemoCollectionCell {
            cell.configure(title: owner.collectionItems[indexPath.item], subtitle: "第 \(owner.collectionPage) 页")
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 44) / 2.0
        return CGSize(width: width, height: 92)
    }

    func makePlaceHolderView() -> UIView? {
        owner?.makePlaceHolderView(for: .collection)
    }

    func enableScrollWhenPlaceHolderViewShowing() -> Bool? {
        true
    }
}
