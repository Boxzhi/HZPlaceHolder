//
//  TableViewModel.swift
//  HZPlaceHolder
//
//  Created by Boxzhi on 2021/2/24.
//  Copyright © 2021 何志志. All rights reserved.
//

import UIKit
import HZPlaceHolder

//MARK: --------------------------------------------------------------------------------------
//MARK: -------------------------------- BZTableViewModel --------------------------------
//MARK: --------------------------------------------------------------------------------------
// UITableViewDelegate
public typealias BZTableViewEstimatedHeightForRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> CGFloat
public typealias BZTableViewEstimatedHeightForHeaderFooterHandler = (_ tableView: UITableView, _ section: Int) -> CGFloat
public typealias BZTableViewShouldUpdateFocusInHandler = (_ tableView: UITableView, _ context: UITableViewFocusUpdateContext) -> Bool
public typealias BZTableViewDidUpdateFocusInHandler = (_ tableView: UITableView, _ context: UITableViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> Void
public typealias BZTableViewIndexPathForPreferredFocusedViewHandler = (_ tableView: UITableView) -> IndexPath?

// UITableViewDataSource
public typealias BZTableViewSectionIndexTitlesHandler = (_ tableView: UITableView) -> [String]?
public typealias BZTableViewSectionForSectionIndexTitleHandler = (_ tableView: UITableView, _ title: String, _ index: Int) -> Int
public typealias BZTableViewCommitEditingStyleHandler = (_ tableView: UITableView, _ editingStyle: UITableViewCell.EditingStyle, _ indexPath: IndexPath) -> Void
public typealias BZTableViewMoveRowAtToHandler = (_ tableView: UITableView, _ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void

// UIScrollViewDelegate
public typealias BZScrollViewHandler = (_ scrollView: UIScrollView) -> Void
public typealias BZScrollViewWillEndDraggingHandler = (_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void
public typealias BZScrollViewDidEndDraggingHandler = (_ scrollView: UIScrollView, _ decelerate: Bool) -> Void
public typealias BZScrollViewViewForZoomingHandler = (_ scrollView: UIScrollView) -> UIView?
public typealias BZScrollViewWillBeginZoomingHandler = (_ scrollView: UIScrollView, _ view: UIView?) -> Void
public typealias BZScrollViewDidEndZoomingHandler = (_ scrollView: UIScrollView, _ view: UIView?, _ scale: CGFloat) -> Void
public typealias BZScrollViewShouldScrollToTopHandler = (_ scrollView: UIScrollView) -> Bool

 class BZTableViewModel: NSObject {
    var sectionModelArray: [BZTableViewSectionModel]?
    var isShowIndex: Bool = false
    var sectionIndexTitles: [String]?
    var isShouldUpdateFocusIn: Bool = false
    var isShouldScrollToTop: Bool = true
    
    //MARK: UITableViewDelegate
    var estimatedHeightForRowHandler: BZTableViewEstimatedHeightForRowHandler?
    var estimatedHeightForHeaderHandler: BZTableViewEstimatedHeightForHeaderFooterHandler?
    var estimatedHeightForFooterHandler: BZTableViewEstimatedHeightForHeaderFooterHandler?
    var shouldUpdateFocusInHandler:  BZTableViewShouldUpdateFocusInHandler?
    var didUpdateFocusInHandler: BZTableViewDidUpdateFocusInHandler?
    var indexPathForPreferredFocusedViewHandler: BZTableViewIndexPathForPreferredFocusedViewHandler?
    
    //MARK: UITableViewDataSource
    var sectionIndexTitlesHandler: BZTableViewSectionIndexTitlesHandler?
    var sectionForSectionIndexTitleHandler: BZTableViewSectionForSectionIndexTitleHandler?
    var commitEditingStyleHandler: BZTableViewCommitEditingStyleHandler?
    var moveRowAtToHandler: BZTableViewMoveRowAtToHandler?
    
    //MARK: UIScrollViewDelegate
    var scrollViewDidScrollHandler: BZScrollViewHandler?
    var scrollViewDidZoomHandler: BZScrollViewHandler?
    var scrollViewWillBeginDraggingHandler: BZScrollViewHandler?
    var scrollViewWillEndDraggingHandler: BZScrollViewWillEndDraggingHandler?
    var scrollViewDidEndDraggingHandler: BZScrollViewDidEndDraggingHandler?
    var scrollViewWillBeginDeceleratingHandler: BZScrollViewHandler?
    var scrollViewDidEndDeceleratingHandler: BZScrollViewHandler?
    var scrollViewDidEndScrollingAnimationHandler: BZScrollViewHandler?
    var viewForZoomingHandler: BZScrollViewViewForZoomingHandler?
    var scrollViewWillBeginZoomingHandler: BZScrollViewWillBeginZoomingHandler?
    var scrollViewDidEndZoomingHandler: BZScrollViewDidEndZoomingHandler?
    var scrollViewShouldScrollToTopHandler: BZScrollViewShouldScrollToTopHandler?
    var scrollViewDidScrollToTopHandler: BZScrollViewHandler?
    var scrollViewDidChangeAdjustedContentInsetHandler: BZScrollViewHandler?
    
    //MARK: 初始化
    override init() {
        super.init()
        self.sectionModelArray = []
    }
    
    func getSectionModelForSection(section: Int) -> BZTableViewSectionModel? {
        guard let _sectionModelArray = self.sectionModelArray, _sectionModelArray.count > section else {
            return nil
        }
        return _sectionModelArray[section]
    }
    
    func getCellModelForIndexPath(indexPath: IndexPath?) -> BZTableViewCellModel? {
        guard let _indexPath = indexPath, let _sectionModelArray = self.sectionModelArray, _sectionModelArray.count > _indexPath.section, let _cellModelArray = _sectionModelArray[_indexPath.section].cellModelArray, _cellModelArray.count > _indexPath.row else {
            return nil
        }
        return _cellModelArray[_indexPath.row]
    }
    
}

//MARK: - UITableViewDelegate
extension BZTableViewModel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cellModel = self.getCellModelForIndexPath(indexPath: indexPath) {
            cellModel.willDisplayCellHandler?(tableView, cell, indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let sectionModel = self.getSectionModelForSection(section: section) {
            sectionModel.willDisplayHeaderViewHandler?(tableView, view, section)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let sectionModel = self.getSectionModelForSection(section: section) {
            sectionModel.willDisplayFooterViewHandler?(tableView, view, section)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cellModel = self.getCellModelForIndexPath(indexPath: indexPath) {
            cellModel.didEndDisplayingCellHandler?(tableView, cell, indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if let sectionModel = self.getSectionModelForSection(section: section) {
            sectionModel.didEndDisplayingHeaderViewHandler?(tableView, view, section)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        if let sectionModel = self.getSectionModelForSection(section: section) {
            sectionModel.didEndDisplayingFooterViewHandler?(tableView, view, section)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellModel = self.getCellModelForIndexPath(indexPath: indexPath) else {
            return 0.01
        }
        if let heightForRowHandler = cellModel.heightForRowHandler {
            cellModel.height = heightForRowHandler(tableView, indexPath)
        }
        return cellModel.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionModel = self.getSectionModelForSection(section: section) else {
            return 0.01
        }
        if let heightForHeaderInSectionHandler = sectionModel.heightForHeaderInSectionHandler {
            sectionModel.headerHeight = heightForHeaderInSectionHandler(tableView, section)
        }
        return sectionModel.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let sectionModel = self.getSectionModelForSection(section: section) else {
            return 0.01
        }
        if let heightForFooterInSectionHandler = sectionModel.heightForFooterInSectionHandler {
            sectionModel.footerHeight = heightForFooterInSectionHandler(tableView, section)
        }
        return sectionModel.footerHeight
    }

//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
//
//    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
//
//    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = self.getSectionModelForSection(section: section)
        if let viewForHeaderHandler = sectionModel?.viewForHeaderHandler {
            sectionModel?.headerView = viewForHeaderHandler(tableView, section)
        }
        return sectionModel?.headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionModel = self.getSectionModelForSection(section: section)
        if let viewForFooterHandler = sectionModel?.viewForFooterHandler {
            sectionModel?.footerView = viewForFooterHandler(tableView, section)
        }
        return sectionModel?.footerView
    }

//    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
//
//    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cellModel = self.getCellModelForIndexPath(indexPath: indexPath), let didHighlightRowHandler = cellModel.didHighlightRowHandler {
            return didHighlightRowHandler(tableView, indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cellModel = self.getCellModelForIndexPath(indexPath: indexPath), let didUnhighlightRowHandler = cellModel.didUnhighlightRowHandler {
            return didUnhighlightRowHandler(tableView, indexPath)
        }
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cellModel = self.getCellModelForIndexPath(indexPath: indexPath), let handler = cellModel.willSelectRowHandler else {
            return indexPath
        }
        return handler(tableView, indexPath)
    }

    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cellModel = self.getCellModelForIndexPath(indexPath: indexPath), let handler = cellModel.willDeselectRowHandler else {
            return indexPath
        }
        return handler(tableView, indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        cellModel?.didSelectRowHandler?(tableView, indexPath)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        cellModel?.didDeselectRowHandler?(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        guard let editingStyleForRowHandler = cellModel?.editingStyleForRowHandler else {
            return cellModel?.editingStyle ?? .none
        }
        return editingStyleForRowHandler(tableView, indexPath)
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        guard let titleForDeleteConfirmationButtonForRowHandler = cellModel?.titleForDeleteConfirmationButtonForRowHandler else {
            return cellModel?.titleForDeleteConfirmationButton
        }
        return titleForDeleteConfirmationButtonForRowHandler(tableView, indexPath)
    }

//    @available(iOS, introduced: 8.0, deprecated: 13.0)
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let cellModel = self.getCellModelForIndexPath(indexPath: indexPath), let editActionsForRowHandler = cellModel.editActionsForRowHandler else {
            return nil
        }
        return editActionsForRowHandler(tableView, indexPath)
    }
    
//    @available(iOS 11.0, *)
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
//
//    @available(iOS 11.0, *)
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        if let shouldIndentWhileEditingRowHandler = cellModel?.shouldIndentWhileEditingRowHandler {
            cellModel?.isShouldIndentWhileEditingRow = shouldIndentWhileEditingRowHandler(tableView, indexPath)
        }
        return cellModel?.isShouldIndentWhileEditingRow ?? false
    }

    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        cellModel?.willBeginEditingRowHandler?(tableView, indexPath)
    }

    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        cellModel?.didEndEditingRowHandler?(tableView, indexPath)
    }

//  func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath

//  func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int

    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        if let shouldShowMenuForRowHandler = cellModel?.shouldShowMenuForRowHandler {
            cellModel?.isShouldShowMenuForRow = shouldShowMenuForRowHandler(tableView, indexPath)
        }
        return cellModel?.isShouldShowMenuForRow ?? false
    }

//  func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool

//  func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?)

    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        if let canFocusRowHandler = cellModel?.canFocusRowHandler {
            cellModel?.isCanFocusRow = canFocusRowHandler(tableView, indexPath)
        }
        return cellModel?.isCanFocusRow ?? false
    }

    func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        if let shouldUpdateFocusInHandler = self.shouldUpdateFocusInHandler {
            self.isShouldUpdateFocusIn = shouldUpdateFocusInHandler(tableView, context)
        }
        return self.isShouldUpdateFocusIn
    }

    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        self.didUpdateFocusInHandler?(tableView, context, coordinator)
    }

    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        return self.indexPathForPreferredFocusedViewHandler?(tableView)
    }

//    @available(iOS 11.0, *)
//  func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool
//
//    @available(iOS 13.0, *)
//  func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool
//
//    @available(iOS 13.0, *)
//  func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath)
//
//    @available(iOS 13.0, *)
//  func tableViewDidEndMultipleSelectionInteraction(_ tableView: UITableView)

//    @available(iOS 13.0, *)
//  func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?

//    @available(iOS 13.0, *)
//  func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?

//    @available(iOS 13.0, *)
//  func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?

//    @available(iOS 13.0, *)
//  func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating)

//    @available(iOS 14.0, *)
//  func tableView(_ tableView: UITableView, willDisplayContextMenu configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?)

//    @available(iOS 14.0, *)
//  func tableView(_ tableView: UITableView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?)
    
}

