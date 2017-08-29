//
//  UIViewControllerExt.swift
//  goalpost-app
//
//  Created by Andrea on 28/08/2017.
//  Copyright © 2017 Andrea. All rights reserved.
//

import UIKit

extension UIViewController {
    //Present a new view
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        //Create a CATransition with custom duration and type
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    //Dismiss the current view
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }
}
