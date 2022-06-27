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
    public var sectionModelArray: [HZTableViewSectionModel]?
    public var isShowIndex: Bool = false
    public var sectionIndexTitles: [String]?
    public var isShouldUpdateFocusIn: Bool = false
    public var isShouldScrollToTop: Bool = true
    
    //MARK: HZTableViewPlaceHolderDelegate
    public var makePlaceHolderViewHandler: (() -> UIView)?
    public var placeHolderView: UIView?
    public var isScrollWhenPlaceHolderViewShowing = true
    
    //MARK: UITableViewDelegate
    public var estimatedHeightForRowHandler: HZTableViewEstimatedHeightForRowHandler?
    public var estimatedHeightForHeaderHandler: HZTableViewEstimatedHeightForHeaderFooterHandler?
    public var estimatedHeightForFooterHandler: HZTableViewEstimatedHeightForHeaderFooterHandler?
    public var shouldUpdateFocusInHandler:  HZTableViewShouldUpdateFocusInHandler?
    public var didUpdateFocusInHandler: HZTableViewDidUpdateFocusInHandler?
    public var indexPathForPreferredFocusedViewHandler: HZTableViewIndexPathForPreferredFocusedViewHandler?
    
    //MARK: UITableViewDataSource
    public var sectionIndexTitlesHandler: HZTableViewSectionIndexTitlesHandler?
    public var sectionForSectionIndexTitleHandler: HZTableViewSectionForSectionIndexTitleHandler?
    public var commitEditingStyleHandler: HZTableViewCommitEditingStyleHandler?
    public var moveRowAtToHandler: HZTableViewMoveRowAtToHandler?
    
    //MARK: UIScrollViewDelegate
    public var scrollViewDidScrollHandler: HZScrollViewHandler?
    public var scrollViewDidZoomHandler: HZScrollViewHandler?
    public var scrollViewWillBeginDraggingHandler: HZScrollViewHandler?
    public var scrollViewWillEndDraggingHandler: HZScrollViewWillEndDraggingHandler?
    public var scrollViewDidEndDraggingHandler: HZScrollViewDidEndDraggingHandler?
    public var scrollViewWillBeginDeceleratingHandler: HZScrollViewHandler?
    public var scrollViewDidEndDeceleratingHandler: HZScrollViewHandler?
    public var scrollViewDidEndScrollingAnimationHandler: HZScrollViewHandler?
    public var viewForZoomingHandler: HZScrollViewViewForZoomingHandler?
    public var scrollViewWillBeginZoomingHandler: HZScrollViewWillBeginZoomingHandler?
    public var scrollViewDidEndZoomingHandler: HZScrollViewDidEndZoomingHandler?
    public var scrollViewShouldScrollToTopHandler: HZScrollViewShouldScrollToTopHandler?
    public var scrollViewDidScrollToTopHandler: HZScrollViewHandler?
    public var scrollViewDidChangeAdjustedContentInsetHandler: HZScrollViewHandler?
    
    //MARK: 初始化
    public override init() {
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
extension HZTableViewModel: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cellModel = self.getCellModelForIndexPath(indexPath: indexPath) {
            cellModel.willDisplayCellHandler?(tableView, cell, indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let sectionModel = self.getSectionModelForSection(section: section) {
            sectionModel.willDisplayHeaderViewHandler?(tableView, view, section)
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let sectionModel = self.getSectionModelForSection(section: section) {
            sectionModel.willDisplayFooterViewHandler?(tableView, view, section)
        }
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cellModel = self.getCellModelForIndexPath(indexPath: indexPath) {
            cellModel.didEndDisplayingCellHandler?(tableView, cell, indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if let sectionModel = self.getSectionModelForSection(section: section) {
            sectionModel.didEndDisplayingHeaderViewHandler?(tableView, view, section)
        }
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        if let sectionModel = self.getSectionModelForSection(section: section) {
            sectionModel.didEndDisplayingFooterViewHandler?(tableView, view, section)
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellModel = self.getCellModelForIndexPath(indexPath: indexPath) else {
            return 0.01
        }
        if let heightForRowHandler = cellModel.heightForRowHandler {
            cellModel.height = heightForRowHandler(tableView, indexPath)
        }
        return cellModel.height
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionModel = self.getSectionModelForSection(section: section) else {
            return 0.01
        }
        if let heightForHeaderInSectionHandler = sectionModel.heightForHeaderInSectionHandler {
            sectionModel.headerHeight = heightForHeaderInSectionHandler(tableView, section)
        }
        return sectionModel.headerHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let sectionModel = self.getSectionModelForSection(section: section) else {
            return 0.01
        }
        if let heightForFooterInSectionHandler = sectionModel.heightForFooterInSectionHandler {
            sectionModel.footerHeight = heightForFooterInSectionHandler(tableView, section)
        }
        return sectionModel.footerHeight
    }

//    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
//
//    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
//
//    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = self.getSectionModelForSection(section: section)
        if let viewForHeaderHandler = sectionModel?.viewForHeaderHandler {
            sectionModel?.headerView = viewForHeaderHandler(tableView, section)
        }
        return sectionModel?.headerView
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionModel = self.getSectionModelForSection(section: section)
        if let viewForFooterHandler = sectionModel?.viewForFooterHandler {
            sectionModel?.footerView = viewForFooterHandler(tableView, section)
        }
        return sectionModel?.footerView
    }

//    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
//
//    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool

    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cellModel = self.getCellModelForIndexPath(indexPath: indexPath), let didHighlightRowHandler = cellModel.didHighlightRowHandler {
            return didHighlightRowHandler(tableView, indexPath)
        }
    }

    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cellModel = self.getCellModelForIndexPath(indexPath: indexPath), let didUnhighlightRowHandler = cellModel.didUnhighlightRowHandler {
            return didUnhighlightRowHandler(tableView, indexPath)
        }
    }

    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cellModel = self.getCellModelForIndexPath(indexPath: indexPath), let handler = cellModel.willSelectRowHandler else {
            return indexPath
        }
        return handler(tableView, indexPath)
    }

    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cellModel = self.getCellModelForIndexPath(indexPath: indexPath), let handler = cellModel.willDeselectRowHandler else {
            return indexPath
        }
        return handler(tableView, indexPath)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        cellModel?.didSelectRowHandler?(tableView, indexPath)
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        cellModel?.didDeselectRowHandler?(tableView, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        guard let editingStyleForRowHandler = cellModel?.editingStyleForRowHandler else {
            return cellModel?.editingStyle ?? .none
        }
        return editingStyleForRowHandler(tableView, indexPath)
    }

    public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        guard let titleForDeleteConfirmationButtonForRowHandler = cellModel?.titleForDeleteConfirmationButtonForRowHandler else {
            return cellModel?.titleForDeleteConfirmationButton
        }
        return titleForDeleteConfirmationButtonForRowHandler(tableView, indexPath)
    }

//    @available(iOS, introduced: 8.0, deprecated: 13.0)
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let cellModel = self.getCellModelForIndexPath(indexPath: indexPath), let editActionsForRowHandler = cellModel.editActionsForRowHandler else {
            return nil
        }
        return editActionsForRowHandler(tableView, indexPath)
    }
    
