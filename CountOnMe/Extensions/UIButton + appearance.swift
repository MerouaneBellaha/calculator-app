//
//  UIButton + appearance.swift
//  CountOnMe
//
//  Created by Merouane Bellaha on 01/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import UIKit

extension UIButton {

    func setShadowProperties() {
        layer.shadowRadius = 11
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = #colorLiteral(red: 0.7647058824, green: 0.8392156863, blue: 0.8941176471, alpha: 1)
    }

    open override var isHighlighted: Bool {
        willSet {
                self.setButtonBackgroundColor(tag: self.tag, isHighlighted: true)
        }
        didSet {
            UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.setButtonBackgroundColor(tag: self.tag, isHighlighted: false)
            })
        }
    }

    func setButtonBackgroundColor( tag: Int, isHighlighted: Bool) {
        var colors = [String]()
        let (blue, white, darkBlue, whiteLong, blueLong) = ("blue", "white", "darkBlue", "whiteLong", "blueLong")
        switch tag {
        case 0: colors.append(contentsOf: [blue, white])
        case 1: colors.append(contentsOf: [white, blue])
        case 2: colors.append(contentsOf: [white, darkBlue])
        case 3: colors.append(contentsOf: [blueLong, whiteLong])
        default: break
        }
        setBackgroundImage(UIImage(named: isHighlighted ? colors[0] : colors[1]), for: .normal)
    }
}
