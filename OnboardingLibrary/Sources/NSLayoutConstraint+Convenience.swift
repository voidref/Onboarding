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
    public class func constraintFor(view view:UIView, equalToView:UIView, attribute:NSLayoutAttribute) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .Equal, toItem: equalToView, attribute: attribute, multiplier: 1, constant: 0)
    }
    
    public class func constraintsFor(view view:UIView, fillingParentView:UIView) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint.constraintFor(view: view, equalToView: fillingParentView, attribute: .Width),
                NSLayoutConstraint.constraintFor(view: view, equalToView: fillingParentView, attribute: .Height),
                NSLayoutConstraint.constraintFor(view: view, equalToView: fillingParentView, attribute: .CenterX),
                NSLayoutConstraint.constraintFor(view: view, equalToView: fillingParentView, attribute: .CenterY)]
    }
}