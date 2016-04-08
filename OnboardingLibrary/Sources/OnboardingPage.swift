//
//  OnboardingPage.swift
//  Onboarding
//
//  Created by Alan Westbrook on 4/1/16.
//  Copyright © 2016 rockwood. All rights reserved.
//

import UIKit

private let kMinimumElementSpacing:CGFloat = 10

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
    init(backgroundImage:UIImage? = nil, foregroundImage:UIImage? = nil, titleText:String? = nil, contentText:String? = nil, pageStyle:PageStyle = .titleTop) {
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

        addSubview(titleLabel)
        addSubview(foregroundImageView)
        addSubview(contentLabel)
        
        setupConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let widthOffsetConstant = -(2 * kMinimumElementSpacing)
        
        addConstraint(NSLayoutConstraint(
            item: titleLabel, 
            attribute: .CenterY, 
            relatedBy: .Equal, 
            toItem: self, 
            attribute: .CenterY, 
            multiplier: 0.5, 
            constant: 0))
        addConstraint(NSLayoutConstraint.constraintFor(view: titleLabel, equalToView: self, attribute: .CenterX))
        let titleWidthConstraint = NSLayoutConstraint.constraintFor(view: titleLabel, equalToView: self, attribute: .Width)
        titleWidthConstraint.constant = widthOffsetConstant
        addConstraint(titleWidthConstraint)
        
        let imageCenterYConstraint = NSLayoutConstraint(item: foregroundImageView, 
                                                        attribute: .CenterY, 
                                                        relatedBy: .Equal, 
                                                        toItem: self, 
                                                        attribute: .CenterY, 
                                                        multiplier: 1, 
                                                        constant: 0)
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
        addConstraint(NSLayoutConstraint.constraintFor(view: foregroundImageView, equalToView: self, attribute: .CenterX))
        addConstraint(NSLayoutConstraint(
            item: foregroundImageView, 
            attribute: .Width, 
            relatedBy: .LessThanOrEqual, 
            toItem: self, 
            attribute: .Width, 
            multiplier: 1, 
            constant: widthOffsetConstant))
        
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
        
        let contentMidYConstraint = NSLayoutConstraint(item: contentLabel, 
                                                       attribute: .CenterY, 
                                                       relatedBy: .Equal, 
                                                       toItem: self, 
                                                       attribute: .CenterY, 
                                                       multiplier: 1.5, 
                                                       constant: 0)
        contentMidYConstraint.priority = UILayoutPriorityDefaultLow
        addConstraint(contentMidYConstraint)
        
        let contentWidthConstraint = NSLayoutConstraint.constraintFor(view: contentLabel, equalToView: self, attribute: .Width)
        contentWidthConstraint.constant = widthOffsetConstant
        addConstraint(contentWidthConstraint)
                
        let contentBottomConstraint = NSLayoutConstraint.constraintFor(view: contentLabel, equalToView: self, attribute: .Bottom)
        contentBottomConstraint.constant = -UIScreen.mainScreen().bounds.height * 0.1
        contentBottomConstraint.priority = UILayoutPriorityDefaultLow - 1
        addConstraint(contentBottomConstraint)

        addConstraint(NSLayoutConstraint.constraintFor(view: contentLabel, equalToView: self, attribute: .CenterX))
    }

    private func setupTitleSubordinateStyle() {
        
    }
}

public
class OnboardingFinalPage : OnboardingContentPage {
    
    public var doneButton = UIButton(type: .System)
    
    override public func setupConstraints() {
        
    }
}