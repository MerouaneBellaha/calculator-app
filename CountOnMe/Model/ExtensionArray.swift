//
//  calcultator.swift
//  CountOnMe
//
//  Created by Merouane Bellaha on 12/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

extension Array {
    /// return true if the array contains "/" or "*"
    var containsHighPrecedenceOperation: Bool {
        if self.contains(where: { $0 as? String == "/" }) { return true }
        if self.contains(where: { $0 as? String == "*" }) { return true }
        return false
    }
    
    /// returns the first index of "/" then "*" otherwise nil
    var findOperatorIndice: Int? {
//        var index: [Int?] = []
//        let divisionIndex = self.firstIndex(where: { $0 as? String == "/" })
//        let multiplicationIndex = self.firstIndex(where: { $0 as? String == "*" })
//        index.append(divisionIndex)
//        index.append(multiplicationIndex)
//        if index[0] == nil && index[1] != nil { return index[1] }
//        else if index[1] == nil && index[0] != nil { return index[0] }
//        else { return index[0]! < index[1]! ? index[0] : index[1]
//        }
//    }
    
        // Si je commence par toutes les divisions, meme resultat ?
        // sinon solution du dessus
           
            if let result = self.firstIndex(where: { $0 as? String == "/" }) {
                return result
        }
            if let result = self.firstIndex(where: { $0 as? String == "*" }) {
                       return result
                   }
            return nil
        }
    
    
    /// remove element at index+1 two times and at index-1
    mutating func removeUselessElement(around index: Int) {
        self.remove(at: index + 1)
        self.remove(at: index + 1)
        self.remove(at: index - 1)
    }
}