//    @available(iOS 11.0, *)
//    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
//
//    @available(iOS 11.0, *)
//    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?

    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        if let shouldIndentWhileEditingRowHandler = cellModel?.shouldIndentWhileEditingRowHandler {
            cellModel?.isShouldIndentWhileEditingRow = shouldIndentWhileEditingRowHandler(tableView, indexPath)
        }
        return cellModel?.isShouldIndentWhileEditingRow ?? false
    }

    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        cellModel?.willBeginEditingRowHandler?(tableView, indexPath)
    }

    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        cellModel?.didEndEditingRowHandler?(tableView, indexPath)
    }

//  func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath

//  func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int

    public func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        if let shouldShowMenuForRowHandler = cellModel?.shouldShowMenuForRowHandler {
            cellModel?.isShouldShowMenuForRow = shouldShowMenuForRowHandler(tableView, indexPath)
        }
        return cellModel?.isShouldShowMenuForRow ?? false
    }

//  func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool

//  func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?)

    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        if let canFocusRowHandler = cellModel?.canFocusRowHandler {
            cellModel?.isCanFocusRow = canFocusRowHandler(tableView, indexPath)
        }
        return cellModel?.isCanFocusRow ?? false
    }

    public func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        if let shouldUpdateFocusInHandler = self.shouldUpdateFocusInHandler {
            self.isShouldUpdateFocusIn = shouldUpdateFocusInHandler(tableView, context)
        }
        return self.isShouldUpdateFocusIn
    }

    public func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        self.didUpdateFocusInHandler?(tableView, context, coordinator)
    }

    public func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
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
extension HZTableViewModel: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionModel = self.getSectionModelForSection(section: section), let count = sectionModel.cellModelArray?.count else {
            return 0
        }
        return count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellModel = self.getCellModelForIndexPath(indexPath: indexPath), let cellForRowHandler = cellModel.cellForRowHandler else {
            return UITableViewCell()
        }
        return cellForRowHandler(tableView, indexPath)
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let count = self.sectionModelArray?.count else {
            return 0
        }
        return count
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionModel = self.getSectionModelForSection(section: section) else {
            return nil
        }
        if let titleForHeaderInSectionHandler = sectionModel.titleForHeaderInSectionHandler {
            sectionModel.headerTitle = titleForHeaderInSectionHandler(tableView, section)
        }
        return sectionModel.headerTitle
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let sectionModel = self.getSectionModelForSection(section: section) else {
            return nil
        }
        if let titleForFooterInSectionHandler = sectionModel.titleForFooterInSectionHandler {
            sectionModel.footerTitle = titleForFooterInSectionHandler(tableView, section)
        }
        return sectionModel.footerTitle
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        if let canEditRowHandler = cellModel?.canEditRowHandler {
            cellModel?.isCanEdit = canEditRowHandler(tableView, indexPath)
        }
        return cellModel?.isCanEdit ?? false
    }

    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let cellModel = self.getCellModelForIndexPath(indexPath: indexPath)
        if let canMoveRowHandler = cellModel?.canMoveRowHandler {
            cellModel?.isCanMove = canMoveRowHandler(tableView, indexPath)
        }
        return cellModel?.isCanMove ?? false
    }

    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if let _sectionIndexTitles = self.sectionIndexTitlesHandler?(tableView) {
            return _sectionIndexTitles
        }else {
            return self.sectionIndexTitles
        }
    }

    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        guard let _index =  self.sectionForSectionIndexTitleHandler?(tableView, title, index) else {
            if self.isShowIndex {
                return index
            }else {
                return Int(UInt(Foundation.NSNotFound))
            }
        }
        return _index
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.commitEditingStyleHandler?(tableView, editingStyle, indexPath)
    }

    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.moveRowAtToHandler?(tableView, sourceIndexPath, destinationIndexPath)
    }
    
}

