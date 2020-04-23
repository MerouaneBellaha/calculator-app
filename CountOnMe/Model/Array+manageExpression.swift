//
//  Array+manageExpression.swift
//  CountOnMe
//
//  Created by Merouane Bellaha on 23/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

extension Array where Element == String {
    var haveEnoughElement: Bool {
        return self.count >= 3
    }

    var isCorrect: Bool {
        return self.last != "+" && self.last != "-" && self.last != "x" && self.last != "/" && !self.isEmpty
    }

    var alreadyCalculated: Bool {
        return self.contains("=")
    }

    var canAddMinusInFront: Bool {
        return self.last == "+" || self.last == "x" || self.last == "/" || self.last == "" || self.isEmpty // les deux derniers font la mm chose ?
    }

    var containsDivisionByZero: Bool {
        for (index, element) in self.enumerated() where element == "/" && Double(self[index + 1]) == 0 {
            return true
       }
        return false
    }
}
