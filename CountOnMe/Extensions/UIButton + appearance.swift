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
    func setAppearance() {
        layer.shadowRadius = 11
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = #colorLiteral(red: 0.7647058824, green: 0.8392156863, blue: 0.8941176471, alpha: 1)
    }
}
