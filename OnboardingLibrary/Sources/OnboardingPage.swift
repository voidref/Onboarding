//
//  OnboardingPage.swift
//  Onboarding
//
//  Created by Alan Westbrook on 4/1/16.
//  Copyright © 2016 rockwood. All rights reserved.
//

import UIKit

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
    
    public var backgroundImage: UIImage?
    public var foregroundImage: UIImage?
    public var titleText: String?
    public var contentText: String?
    public var pageStyle: PageStyle
    
    public var titleLabel = UILabel()
    public var foregroundImageView = UIImageView()
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
        
        foregroundImageView.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false

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
        let bgView = UIImageView(image: image)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.contentMode = .ScaleAspectFill
        
        insertSubview(bgView, atIndex: 0)
        addConstraints(NSLayoutConstraint.constraintsFor(view: bgView, fillingParentView: self))
    }
    
    private func setupTitleTopStyle() {
        addConstraint(
            NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 0.5, constant: 0))
        addConstraint(
            NSLayoutConstraint(item: titleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        
        addConstraint(
            NSLayoutConstraint(item: foregroundImageView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        addConstraint(
            NSLayoutConstraint(item: foregroundImageView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
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