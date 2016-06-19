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
    
    public func becameCurrentPage() {
        
    }
    
    public func resignedCurrentPage() {
        
    }
}


// MARK: - Content Page

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
        NSLayoutConstraint.activateConstraints((NSLayoutConstraint.constraintsFor(view: backgroundImageView, fillingParentView: self)))
    }
    
    private func setupTitleTopStyle() {
        
        // TODO: Center title between top and foreground image
        let imageCenterYConstraint = foregroundImageView.centerYAnchor.constraintEqualToAnchor(centerYAnchor) 
        imageCenterYConstraint.priority = UILayoutPriorityDefaultLow
        
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint(
                item: titleLabel, 
                attribute: .CenterY, 
                relatedBy: .Equal, 
                toItem: self, 
                attribute: .CenterY, 
                multiplier: 0.5, 
                constant: 0),             // WTF, Apple, no multiplier on Anchors that aren't dimensions?
            imageCenterYConstraint,
            foregroundImageView.topAnchor.constraintGreaterThanOrEqualToAnchor(titleLabel.bottomAnchor, constant: kMinimumElementSpacing)
            ])

        setupCommonTitleConstraints()
        setupCommonForegroundImageConstraints()
        setupContentConstraints()
    }

    private func setupTitleSubordinateStyle() {
        
        NSLayoutConstraint(
            item: foregroundImageView, 
            attribute: .CenterY, 
            relatedBy: .Equal, 
            toItem: self, 
            attribute: .CenterY, 
            multiplier: 0.66, 
            constant: 0).active = true

        titleLabel.font = UIFont.systemFontOfSize(24)
        titleLabel.numberOfLines = 0
        NSLayoutConstraint.constraintFor(view: titleLabel, attribute: .CenterY, equalToView: self, multiplier: 1.25).active = true
        
        
        setupCommonTitleConstraints()
        setupCommonForegroundImageConstraints()
        setupContentConstraints()
    }
    
    private func setupCommonTitleConstraints() {
        NSLayoutConstraint.activateConstraints([
            titleLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
            titleLabel.widthAnchor.constraintEqualToAnchor(widthAnchor, constant: kWidthOffsetConstant)
        ])
    }
    
    private func setupCommonForegroundImageConstraints() {
        if let image = foregroundImageView.image {
            let aspect = image.size.height / image.size.width
            foregroundImageView.heightAnchor.constraintEqualToAnchor(foregroundImageView.widthAnchor, multiplier: aspect).active = true
        }
        
        NSLayoutConstraint.activateConstraints([
            foregroundImageView.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
            foregroundImageView.widthAnchor.constraintLessThanOrEqualToAnchor(widthAnchor, constant: kWidthOffsetConstant),
            ])
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
                
        let contentBottomConstraint = contentLabel.bottomAnchor.constraintEqualToAnchor(bottomAnchor)
        contentBottomConstraint.constant = -UIScreen.mainScreen().bounds.height * 0.1
        contentBottomConstraint.priority = UILayoutPriorityDefaultLow - 1
        
        NSLayoutConstraint.activateConstraints([
            contentMidYConstraint,
            contentBottomConstraint,
            contentLabel.widthAnchor.constraintEqualToAnchor(widthAnchor, constant: kWidthOffsetConstant),
            contentLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor)
        ])
    }
}


// MARK: - Final Page

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
        
        let buttonYConstraint = NSLayoutConstraint.constraintFor(view: doneButton, attribute: .CenterY, equalToView: self, multiplier: 1.7)
        buttonYConstraint.priority = UILayoutPriorityDefaultLow
        
        NSLayoutConstraint.activateConstraints([
            doneButton.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
            buttonYConstraint,
            doneButton.topAnchor.constraintGreaterThanOrEqualToAnchor(contentLabel.bottomAnchor, constant: kMinimumElementSpacing)
        ])
    }
    
    @objc private func donePressed(button:UIButton) {
        doneDelegate?.donePressed(self)
    }
}










