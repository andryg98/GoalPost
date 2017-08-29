//
//  UIButtonExt.swift
//  goalpost-app
//
//  Created by Andrea on 29/08/2017.
//  Copyright © 2017 Andrea. All rights reserved.
//

import UIKit

extension UIButton {
    func setSelectedColor() {
        self.backgroundColor = #colorLiteral(red: 0.1543619063, green: 0.8390400053, blue: 0.2139014336, alpha: 1)
    }
    
    func setDeselectedColor() {
        self.backgroundColor = #colorLiteral(red: 0.1488982682, green: 0.8188940662, blue: 0.204806521, alpha: 0.5047891695)
    }
}
