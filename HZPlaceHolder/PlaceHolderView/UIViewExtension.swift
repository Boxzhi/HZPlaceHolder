//
//  UIViewExtension.swift
//  HZPlaceHolder
//
//  Created by 何志志 on 2023/8/18.
//

import UIKit

extension UIView {
    
    public func addPlaceHolderViewConstraints(_ phView: UIView) {
        phView.translatesAutoresizingMaskIntoConstraints = false
        let placeHolderViewCenterX = NSLayoutConstraint(item: phView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        let placeHolderViewCenterY = NSLayoutConstraint(item: phView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        let placeHolderViewWidth = NSLayoutConstraint(item: phView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0)
        let placeHolderViewHeight = NSLayoutConstraint(item: phView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0)
        addConstraints([placeHolderViewCenterX, placeHolderViewCenterY, placeHolderViewWidth, placeHolderViewHeight])
    }
    
}
