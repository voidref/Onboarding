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
    public class func constraintFor(view view:UIView, attribute:NSLayoutAttribute, equalToView:UIView, multiplier:CGFloat = 1) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, 
                                  attribute: attribute, 
                                  relatedBy: .Equal, 
                                  toItem: equalToView, 
                                  attribute: attribute, 
                                  multiplier: multiplier, 
                                  constant: 0)
    }

    public class func constraintFor(view view:UIView, attribute:NSLayoutAttribute, lessThanOrEqualToView:UIView, multiplier:CGFloat = 1) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, 
                                  attribute: attribute, 
                                  relatedBy: .LessThanOrEqual, 
                                  toItem: lessThanOrEqualToView, 
                                  attribute: attribute, 
                                  multiplier: multiplier, 
                                  constant: 0)
    }

    public class func constraintFor(view view:UIView, attribute:NSLayoutAttribute, greaterThanOrEqualToView:UIView, multiplier:CGFloat = 1) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, 
                                  attribute: attribute, 
                                  relatedBy: .GreaterThanOrEqual, 
                                  toItem: greaterThanOrEqualToView, 
                                  attribute: attribute, 
                                  multiplier: multiplier, 
                                  constant: 0)
    }

    public class func constraintsFor(view view:UIView, fillingParentView:UIView) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint.constraintFor(view: view, attribute: .Width, equalToView: fillingParentView),
                NSLayoutConstraint.constraintFor(view: view, attribute: .Height, equalToView: fillingParentView),
                NSLayoutConstraint.constraintFor(view: view, attribute: .CenterX, equalToView: fillingParentView),
                NSLayoutConstraint.constraintFor(view: view, attribute: .CenterY, equalToView: fillingParentView)]
    }
}