//
//  OnboardingPage.swift
//  Onboarding
//
//  Created by Alan Westbrook on 4/1/16.
//  Copyright © 2016 rockwood. All rights reserved.
//

import UIKit

public 
protocol OnboardingDoneDelegate {
    func donePressed(page:OnboardingPage)
}

private let kMinimumElementSpacing:CGFloat = 10
private let kWidthOffsetConstant = -(2 * kMinimumElementSpacing)

public
class OnboardingPage : UIView {

    init() {
        super.init(frame:CGRectZero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public
class OnboardingContentPage : OnboardingPage {
 
    public enum PageStyle {
        case titleTop           // Large title above the foreground image
        case titleSubordinate   // Smaller title below the foreground image
    }
    
    public var backgroundImage: UIImage? { didSet { backgroundImageView.image = backgroundImage } }
    public var foregroundImage: UIImage? { didSet { foregroundImageView.image = foregroundImage } }
    public var titleText: String?        { didSet { titleLabel.text = titleText } }
    public var contentText: String?      { didSet { contentLabel.text = contentText } }
    public var pageStyle: PageStyle      { didSet { setupConstraints() } }
    
    public var titleLabel = UILabel()
    public var foregroundImageView = UIImageView()
    public var backgroundImageView = UIImageView()
    public var contentLabel = UILabel()
    
    public 
    init(titleText:String?, contentText:String? = nil, backgroundImage:UIImage? = nil, foregroundImage:UIImage? = nil, pageStyle:PageStyle = .titleTop) {
        self.backgroundImage = backgroundImage
        self.foregroundImage = foregroundImage
        self.titleText = titleText
        self.contentText = contentText
        self.pageStyle = pageStyle
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = titleText
        titleLabel.font = UIFont.boldSystemFontOfSize(36)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .Center
        
        foregroundImageView.translatesAutoresizingMaskIntoConstraints = false
        foregroundImageView.image = foregroundImage
        foregroundImageView.contentMode = .ScaleAspectFit
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.textAlignment = .Center
        contentLabel.text = contentText
        contentLabel.numberOfLines = 0

        super.init()

        addSubviews()
        setupConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addSubviews() {
        addSubview(titleLabel)
        addSubview(foregroundImageView)
        addSubview(contentLabel)
    }

    public func setupConstraints() {
        removeConstraints(constraints)
        
        if let backgroundActual = backgroundImage {
            setupBackgroundImage(backgroundActual)
        }
        
        switch pageStyle {
            case .titleTop: 
                setupTitleTopStyle()
            
            case .titleSubordinate:
                setupTitleSubordinateStyle()
        }
    }
    
    private func setupBackgroundImage(image:UIImage) {
        backgroundImageView.image = image
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .ScaleAspectFill
        
        insertSubview(backgroundImageView, atIndex: 0)
        addConstraints(NSLayoutConstraint.constraintsFor(view: backgroundImageView, fillingParentView: self))
    }
    
    private func setupTitleTopStyle() {
        
        // TODO: Center title between top and foreground image
        addConstraint(NSLayoutConstraint(
            item: titleLabel, 
            attribute: .CenterY, 
            relatedBy: .Equal, 
            toItem: self, 
            attribute: .CenterY, 
            multiplier: 0.5, 
            constant: 0))
        
        let imageCenterYConstraint = NSLayoutConstraint.constraintFor(view: foregroundImageView, attribute: .CenterY, equalToView: self)
        imageCenterYConstraint.priority = UILayoutPriorityDefaultLow
        addConstraint(imageCenterYConstraint)
        addConstraint(NSLayoutConstraint(
                item: foregroundImageView, 
                attribute: .Top, 
                relatedBy: .GreaterThanOrEqual, 
                toItem: titleLabel, 
                attribute: .Bottom, 
                multiplier: 1, 
                constant: kMinimumElementSpacing))
        
        setupCommonTitleConstraints()
        setupCommonForegroundImageConstraints()
        setupContentConstraints()
    }

    private func setupTitleSubordinateStyle() {
        
        addConstraint(NSLayoutConstraint(
            item: foregroundImageView, 
            attribute: .CenterY, 
            relatedBy: .Equal, 
            toItem: self, 
            attribute: .CenterY, 
            multiplier: 0.66, 
            constant: 0))

        titleLabel.font = UIFont.systemFontOfSize(24)
        titleLabel.numberOfLines = 0
        let titleYConstraint = NSLayoutConstraint.constraintFor(view: titleLabel, attribute: .CenterY, equalToView: self, multiplier: 1.25)
        addConstraint(titleYConstraint)
        
        
        setupCommonTitleConstraints()
        setupCommonForegroundImageConstraints()
        setupContentConstraints()
    }
    
    private func setupCommonTitleConstraints() {
        addConstraint(NSLayoutConstraint.constraintFor(view: titleLabel, attribute: .CenterX, equalToView: self))
        let titleWidthConstraint = NSLayoutConstraint.constraintFor(view: titleLabel, attribute: .Width, equalToView: self)
        titleWidthConstraint.constant = kWidthOffsetConstant
        addConstraint(titleWidthConstraint)
    }
    
    private func setupCommonForegroundImageConstraints() {
        addConstraint(NSLayoutConstraint.constraintFor(view: foregroundImageView, attribute: .CenterX, equalToView: self))
        
        let imageWidthConstraint = NSLayoutConstraint.constraintFor(view: foregroundImageView, attribute: .Width, lessThanOrEqualToView: self)
        imageWidthConstraint.constant = kWidthOffsetConstant
        addConstraint(imageWidthConstraint)

        if let image = foregroundImageView.image {
            let aspect = image.size.height / image.size.width
            addConstraint(NSLayoutConstraint(
                item: foregroundImageView, 
                attribute: .Height, 
                relatedBy: .Equal, 
                toItem: foregroundImageView, 
                attribute: .Width, 
                multiplier: aspect, 
                constant: 0))
        }
    }
    
    private func setupContentConstraints() {
        let contentMidYConstraint = NSLayoutConstraint(item: contentLabel, 
                                                       attribute: .CenterY, 
                                                       relatedBy: .Equal, 
                                                       toItem: self, 
                                                       attribute: .CenterY, 
                                                       multiplier: 1.5, 
                                                       constant: 0)
        contentMidYConstraint.priority = UILayoutPriorityDefaultLow
        addConstraint(contentMidYConstraint)
        
        let contentWidthConstraint = NSLayoutConstraint.constraintFor(view: contentLabel, attribute: .Width, equalToView: self)
        contentWidthConstraint.constant = kWidthOffsetConstant
        addConstraint(contentWidthConstraint)
        
        let contentBottomConstraint = NSLayoutConstraint.constraintFor(view: contentLabel, attribute: .Bottom, equalToView: self)
        contentBottomConstraint.constant = -UIScreen.mainScreen().bounds.height * 0.1
        contentBottomConstraint.priority = UILayoutPriorityDefaultLow - 1
        addConstraint(contentBottomConstraint)
        
        addConstraint(NSLayoutConstraint.constraintFor(view: contentLabel, attribute: .CenterX, equalToView: self))
    }
}

public
class OnboardingFinalPage : OnboardingContentPage {
    
    public var doneButton = UIButton(type: .System)
    public var doneDelegate:OnboardingDoneDelegate? = nil
    
    override public func addSubviews() {
        super.addSubviews()
        doneButton.setTitle("Make It So!", forState: .Normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(donePressed(_:)), forControlEvents: .TouchUpInside)
        
        addSubview(doneButton)
    }
        
    override public func setupConstraints() {
        super.setupConstraints()
        
        addConstraint(NSLayoutConstraint.constraintFor(view: doneButton, attribute: .CenterX, equalToView: self))
        
        let buttonYConstraint = NSLayoutConstraint.constraintFor(view: doneButton, attribute: .CenterY, equalToView: self, multiplier: 1.7)
        buttonYConstraint.priority = UILayoutPriorityDefaultLow
        addConstraint(buttonYConstraint)
        
        addConstraint(
            NSLayoutConstraint(item: doneButton, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: contentLabel, attribute: .Bottom, multiplier: 1, constant: kMinimumElementSpacing))
    }
    
    @objc private func donePressed(button:UIButton) {
        doneDelegate?.donePressed(self)
    }
}