//MARK: - UITableViewDataSource
extension BZTableViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionModel = self.getSectionModelForSection(section: section), let count = sectionModel.cellModelArray?.count else {
            return 0
        }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellModel = self.getCellModelForIndexPath(indexPath: indexPath), let cellForRowHandler = cellModel.cellForRowHandler else {
            return UITableViewCell()
        }
        return cellForRowHandler(tableView, indexPath)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let count = self.sectionModelArray?.count else {
            return 0
        }
        return count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionModel = self.getSectionModelForSection(section: section) else {
            return nil
        }
        if let titleForHeaderInSectionHandler = sectionModel.titleForHeaderInSectionHandler {
            sectionModel.headerTitle = titleForHeaderInSectionHandler(tableView, section)
        }
        return sectionModel.headerTitle
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let sectionModel = self.getSectionModelForSection(section: section) else {
            return nil
        }
        if let titleForFooterInSectionHandler = sectionModel.titleForFooterInSectionHandler {
            sectionModel.footerTitle = titleForFooterInSectionHandler(tableView, section)
        }
        return sectionModel.footerTitle
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        if let canEditRowHandler = cellModel?.canEditRowHandler {
            cellModel?.isCanEdit = canEditRowHandler(tableView, indexPath)
        }
        return cellModel?.isCanEdit ?? false
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        if let canMoveRowHandler = cellModel?.canMoveRowHandler {
            cellModel?.isCanMove = canMoveRowHandler(tableView, indexPath)
        }
        return cellModel?.isCanMove ?? false
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if let _sectionIndexTitles = self.sectionIndexTitlesHandler?(tableView) {
            return _sectionIndexTitles
        }else {
            return self.sectionIndexTitles
        }
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        guard let _index =  self.sectionForSectionIndexTitleHandler?(tableView, title, index) else {
            if self.isShowIndex {
                return index
            }else {
                return Int(UInt(Foundation.NSNotFound))
            }
        }
        return _index
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.commitEditingStyleHandler?(tableView, editingStyle, indexPath)
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.moveRowAtToHandler?(tableView, sourceIndexPath, destinationIndexPath)
    }
    
}

