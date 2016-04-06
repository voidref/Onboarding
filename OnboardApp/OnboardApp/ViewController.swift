//
//  ViewController.swift
//  OnboardApp
//
//  Created by Alan Westbrook on 4/1/16.
//  Copyright © 2016 rockwood. All rights reserved.
//

import UIKit
import Onboarding

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ob = OnboardingViewController()
        addChildViewController(ob)
        view.addSubview(ob.view)
        
        ob.skipPosition = .topLeft

        let views = ["ob":ob.view]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[ob]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[ob]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        
        let firstPage = OnboardingContentPage(backgroundImage: nil, foregroundImage: nil, titleText: "First!", contentText: "Some content that's all cool and stuff")
        let secondPage = OnboardingContentPage(backgroundImage: nil, foregroundImage: nil, titleText: "Second", contentText: "Some content that's all cool and stuff")
        
        ob.setPages([firstPage, secondPage])
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }


}

