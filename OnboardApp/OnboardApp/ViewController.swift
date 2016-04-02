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
        // Do any additional setup after loading the view, typically from a nib.
        
        let ob = OnboardingViewController()
        addChildViewController(ob)
        view.addSubview(ob.view)
        
        ob.skipPosition = .topLeft

        let views = ["ob":ob.view]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[ob]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[ob]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }


}

