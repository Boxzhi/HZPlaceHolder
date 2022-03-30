//
//  HZTableViewModel.swift
//  HZPlaceHolder
//
//  Created by 何志志 on 2022/3/16.
//  Copyright © 2022 何志志. All rights reserved.
//

import UIKit

//MARK: --------------------------------------------------------------------------------------
//MARK: -------------------------------- HZTableViewModel --------------------------------
//MARK: --------------------------------------------------------------------------------------
// UITableViewDelegate
public typealias HZTableViewEstimatedHeightForRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> CGFloat
public typealias HZTableViewEstimatedHeightForHeaderFooterHandler = (_ tableView: UITableView, _ section: Int) -> CGFloat
public typealias HZTableViewShouldUpdateFocusInHandler = (_ tableView: UITableView, _ context: UITableViewFocusUpdateContext) -> Bool
public typealias HZTableViewDidUpdateFocusInHandler = (_ tableView: UITableView, _ context: UITableViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> Void
public typealias HZTableViewIndexPathForPreferredFocusedViewHandler = (_ tableView: UITableView) -> IndexPath?

// UITableViewDataSource
public typealias HZTableViewSectionIndexTitlesHandler = (_ tableView: UITableView) -> [String]?
public typealias HZTableViewSectionForSectionIndexTitleHandler = (_ tableView: UITableView, _ title: String, _ index: Int) -> Int
public typealias HZTableViewCommitEditingStyleHandler = (_ tableView: UITableView, _ editingStyle: UITableViewCell.EditingStyle, _ indexPath: IndexPath) -> Void
public typealias HZTableViewMoveRowAtToHandler = (_ tableView: UITableView, _ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void

// UIScrollViewDelegate
public typealias HZScrollViewHandler = (_ scrollView: UIScrollView) -> Void
public typealias HZScrollViewWillEndDraggingHandler = (_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void
public typealias HZScrollViewDidEndDraggingHandler = (_ scrollView: UIScrollView, _ decelerate: Bool) -> Void
public typealias HZScrollViewViewForZoomingHandler = (_ scrollView: UIScrollView) -> UIView?
public typealias HZScrollViewWillBeginZoomingHandler = (_ scrollView: UIScrollView, _ view: UIView?) -> Void
public typealias HZScrollViewDidEndZoomingHandler = (_ scrollView: UIScrollView, _ view: UIView?, _ scale: CGFloat) -> Void
public typealias HZScrollViewShouldScrollToTopHandler = (_ scrollView: UIScrollView) -> Bool

public class HZTableViewModel: NSObject {
    var sectionModelArray: [HZTableViewSectionModel]?
    var isShowIndex: Bool = false
    var sectionIndexTitles: [String]?
    var isShouldUpdateFocusIn: Bool = false
    var isShouldScrollToTop: Bool = true
    
    //MARK: HZTableViewPlaceHolderDelegate
    var makePlaceHolderViewHandler: (() -> UIView)?
    var placeHolderView: UIView?
    var isScrollWhenPlaceHolderViewShowing = true
    
    //MARK: UITableViewDelegate
    var estimatedHeightForRowHandler: HZTableViewEstimatedHeightForRowHandler?
    var estimatedHeightForHeaderHandler: HZTableViewEstimatedHeightForHeaderFooterHandler?
    var estimatedHeightForFooterHandler: HZTableViewEstimatedHeightForHeaderFooterHandler?
    var shouldUpdateFocusInHandler:  HZTableViewShouldUpdateFocusInHandler?
    var didUpdateFocusInHandler: HZTableViewDidUpdateFocusInHandler?
    var indexPathForPreferredFocusedViewHandler: HZTableViewIndexPathForPreferredFocusedViewHandler?
    
    //MARK: UITableViewDataSource
    var sectionIndexTitlesHandler: HZTableViewSectionIndexTitlesHandler?
    var sectionForSectionIndexTitleHandler: HZTableViewSectionForSectionIndexTitleHandler?
    var commitEditingStyleHandler: HZTableViewCommitEditingStyleHandler?
    var moveRowAtToHandler: HZTableViewMoveRowAtToHandler?
    
    //MARK: UIScrollViewDelegate
    var scrollViewDidScrollHandler: HZScrollViewHandler?
    var scrollViewDidZoomHandler: HZScrollViewHandler?
    var scrollViewWillBeginDraggingHandler: HZScrollViewHandler?
    var scrollViewWillEndDraggingHandler: HZScrollViewWillEndDraggingHandler?
    var scrollViewDidEndDraggingHandler: HZScrollViewDidEndDraggingHandler?
    var scrollViewWillBeginDeceleratingHandler: HZScrollViewHandler?
    var scrollViewDidEndDeceleratingHandler: HZScrollViewHandler?
    var scrollViewDidEndScrollingAnimationHandler: HZScrollViewHandler?
    var viewForZoomingHandler: HZScrollViewViewForZoomingHandler?
    var scrollViewWillBeginZoomingHandler: HZScrollViewWillBeginZoomingHandler?
    var scrollViewDidEndZoomingHandler: HZScrollViewDidEndZoomingHandler?
    var scrollViewShouldScrollToTopHandler: HZScrollViewShouldScrollToTopHandler?
    var scrollViewDidScrollToTopHandler: HZScrollViewHandler?
    var scrollViewDidChangeAdjustedContentInsetHandler: HZScrollViewHandler?
    
    //MARK: 初始化
    override init() {
        super.init()
        self.sectionModelArray = []
    }
    
    fileprivate func getSectionModelForSection(section: Int) -> HZTableViewSectionModel? {
        guard let _sectionModelArray = self.sectionModelArray, _sectionModelArray.count > section else {
            return nil
        }
        return _sectionModelArray[section]
    }
    
    fileprivate func getCellModelForIndexPath(indexPath: IndexPath?) -> HZTableViewCellModel? {
        guard let _indexPath = indexPath, let _sectionModelArray = self.sectionModelArray, _sectionModelArray.count > _indexPath.section, let _cellModelArray = _sectionModelArray[_indexPath.section].cellModelArray, _cellModelArray.count > _indexPath.row else {
            return nil
        }
        return _cellModelArray[_indexPath.row]
    }
    
}

//MARK: - UITableViewDelegate -------------------------------
public extension HZTableViewModel: UITableViewDelegate {
    
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

//MARK: - UITableViewDataSource -------------------------------
public extension HZTableViewModel: UITableViewDataSource {
    
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

//MARK: - UIScrollViewDelegate -------------------------------
public extension HZTableViewModel: UIScrollViewDelegate {

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

//MARK: HZTableViewPlaceHolderDelegate -------------------------------
public extension HZTableViewModel: HZTableViewPlaceHolderDelegate {
    
    func makePlaceHolderView() -> UIView? {
        if let _makePlaceHolderViewHandler = self.makePlaceHolderViewHandler {
            return _makePlaceHolderViewHandler()
        }else {
            return self.placeHolderView
        }
    }
    
    func enableScrollWhenPlaceHolderViewShowing() -> Bool {
        return self.isScrollWhenPlaceHolderViewShowing
    }
    
}


//MARK: --------------------------------------------------------------------------------------
//MARK: ---------------------------- HZTableViewSectionModel ----------------------------
//MARK: --------------------------------------------------------------------------------------
public typealias HZSectionDisplayHeaderFooterViewHandler = (_ tableView: UITableView, _ view: UIView, _ section: Int) -> Void
public typealias HZSectionViewForHeaderHandler = (_ tableView: UITableView, _ section: Int) -> UIView
public typealias HZSectionHeightForHeaderFooterInSectionHandler = (_ tableView: UITableView, _ section: Int) -> CGFloat
public typealias HZSectionTitleForHeaderFooterInSectionHandler = (_ tableView: UITableView, _ section: Int) -> String?

public class HZTableViewSectionModel: NSObject {
    var cellModelArray: [HZTableViewCellModel]?
    var headerTitle: String?
    var footerTitle: String?
    var headerHeight: CGFloat = 0.01
    var footerHeight: CGFloat = 0.01
    var headerView: UIView?
    var footerView: UIView?
    
    var willDisplayHeaderViewHandler: HZSectionDisplayHeaderFooterViewHandler?
    var willDisplayFooterViewHandler: HZSectionDisplayHeaderFooterViewHandler?
    var didEndDisplayingHeaderViewHandler: HZSectionDisplayHeaderFooterViewHandler?
    var didEndDisplayingFooterViewHandler: HZSectionDisplayHeaderFooterViewHandler?
    var viewForHeaderHandler: HZSectionViewForHeaderHandler?
    var viewForFooterHandler: HZSectionViewForHeaderHandler?
    var heightForHeaderInSectionHandler: HZSectionHeightForHeaderFooterInSectionHandler?
    var heightForFooterInSectionHandler: HZSectionHeightForHeaderFooterInSectionHandler?
    var titleForHeaderInSectionHandler: HZSectionTitleForHeaderFooterInSectionHandler?
    var titleForFooterInSectionHandler: HZSectionTitleForHeaderFooterInSectionHandler?
    
    override init() {
        super.init()
        self.headerHeight = UITableView.automaticDimension
        self.footerHeight = UITableView.automaticDimension
        self.cellModelArray = []
    }
}


//MARK: --------------------------------------------------------------------------------------
//MARK: ------------------------------ HZTableViewCellModel ------------------------------
//MARK: --------------------------------------------------------------------------------------
// UITableViewDelegate
public typealias HZCellDisplayCellHandler = (_ tableView: UITableView, _ cell: UITableViewCell, _ indexPath: IndexPath) -> Void
public typealias HZCellHeightForRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> CGFloat
public typealias HZTableViewDidHighlightRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> Void
public typealias HZCellWillSelectDeselectRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> IndexPath?
public typealias HZCellDidSelectDeselectRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> Void
public typealias HZCellEditingStyleForRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell.EditingStyle
public typealias HZCellTitleForDeleteConfirmationButtonForRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> String?
public typealias HZCellEditActionsForRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> [UITableViewRowAction]?
public typealias HZCellShouldIndentWhileEditingRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> Bool
public typealias HZCellEditingRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath?) -> Void
public typealias HZCellShouldShowMenuForRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath?) -> Bool
public typealias HZCellCanFocusRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath?) -> Bool

// UITableViewDataSource
public typealias HZCellForRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell
public typealias HZCellCanEditMoveRowHandler = (_ tableView: UITableView, _ indexPath: IndexPath) -> Bool

public class HZTableViewCellModel: NSObject {
    var height: CGFloat = 40.0
    var editingStyle: UITableViewCell.EditingStyle = .none
    var titleForDeleteConfirmationButton: String = "删除"
    var isShouldIndentWhileEditingRow: Bool = false
    var isShouldShowMenuForRow: Bool = false
    var isCanFocusRow: Bool = false
    var isCanEdit: Bool = false
    var isCanMove: Bool = false
    
    // UITableViewDelegate
    var willDisplayCellHandler: HZCellDisplayCellHandler?
    var didEndDisplayingCellHandler: HZCellDisplayCellHandler?
    var heightForRowHandler: HZCellHeightForRowHandler?
    var didHighlightRowHandler: HZTableViewDidHighlightRowHandler?
    var didUnhighlightRowHandler: HZTableViewDidHighlightRowHandler?
    var willSelectRowHandler: HZCellWillSelectDeselectRowHandler?
    var willDeselectRowHandler: HZCellWillSelectDeselectRowHandler?
    var didSelectRowHandler: HZCellDidSelectDeselectRowHandler?
    var didDeselectRowHandler: HZCellDidSelectDeselectRowHandler?
    var editingStyleForRowHandler: HZCellEditingStyleForRowHandler?
    var titleForDeleteConfirmationButtonForRowHandler: HZCellTitleForDeleteConfirmationButtonForRowHandler?
    var editActionsForRowHandler: HZCellEditActionsForRowHandler?
    var shouldIndentWhileEditingRowHandler: HZCellShouldIndentWhileEditingRowHandler?
    var willBeginEditingRowHandler: HZCellEditingRowHandler?
    var didEndEditingRowHandler: HZCellEditingRowHandler?
    var shouldShowMenuForRowHandler: HZCellShouldShowMenuForRowHandler?
    var canFocusRowHandler: HZCellCanFocusRowHandler?
    
    // UITableViewDataSource
    var cellForRowHandler: HZCellForRowHandler?
    var canEditRowHandler: HZCellCanEditMoveRowHandler?
    var canMoveRowHandler: HZCellCanEditMoveRowHandler?
}
