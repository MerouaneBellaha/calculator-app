//
//  calcultator.swift
//  CountOnMe
//
//  Created by Merouane Bellaha on 12/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

extension Array {
    /// return true if the array contains "/" or "x"
    var containsHighPrecedenceOperation: Bool {
        if self.contains(where: { $0 as? String == "/" || $0 as? String == "x" }) { return true }
        return false
    }

    var containsLowPrecedenceOperation: Bool {
        if self.contains(where: { $0 as? String == "+" || $0 as? String == "-"}) { return true }
        return false
    }

    /// returns the first index of "/" or "x"
    var findOperatorIndice: Int? {
        return self.firstIndex(where: { $0 as? String == "/"  || $0 as? String == "x"})
    }

    /// remove element at index+1 two times and at index-1
    mutating func removeUselessElement(around index: Int) {
        self.remove(at: index + 1)
        self.remove(at: index + 1)
        self.remove(at: index - 1)
    }
}