//MARK: - UIScrollViewDelegate -------------------------------
extension HZTableViewModel: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollViewDidScrollHandler?(scrollView)
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.scrollViewDidZoomHandler?(scrollView)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollViewWillBeginDraggingHandler?(scrollView)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.scrollViewWillEndDraggingHandler?(scrollView, velocity, targetContentOffset)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.scrollViewDidEndDraggingHandler?(scrollView, decelerate)
    }

    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewWillBeginDeceleratingHandler?(scrollView)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndDeceleratingHandler?(scrollView)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimationHandler?(scrollView)
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.viewForZoomingHandler?(scrollView)
    }

    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.scrollViewWillBeginZoomingHandler?(scrollView, view)
    }

    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.scrollViewDidEndZoomingHandler?(scrollView, view, scale)
    }

    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let _isShouldScrollToTop = self.scrollViewShouldScrollToTopHandler?(scrollView) {
            self.isShouldScrollToTop = _isShouldScrollToTop
        }
        return self.isShouldScrollToTop
    }

    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        self.scrollViewDidScrollToTopHandler?(scrollView)
    }
    
    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        self.scrollViewDidChangeAdjustedContentInsetHandler?(scrollView)
    }
    
}

//MARK: HZTableViewPlaceHolderDelegate -------------------------------
extension HZTableViewModel: HZTableViewPlaceHolderDelegate {
    
    public func makePlaceHolderView() -> UIView? {
        if let _makePlaceHolderViewHandler = self.makePlaceHolderViewHandler {
            return _makePlaceHolderViewHandler()
        }else {
            return self.placeHolderView
        }
    }
    
    public func enableScrollWhenPlaceHolderViewShowing() -> Bool {
        return self.isScrollWhenPlaceHolderViewShowing
    }
    
}


