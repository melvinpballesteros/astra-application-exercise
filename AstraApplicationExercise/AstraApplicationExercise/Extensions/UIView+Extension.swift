//
//  UIView+Extension.swift
//  AstraApplicationExercise
//
//  Created by Melvin Ballesteros on 7/2/23.
//

import Foundation
import UIKit

extension UIView {
    public func setSubviewForAutoLayout(_ subviews: UIView...) {
        subviews.forEach{ subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(subview)
        }
    }
}
