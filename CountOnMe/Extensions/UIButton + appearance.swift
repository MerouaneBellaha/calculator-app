//
//  UIButton + appearance.swift
//  CountOnMe
//
//  Created by Merouane Bellaha on 01/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import UIKit

extension UIButton {
    // add fade effect
    func setShadowProperties() {
        layer.shadowRadius = 11
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = #colorLiteral(red: 0.7647058824, green: 0.8392156863, blue: 0.8941176471, alpha: 1)
    }

    open override var isHighlighted: Bool {
        willSet {
//            UIView.transition(with: self, duration: 0.7, options: .transitionCrossDissolve, animations: {
                self.setButtonBackgroundColor(tag: self.tag, isHighlighted: true)
//            })
        }
        didSet {
            UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.setButtonBackgroundColor(tag: self.tag, isHighlighted: false)
            })
        }
    }

    func setButtonBackgroundColor( tag: Int, isHighlighted: Bool) {
        var colors = [String]()
        let (blue, white, darkBlue, whiteLong, blueLong, darkBlueLong) = ("blue", "white", "darkBlue", "whiteLong", "blueLong", "darkBlueLong")
        switch tag {
        case 0: colors.append(contentsOf: [blue, white])
        case 1: colors.append(contentsOf: [white, blue])
        case 2: colors.append(contentsOf: [white, darkBlue])
        case 3: colors.append(contentsOf: [whiteLong, darkBlueLong])
        case 4: colors.append(contentsOf: [blueLong, whiteLong])
        default: break
        }
        setBackgroundImage(UIImage(named: isHighlighted ? colors[0] : colors[1]), for: .normal)
    }
}
