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
        return self.last != "+" && self.last != "-" && self.last != "x" && self.last != "/" && self.last?.last != "." && !self.isEmpty && self.last != "(-"
    }

    ///return true  if the expression contains sign equal
    var alreadyCalculated: Bool {
        return self.contains("=")
    }

    /// return true if last element is an + x / or array is empty or lf last element is minus operator and array contains at least 2 elements and last element index - 1 is not minus operator
    var canAddMinusInFront: Bool {
        return self.last == "+" || self.last == "x" || self.last == "/" || self.isEmpty || (self.last == "-" && self.count >= 2 && self.reversed()[1] != "-")
    }

    /// return true if last element contains a "."
    var containsDecimal: Bool { // CHANGE THIS IN MASTER IF DONT KEEP THIS BRANCH
        return self.last?.contains(".") == true
//        guard let containsDecimal = self.last?.contains(".") else { return false }
//        return containsDecimal
    }


    /// return true if expression contains a division by 0
    var containsDivisionByZero: Bool {
        for (index, element) in self.enumerated() where element == "/" && Double(self[index + 1]) == 0 {
            return true
        }
        return false
    }

    /// return true if  last element contains an open parenthese and parenthese is not close and the last character it not "-" or "."
    var shouldCloseParenthesis: Bool {
        return self.last?.contains("(") == true && self.last?.contains(")") == false && self.last?.last != "-" && self.last?.last != "."
    }

    /// switch the operator to positive if negative or to negative if positive
    mutating func switchTheOperator(with sign: Character, remove: Bool = false) {
        guard var lastElement = self.last else { return }
        if remove { lastElement.remove(at: lastElement.startIndex) }
        lastElement.insert(sign, at: lastElement.startIndex)
        self[self.count-1] = "(\(lastElement))"
    }
}