//MARK: - UIScrollViewDelegate
extension BZTableViewModel: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollViewDidScrollHandler?(scrollView)
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.scrollViewDidZoomHandler?(scrollView)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollViewWillBeginDraggingHandler?(scrollView)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.scrollViewWillEndDraggingHandler?(scrollView, velocity, targetContentOffset)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.scrollViewDidEndDraggingHandler?(scrollView, decelerate)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewWillBeginDeceleratingHandler?(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndDeceleratingHandler?(scrollView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimationHandler?(scrollView)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.viewForZoomingHandler?(scrollView)
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.scrollViewWillBeginZoomingHandler?(scrollView, view)
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.scrollViewDidEndZoomingHandler?(scrollView, view, scale)
    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let _isShouldScrollToTop = self.scrollViewShouldScrollToTopHandler?(scrollView) {
            self.isShouldScrollToTop = _isShouldScrollToTop
        }
        return self.isShouldScrollToTop
    }

    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        self.scrollViewDidScrollToTopHandler?(scrollView)
    }
    
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        self.scrollViewDidChangeAdjustedContentInsetHandler?(scrollView)
    }
    
}

//MARK: - HZTableViewPlaceHolderDelegate
extension BZTableViewModel: HZTableViewPlaceHolderDelegate {
    
