//
//  Array+manageExpression.swift
//  CountOnMe
//
//  Created by Merouane Bellaha on 23/04/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

extension Array where Element == String {

    ///return true  if the expression contains at least 3 elements
    var haveEnoughElement: Bool {
        return self.count >= 3
    }

    ///return true if the last element of the expression is not an operator or end with a point, and if  the element is not empty
    var isCorrect: Bool {
        return self.last != "+" && self.last != "-" && self.last != "x" && self.last != "/" && self.last?.last != "." && !self.isEmpty
    }

    ///control if the expression contains sign equal
    var alreadyCalculated: Bool {
        return self.contains("=")
    }

    var canAddMinusInFront: Bool {
        return self.last == "+" || self.last == "x" || self.last == "/" || self.isEmpty || (self.last == "-" && self.count >= 2 && self.reversed()[1] != "-")
    }

    var containsDecimal: Bool {
        guard let containsDecimal = self.last?.contains(".") else { return false }
        return containsDecimal
    }

    var containsDivisionByZero: Bool {
        for (index, element) in self.enumerated() where element == "/" && Double(self[index + 1]) == 0 {
            return true
        }
        return false
    }

    mutating func switchTheOperator(with sign: Character, remove: Bool = false) {
        guard var lastElement = self.last else { return }
        if remove { lastElement.removeFirst() }
        lastElement.insert(sign, at: lastElement.startIndex)
        self[self.count-1] = lastElement
    }
}
