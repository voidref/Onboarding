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

    public class func constraints(for view:UIView, filling:UIView) -> [NSLayoutConstraint] {
        return [view.leadingAnchor.constraint(equalTo: filling.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: filling.trailingAnchor),
                view.topAnchor.constraint(equalTo: filling.topAnchor),
                view.bottomAnchor.constraint(equalTo: filling.bottomAnchor)]
    }
}

// Apple hasn't bothered to make multiplicitave constraints for anchors that aren't dimensions...
// This weird function signature is working around a compiler bug.
private func con(straint constraint:NSLayoutConstraint, multiplier:CGFloat) -> NSLayoutConstraint {
    return NSLayoutConstraint(item: constraint.firstItem, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: constraint.secondItem, attribute: constraint.secondAttribute, multiplier: multiplier, constant: constraint.constant)
}

extension NSLayoutYAxisAnchor {
    func constraint(equalTo anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, multiplier:CGFloat) -> NSLayoutConstraint {
        return con(straint: super.constraint(equalTo: anchor), multiplier: multiplier)
    }

    func constraint(lessThanOrEqualTo anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, multiplier:CGFloat) -> NSLayoutConstraint {
        return con(straint: super.constraint(lessThanOrEqualTo: anchor), multiplier: multiplier)
    }
    
    func constraint(greaterThanOrEqualTo anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, multiplier:CGFloat) -> NSLayoutConstraint {
        return con(straint: super.constraint(greaterThanOrEqualTo: anchor), multiplier: multiplier)
    }
}

extension NSLayoutXAxisAnchor {
    func constraint(equalTo anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, multiplier:CGFloat) -> NSLayoutConstraint {
        return con(straint: super.constraint(equalTo: anchor), multiplier: multiplier)
    }

    func constraint(lessThanOrEqualTo anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, multiplier:CGFloat) -> NSLayoutConstraint {
        return con(straint: super.constraint(lessThanOrEqualTo: anchor), multiplier: multiplier)
    }

    func constraint(greaterThanOrEqualTo anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, multiplier:CGFloat) -> NSLayoutConstraint {
        return con(straint: super.constraint(greaterThanOrEqualTo: anchor), multiplier: multiplier)
    }
}