    func makePlaceHolderView() -> UIView? {
        let btn1 = UIButton(title: "1111", titleColor: .red, font: UIFont.systemFont(ofSize: 14.0))
        btn1.backgroundColor = .yellow
        let btn2 = UIButton(title: "2222", titleColor: .red, font: UIFont.systemFont(ofSize: 14.0))
        btn2.backgroundColor = .blue
        return HZPlaceHolderView.createWithTwoButton("哈哈哈哈哈哈哈哈哈哈哈\n哈哈哈哈", image: "icon_logo", previousButton: btn1, clickPreviousButtonHandler: { (btn, placeHolderView) in
            print("点击按钮一啊啊啊啊啊啊")
        }, nextButton: btn2, clickNextButtonHandler: { (btn, placeHolderView) in
            print("点击按钮二啊啊啊啊啊啊")
        }, buttonLayoutType: .leftRight, buttonSpace: 10.0) { (placeHolderView) in
            print("点击背景啊啊啊啊啊啊")
        }
    }
    
    func enableScrollWhenPlaceHolderViewShowing() -> Bool {
        return true
    }
    
}


//MARK: --------------------------------------------------------------------------------------
//MARK: ---------------------------- BZTableViewSectionModel ----------------------------
//MARK: --------------------------------------------------------------------------------------
public typealias BZSectionDisplayHeaderFooterViewHandler = (_ tableView: UITableView, _ view: UIView, _ section: Int) -> Void
public typealias BZSectionViewForHeaderHandler = (_ tableView: UITableView, _ section: Int) -> UIView
public typealias BZSectionHeightForHeaderFooterInSectionHandler = (_ tableView: UITableView, _ section: Int) -> CGFloat
public typealias BZSectionTitleForHeaderFooterInSectionHandler = (_ tableView: UITableView, _ section: Int) -> String?

class BZTableViewSectionModel: NSObject {
    var cellModelArray: [BZTableViewCellModel]?
    var headerTitle: String?
    var footerTitle: String?
    var headerHeight: CGFloat = 0.01
    var footerHeight: CGFloat = 0.01
    var headerView: UIView?
    var footerView: UIView?
    
