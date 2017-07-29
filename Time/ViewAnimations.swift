//
//  ViewAnimations.swift
//  Time
//
//  Created by Soren Nelson on 7/27/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

struct ViewAnimations {
    
    static let sharedInstance = ViewAnimations()
    
    func animate(oldConstraints: [NSLayoutConstraint], for newConstraints: [NSLayoutConstraint], withDuration: Double, on view:UIView) {

        UIView.animate(withDuration: withDuration) {
            for constraint in oldConstraints {
                constraint.isActive = false
            }
            for constraint in newConstraints {
                constraint.isActive = true
            }
            view.layoutIfNeeded()
        }
    }
    
    
}
