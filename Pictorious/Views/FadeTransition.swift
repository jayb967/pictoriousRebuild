//
//  FadeTransition.swift
//  Pictorious
//
//  Created by Rio Balderas on 7/17/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit

//this custom transition will fade over the top of the other view controller

class CustomTransition : NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration: TimeInterval
    
    init(duration: TimeInterval = 0.5) {
        self.duration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to)//guard because it is optional and need to unwrap it
            else { return }
        
        transitionContext.containerView.addSubview(toViewController.view)//taking everything in view and putting it into the container .view is the root view of the specific container
        
        toViewController.view.alpha = 0.0//this is an opacity of 0
        
        UIView.animate(withDuration: self.duration, animations: {
            
            toViewController.view.alpha = 1.0 //this makes the opacity go from 0 to 1 and show it
            
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }
}