    var willDisplayHeaderViewHandler: BZSectionDisplayHeaderFooterViewHandler?
    var willDisplayFooterViewHandler: BZSectionDisplayHeaderFooterViewHandler?
    var didEndDisplayingHeaderViewHandler: BZSectionDisplayHeaderFooterViewHandler?
    var didEndDisplayingFooterViewHandler: BZSectionDisplayHeaderFooterViewHandler?
    var viewForHeaderHandler: BZSectionViewForHeaderHandler?
    var viewForFooterHandler: BZSectionViewForHeaderHandler?
    var heightForHeaderInSectionHandler: BZSectionHeightForHeaderFooterInSectionHandler?
    var heightForFooterInSectionHandler: BZSectionHeightForHeaderFooterInSectionHandler?
    var titleForHeaderInSectionHandler: BZSectionTitleForHeaderFooterInSectionHandler?
    var titleForFooterInSectionHandler: BZSectionTitleForHeaderFooterInSectionHandler?
    
    override init() {
        super.init()
        self.headerHeight = UITableView.automaticDimension
        self.footerHeight = UITableView.automaticDimension
        self.cellModelArray = []
    }
}


//MARK: --------------------------------------------------------------------------------------
//MARK: ------------------------------ BZTableViewCellModel ------------------------------
//MARK: --------------------------------------------------------------------------------------
// UITableViewDelegate
public typealias BZCellDisplayCellHandler = (_ tableView: UITableView, _ cell: UITableViewCell, _ indexPath: IndexPath) -> Void
public typealias BZCellHeightForRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> CGFloat
public typealias BZTableViewDidHighlightRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> Void
public typealias BZCellWillSelectDeselectRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> IndexPath?
public typealias BZCellDidSelectDeselectRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> Void
public typealias BZCellEditingStyleForRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell.EditingStyle
public typealias BZCellTitleForDeleteConfirmationButtonForRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> String?
public typealias BZCellEditActionsForRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> [UITableViewRowAction]?
public typealias BZCellShouldIndentWhileEditingRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> Bool
public typealias BZCellEditingRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath?) -> Void
public typealias BZCellShouldShowMenuForRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath?) -> Bool
public typealias BZCellCanFocusRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath?) -> Bool

// UITableViewDataSource
public typealias BZCellForRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell
public typealias BZCellCanEditMoveRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> Bool

class BZTableViewCellModel: NSObject {
    var height: CGFloat = 40.0
    var editingStyle: UITableViewCell.EditingStyle = .none
    var titleForDeleteConfirmationButton: String = "删除"
    var isShouldIndentWhileEditingRow: Bool = false
    var isShouldShowMenuForRow: Bool = false
    var isCanFocusRow: Bool = false
    var isCanEdit: Bool = false
    var isCanMove: Bool = false
    
    // UITableViewDelegate
    var willDisplayCellHandler: BZCellDisplayCellHandler?
    var didEndDisplayingCellHandler: BZCellDisplayCellHandler?
    var heightForRowHandler: BZCellHeightForRowHandler?
    var didHighlightRowHandler: BZTableViewDidHighlightRowHandler?
    var didUnhighlightRowHandler: BZTableViewDidHighlightRowHandler?
    var willSelectRowHandler: BZCellWillSelectDeselectRowHandler?
    var willDeselectRowHandler: BZCellWillSelectDeselectRowHandler?
    var didSelectRowHandler: BZCellDidSelectDeselectRowHandler?
    var didDeselectRowHandler: BZCellDidSelectDeselectRowHandler?
    var editingStyleForRowHandler: BZCellEditingStyleForRowHandler?
    var titleForDeleteConfirmationButtonForRowHandler: BZCellTitleForDeleteConfirmationButtonForRowHandler?
    var editActionsForRowHandler: BZCellEditActionsForRowHandler?
    var shouldIndentWhileEditingRowHandler: BZCellShouldIndentWhileEditingRowHandler?
    var willBeginEditingRowHandler: BZCellEditingRowHandler?
    var didEndEditingRowHandler: BZCellEditingRowHandler?
    var shouldShowMenuForRowHandler: BZCellShouldShowMenuForRowHandler?
    var canFocusRowHandler: BZCellCanFocusRowHandler?
    
    // UITableViewDataSource
    var cellForRowHandler: BZCellForRowHandler?
    var canEditRowHandler: BZCellCanEditMoveRowHandler?
    var canMoveRowHandler: BZCellCanEditMoveRowHandler?
}
