//
//  OnboardingPage.swift
//  Onboarding
//
//  Created by Alan Westbrook on 4/1/16.
//  Copyright © 2016 rockwood. All rights reserved.
//

import UIKit

public 
protocol OnboardingDoneDelegate: AnyObject {
    func donePressed(_ page:OnboardingPage)
}

private let kMinimumElementSpacing:CGFloat = 10
private let kWidthOffsetConstant = -(2 * kMinimumElementSpacing)

public
class OnboardingPage : UIView {

    init() {
        super.init(frame:CGRect.zero)
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
        titleLabel.font = UIFont.boldSystemFont(ofSize: 36)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        
        foregroundImageView.translatesAutoresizingMaskIntoConstraints = false
        foregroundImageView.image = foregroundImage
        foregroundImageView.contentMode = .scaleAspectFit
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.textAlignment = .center
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
    
    private func setupBackgroundImage(_ image:UIImage) {
        backgroundImageView.image = image
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        
        insertSubview(backgroundImageView, at: 0)
        NSLayoutConstraint.activate((NSLayoutConstraint.constraints(for: backgroundImageView, filling: self)))
    }
    
    private func setupTitleTopStyle() {
        
        // TODO: Center title between top and foreground image
        let imageCenterYConstraint = foregroundImageView.centerYAnchor.constraint(equalTo: centerYAnchor) 
        imageCenterYConstraint.priority = UILayoutPriorityDefaultLow
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: titleLabel, 
                attribute: .centerY, 
                relatedBy: .equal, 
                toItem: self, 
                attribute: .centerY, 
                multiplier: 0.5, 
                constant: 0),             // WTF, Apple, no multiplier on Anchors that aren't dimensions?
            imageCenterYConstraint,
            foregroundImageView.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: kMinimumElementSpacing)
            ])

        setupCommonTitleConstraints()
        setupCommonForegroundImageConstraints()
        setupContentConstraints()
    }

    private func setupTitleSubordinateStyle() {

        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, multiplier: 1.25),
            foregroundImageView.centerYAnchor.constraint(equalTo: centerYAnchor, multiplier: 0.66)
        ])
        
        setupCommonTitleConstraints()
        setupCommonForegroundImageConstraints()
        setupContentConstraints()
    }
    
    private func setupCommonTitleConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: kWidthOffsetConstant)
        ])
    }
    
    private func setupCommonForegroundImageConstraints() {
        if let image = foregroundImageView.image {
            let aspect = image.size.height / image.size.width
            foregroundImageView.heightAnchor.constraint(equalTo: foregroundImageView.widthAnchor, multiplier: aspect).isActive = true
        }
        
        NSLayoutConstraint.activate([
            foregroundImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            foregroundImageView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: kWidthOffsetConstant),
            ])
    }
    
    private func setupContentConstraints() {
        let contentMidYConstraint = NSLayoutConstraint(item: contentLabel, 
                                                       attribute: .centerY, 
                                                       relatedBy: .equal, 
                                                       toItem: self, 
                                                       attribute: .centerY, 
                                                       multiplier: 1.5, 
                                                       constant: 0)
        contentMidYConstraint.priority = UILayoutPriorityDefaultLow
                
        let contentBottomConstraint = contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        contentBottomConstraint.constant = -UIScreen.main().bounds.height * 0.1
        contentBottomConstraint.priority = UILayoutPriorityDefaultLow - 1
        
        NSLayoutConstraint.activate([
            contentMidYConstraint,
            contentBottomConstraint,
            contentLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: kWidthOffsetConstant),
            contentLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}


// MARK: - Final Page

public
class OnboardingFinalPage : OnboardingContentPage {
    
    public var doneButton = UIButton(type: .system)
    public weak var doneDelegate:OnboardingDoneDelegate? = nil
    
    override public func addSubviews() {
        super.addSubviews()
        doneButton.setTitle("Make It So!", for: UIControlState())
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(donePressed(_:)), for: .touchUpInside)
        
        addSubview(doneButton)
    }
        
    override public func setupConstraints() {
        super.setupConstraints()
        
        let buttonYConstraint = doneButton.centerYAnchor.constraint(equalTo: centerYAnchor, multiplier: 1.7)
        buttonYConstraint.priority = UILayoutPriorityDefaultLow
        
        NSLayoutConstraint.activate([
            doneButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonYConstraint,
            doneButton.topAnchor.constraint(greaterThanOrEqualTo: contentLabel.bottomAnchor, constant: kMinimumElementSpacing)
        ])
    }
    
    @objc private func donePressed(_ button:UIButton) {
        doneDelegate?.donePressed(self)
    }
}










