//
//  NSLayoutConstraint+Convenience.swift
//  Onboarding
//
//  Created by Alan Westbrook on 4/5/16.
//  Copyright © 2016 rockwood. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    // Apple hasn't bothered to make multiplicitave constraints for anchors that aren't dimensions...
    public class func constraintFor(view view:UIView, attribute:NSLayoutAttribute, equalToView:UIView, multiplier:CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, 
                                  attribute: attribute, 
                                  relatedBy: .Equal, 
                                  toItem: equalToView, 
                                  attribute: attribute, 
                                  multiplier: multiplier, 
                                  constant: 0)
    }

    public class func constraintFor(view view:UIView, attribute:NSLayoutAttribute, lessThanOrEqualToView:UIView, multiplier:CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, 
                                  attribute: attribute, 
                                  relatedBy: .LessThanOrEqual, 
                                  toItem: lessThanOrEqualToView, 
                                  attribute: attribute, 
                                  multiplier: multiplier, 
                                  constant: 0)
    }

    public class func constraintFor(view view:UIView, attribute:NSLayoutAttribute, greaterThanOrEqualToView:UIView, multiplier:CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, 
                                  attribute: attribute, 
                                  relatedBy: .GreaterThanOrEqual, 
                                  toItem: greaterThanOrEqualToView, 
                                  attribute: attribute, 
                                  multiplier: multiplier, 
                                  constant: 0)
    }

    public class func constraintsFor(view view:UIView, fillingParentView:UIView) -> [NSLayoutConstraint] {
        return [view.leadingAnchor.constraintEqualToAnchor(fillingParentView.leadingAnchor),
                view.trailingAnchor.constraintEqualToAnchor(fillingParentView.trailingAnchor),
                view.topAnchor.constraintEqualToAnchor(fillingParentView.topAnchor),
                view.bottomAnchor.constraintEqualToAnchor(fillingParentView.bottomAnchor)]
    }
}