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
public typealias DoneAction = (onboardingController:OnboardingViewController) -> Void

private let skStandardHInset:CGFloat = 20
private let skStandardVInset:CGFloat = 10

public
class OnboardingViewController: UIViewController, UIScrollViewDelegate, OnboardingDoneDelegate {

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
    private let pager = UIPageControl()

    private var currentSkipConstraints:[NSLayoutConstraint] = []
    private var pages:[OnboardingPage] = []
    
    private var scroller = UIScrollView()
    
    private var currentPageIndex:Int? {
        willSet {
            if let index = currentPageIndex {
                // Oh, nomenclature, why do you torment me?
                pages[index].resignedCurrentPage()
            }
        }
        didSet {
            if let index = currentPageIndex {
                pages[index].becameCurrentPage()
                pager.currentPage = index
            }
        }
    }
    
    public func setPages(pageset:[OnboardingPage]) {
        
        pages.forEach { $0.removeFromSuperview() }
        
        pages = pageset
        
        if pages.count < 1 {
            // TODO: Assert we always have at least 1 page?
            return
        }
        
        pager.numberOfPages = pages.count
        currentPageIndex = 0
        
        var anchorView:UIView = scroller
        var anchorAttribute = NSLayoutAttribute.Left
        pages.forEach { (page) in
            scroller.addSubview(page)
            scroller.addConstraint(NSLayoutConstraint.constraintFor(view: page, attribute: .Height, equalToView: scroller))
            scroller.addConstraint(NSLayoutConstraint.constraintFor(view: page, attribute: .CenterY, equalToView: scroller))            
            scroller.addConstraint(NSLayoutConstraint.constraintFor(view: page, attribute: .Width, equalToView: scroller))            

            scroller.addConstraint(
                NSLayoutConstraint(item: page, attribute: .Left, relatedBy: .Equal, toItem: anchorView, attribute: anchorAttribute, multiplier: 1, constant: 0))
            
            anchorView = page
            anchorAttribute = .Right
        }
        
        if let finalPage = pages.last as? OnboardingFinalPage {
            finalPage.doneDelegate = self
        }
        
        // ScrollViews and autolayout is ... weird and special.
        scroller.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Right, relatedBy: .Equal, toItem: anchorView, attribute: .Right, multiplier: 1, constant: 0))
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

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

        pager.translatesAutoresizingMaskIntoConstraints = false
        pager.currentPageIndicatorTintColor = UIColor.blackColor()
        pager.pageIndicatorTintColor = UIColor.lightGrayColor()
        overlayView.addSubview(pager)

        view.addConstraints(NSLayoutConstraint.constraintsFor(view: overlayView, fillingParentView: view))

        let views = ["pager":pager]
        overlayView.addConstraints(             
            NSLayoutConstraint
                .constraintsWithVisualFormat("H:|[pager]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        overlayView.addConstraint(NSLayoutConstraint.constraintFor(view: pager, attribute: .Bottom, equalToView: overlayView))
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
        let pageWidth = view.frame.width
        let halfWidth = pageWidth / 2
        let pageNum = Int( ( scroller.contentOffset.x + halfWidth ) / pageWidth )
        
        if currentPageIndex != pageNum {
            currentPageIndex = pageNum
        }
    }
    
    // MARK: - OnboardingDoneDelegate
    
    public func donePressed(page: OnboardingPage) {
        doneAction?(onboardingController: self)
    }
}











