//
//  Array+manageExpression.swift
//  CountOnMe
//
//  Created by Merouane Bellaha on 23/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

extension Array {
    private var elements: [String] {
        return self as? [String] ?? []
    }

    var expressionHaveEnoughElement: Bool {
        return self.count >= 3
    }

    var expressionIsCorrect: Bool {
        let elements = self.elements
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/" && !elements.isEmpty
    }

    var expressionAlreadyCalculated: Bool {
        let elements = self.elements
        return elements.contains("=")
    }

    var canAddMinusInFront: Bool {
        let elements = self.elements
        return elements.last == "+" || elements.last == "x" || elements.last == "/" || elements.last == "" || elements.isEmpty // les deux derniers font la mm chose ?
    }

    var containsDivisionByZero: Bool {
        let elements = self.elements
        for (index, element) in elements.enumerated() where element == "/" && Double(elements[index + 1]) == 0 {
            return false
       }
        return true
    }
}