//MARK: --------------------------------------------------------------------------------------
//MARK: ---------------------------- HZTableViewSectionModel ----------------------------
//MARK: --------------------------------------------------------------------------------------
public typealias HZSectionDisplayHeaderFooterViewHandler = (_ tableView: UITableView, _ view: UIView, _ section: Int) -> Void
public typealias HZSectionViewForHeaderFooterHandler = (_ tableView: UITableView, _ section: Int) -> UIView?
public typealias HZSectionHeightForHeaderFooterInSectionHandler = (_ tableView: UITableView, _ section: Int) -> CGFloat
public typealias HZSectionTitleForHeaderFooterInSectionHandler = (_ tableView: UITableView, _ section: Int) -> String?

public class HZTableViewSectionModel: NSObject {
    public var cellModelArray: [HZTableViewCellModel]?
    public var headerTitle: String?
    public var footerTitle: String?
    public var headerHeight: CGFloat = 0.01
    public var footerHeight: CGFloat = 0.01
    public var headerView: UIView?
    public var footerView: UIView?
    
    public var willDisplayHeaderViewHandler: HZSectionDisplayHeaderFooterViewHandler?
    public var willDisplayFooterViewHandler: HZSectionDisplayHeaderFooterViewHandler?
    public var didEndDisplayingHeaderViewHandler: HZSectionDisplayHeaderFooterViewHandler?
    public var didEndDisplayingFooterViewHandler: HZSectionDisplayHeaderFooterViewHandler?
    public var viewForHeaderHandler: HZSectionViewForHeaderFooterHandler?
    public var viewForFooterHandler: HZSectionViewForHeaderFooterHandler?
    public var heightForHeaderInSectionHandler: HZSectionHeightForHeaderFooterInSectionHandler?
    public var heightForFooterInSectionHandler: HZSectionHeightForHeaderFooterInSectionHandler?
    public var titleForHeaderInSectionHandler: HZSectionTitleForHeaderFooterInSectionHandler?
    public var titleForFooterInSectionHandler: HZSectionTitleForHeaderFooterInSectionHandler?
    
    public override init() {
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
    public var height: CGFloat = 40.0
    public var editingStyle: UITableViewCell.EditingStyle = .none
    public var titleForDeleteConfirmationButton: String = "删除"
    public var isShouldIndentWhileEditingRow: Bool = false
    public var isShouldShowMenuForRow: Bool = false
    public var isCanFocusRow: Bool = false
    public var isCanEdit: Bool = false
    public var isCanMove: Bool = false
    
    // UITableViewDelegate
    public var willDisplayCellHandler: HZCellDisplayCellHandler?
    public var didEndDisplayingCellHandler: HZCellDisplayCellHandler?
    public var heightForRowHandler: HZCellHeightForRowHandler?
    public var didHighlightRowHandler: HZTableViewDidHighlightRowHandler?
    public var didUnhighlightRowHandler: HZTableViewDidHighlightRowHandler?
    public var willSelectRowHandler: HZCellWillSelectDeselectRowHandler?
    public var willDeselectRowHandler: HZCellWillSelectDeselectRowHandler?
    public var didSelectRowHandler: HZCellDidSelectDeselectRowHandler?
    public var didDeselectRowHandler: HZCellDidSelectDeselectRowHandler?
    public var editingStyleForRowHandler: HZCellEditingStyleForRowHandler?
    public var titleForDeleteConfirmationButtonForRowHandler: HZCellTitleForDeleteConfirmationButtonForRowHandler?
    public var editActionsForRowHandler: HZCellEditActionsForRowHandler?
    public var shouldIndentWhileEditingRowHandler: HZCellShouldIndentWhileEditingRowHandler?
    public var willBeginEditingRowHandler: HZCellEditingRowHandler?
    public var didEndEditingRowHandler: HZCellEditingRowHandler?
    public var shouldShowMenuForRowHandler: HZCellShouldShowMenuForRowHandler?
    public var canFocusRowHandler: HZCellCanFocusRowHandler?
    
    // UITableViewDataSource
    public var cellForRowHandler: HZCellForRowHandler?
    public var canEditRowHandler: HZCellCanEditMoveRowHandler?
    public var canMoveRowHandler: HZCellCanEditMoveRowHandler?
}
