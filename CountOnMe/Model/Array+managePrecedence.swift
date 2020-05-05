//
//  Array+managePrecedence.swift
//  CountOnMe
//
//  Created by Merouane Bellaha on 12/04/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

extension Array where Element == String {
    /// return true if the array contains "/" or "x"
    var containsHighPrecedenceOperation: Bool {
        if self.contains(where: { $0 == "/" || $0 == "x" }) { return true }
        return false
    }

    /// return true if the array contains "+" or "- "
    var containsLowPrecedenceOperation: Bool {
        if self.contains(where: { $0 == "+" || $0 == "-"}) { return true }
        return false
    }

    /// returns the first index of "/" or "x"
    var findOperatorIndice: Int? {
        return self.firstIndex(where: { $0 == "/"  || $0 == "x"})
    }

    /// remove element at index+1 two times and at index-1
    mutating func removeUselessElement(around index: Int) {
        self.remove(at: index + 1)
        self.remove(at: index + 1)
        self.remove(at: index - 1)
    }
}
