//
//  OnboardingViewController.swift
//  Onboarding
//
//  Created by Alan Westbrook on 4/1/16.
//  Copyright © 2016 rockwood. All rights reserved.
//

import UIKit

public
enum SkipButtonPosition {
    case topLeft
    case topRight
    case bottomRight
    case bottomLeft
    case none
}

public typealias SkipAction = (button:UIButton) -> Void
public typealias DoneAction = () -> Void

private let skStandardHInset:CGFloat = 20
private let skStandardVInset:CGFloat = 10

public
class OnboardingViewController: UIViewController, UIScrollViewDelegate {

    public 
    var skipButton = UIButton(type: .System) {
        willSet {
            currentSkipConstraints = []
            skipButton.removeFromSuperview()
        }
        didSet {
            updateSkipButton()
        }
    }
    
    public
    var skipPosition = SkipButtonPosition.bottomLeft {
        didSet {
            
            updateSkipConstraints()
        }
    }
    
    public var skipAction:SkipAction?
    public var doneAction:DoneAction?
    
    private let overlayView = UIView()
    private let backgroundView = UIView()
    private let pager = UIPageControl()

    private var currentSkipConstraints:[NSLayoutConstraint] = []
    private var pages:[OnboardingPage] = []
    
    private var scroller = UIScrollView()
    
    public func setPages(pageset:[OnboardingPage]) {
        
        pages.forEach { $0.removeFromSuperview() }
        
        pages = pageset
        pager.numberOfPages = pages.count
        
        var anchorView:UIView = scroller
        var anchorAttribute = NSLayoutAttribute.Left
        pages.forEach { (page) in
            scroller.addSubview(page)
            scroller.addConstraint(
                NSLayoutConstraint(item: page, attribute: .Height, relatedBy: .Equal, toItem: scroller, attribute: .Height, multiplier: 1, constant: 0))
            scroller.addConstraint(
                NSLayoutConstraint(item: page, attribute: .CenterY, relatedBy: .Equal, toItem: scroller, attribute: .CenterY, multiplier: 1, constant: 0))
            
            scroller.addConstraint(
                NSLayoutConstraint(item: page, attribute: .Width, relatedBy: .Equal, toItem: scroller, attribute: .Width, multiplier: 1, constant: 0))
            scroller.addConstraint(
                NSLayoutConstraint(item: page, attribute: .Left, relatedBy: .Equal, toItem: anchorView, attribute: anchorAttribute, multiplier: 1, constant: 0))
            anchorView = page
            anchorAttribute = .Right
        }
        
        // ScrollViews and autolayout is ... weird and special.
        scroller.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Right, relatedBy: .Equal, toItem: anchorView, attribute: .Right, multiplier: 1, constant: 0))
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()
        setupOverlay()
        setupSkipButton()
        setupScroller()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @objc private func skipButtonPressed(button:UIButton) {
        guard let skipActionActual = skipAction else {
            
            // This is supposed to crash with this message.
            assert(skipAction != nil, "A 'skipAction' must be set")
            return
        }
        
        skipActionActual(button:button)
    }
    
    private func setupSkipButton() {
        skipButton.setTitle(NSLocalizedString("Skip", comment:"Onboarding 'Skip' button"), forState: .Normal)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        updateSkipButton()
    }
    
    // Nomenclature is hard
    private func updateSkipButton() {
        skipButton.addTarget(self, action: #selector(skipButtonPressed), forControlEvents: .TouchUpInside)
        overlayView.addSubview(skipButton)
        
        updateSkipConstraints()
    }
    
    private func updateSkipConstraints() {
        
        overlayView.removeConstraints(currentSkipConstraints)

        var firstAttribute = NSLayoutAttribute.Left
        var secondAttribute = NSLayoutAttribute.Bottom
        var viewFirstAttribute = NSLayoutAttribute.Left
        var viewSecondAttribute = NSLayoutAttribute.Bottom
        var firstInset = skStandardHInset
        var secondInset = -skStandardVInset
        
        switch skipPosition {
            case .topLeft:
                secondAttribute = .Top
                secondInset = skStandardVInset
            
            case .topRight:
                firstAttribute = .Right
                secondAttribute = .Top
                firstInset = -skStandardHInset
                secondInset = skStandardVInset
            
            case .bottomRight:
                firstAttribute = .Right
                firstInset = -skStandardHInset
            
            case .bottomLeft:
                break
            
            case .none:
                return
        }
        
        currentSkipConstraints = [
            NSLayoutConstraint(item: skipButton, 
                          attribute: firstAttribute, 
                          relatedBy: .Equal, 
                             toItem: overlayView, 
                          attribute: firstAttribute, 
                         multiplier: 1, 
                           constant: firstInset),
            NSLayoutConstraint(item: skipButton, 
                          attribute: secondAttribute, 
                          relatedBy: .Equal, 
                             toItem: overlayView, 
                          attribute: secondAttribute, 
                         multiplier: 1, 
                           constant: secondInset)
        ]

        overlayView.addConstraints(currentSkipConstraints)
    }
    
    private func setupOverlay() {
        view.addSubview(overlayView)        
        view.bringSubviewToFront(overlayView)
        
        overlayView.translatesAutoresizingMaskIntoConstraints = false

        pager.numberOfPages = 3
        pager.translatesAutoresizingMaskIntoConstraints = false
        pager.currentPageIndicatorTintColor = UIColor.blackColor()
        pager.pageIndicatorTintColor = UIColor.lightGrayColor()
        pager.currentPage = 0
        overlayView.addSubview(pager)

        let views = ["ov":overlayView, "pager":pager]
        view.addConstraints(
            NSLayoutConstraint
                .constraintsWithVisualFormat("H:|[ov]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        view.addConstraints(
            NSLayoutConstraint
                .constraintsWithVisualFormat("V:|[ov]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))

        overlayView.addConstraints(             
            NSLayoutConstraint
                .constraintsWithVisualFormat("H:|[pager]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        overlayView.addConstraints(             
            NSLayoutConstraint
                .constraintsWithVisualFormat("V:[pager]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))

    }
    
    private func setupBackground() {
        view.insertSubview(backgroundView, atIndex: 0)
    }
    
    private func setupPageConstraints() {
        
    }
    
    private func setupScroller() {
        scroller.translatesAutoresizingMaskIntoConstraints = false
        scroller.pagingEnabled = true
        scroller.delegate = self
        scroller.showsHorizontalScrollIndicator = false
        view.addSubview(scroller)
        
        view.addConstraints(NSLayoutConstraint.constraintsFor(view: scroller, fillingParentView: view))
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        // update page indicator
    }
}











