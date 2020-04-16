//
//  expressionChecker.swift
//  CountOnMe
//
//  Created by Merouane Bellaha on 12/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

struct Calculator {
    
    var currentOperation = ""
    
    var elements: [String] {
        return currentOperation.split(separator: " ").map { "\($0)" }
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "*" && elements.last != "/"
    }
    
    var expressionHaveResult: Bool {
        return currentOperation.firstIndex(of: "=") != nil
    }
    
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "+" && elements.last != "/" && !elements.contains("=")
    }
    
    mutating func manageNumber(number: String) -> String {
        if expressionHaveResult { currentOperation = ""; print(currentOperation) }
        currentOperation.append(number)
        return currentOperation
    }
    
    mutating func manageOperator(sign: String) -> (String, Bool) {
        var added = false
        if canAddOperator {
            currentOperation.append(" \(sign) ")
            // is sign is *   /  doMore = true
            added = true
        }
        return (currentOperation, added)
    }
    
    private func highPrecedenceOperation(operations: [String]) -> [String] {
        var operationsToReduce = operations
        while operationsToReduce.containsHighPrecedenceOperation {
            if let index = operationsToReduce.findOperatorIndice {
            
            let left = Int(operationsToReduce[index-1])!
            let operand = operationsToReduce[index]
            let right = Int(operationsToReduce[index+1])!
            
            let result: Int
            switch operand {
            case "*": result = left * right
            case "/": result = left / right
            default: fatalError("Unknown operator !")
            }
            operationsToReduce.insert(String(result), at: index)
            operationsToReduce.removeUselessElement(around: index)
            }
        }
      return operationsToReduce
    }
    
    
    
    
    private func lowPrecedenceOperation(operations: [String]) -> [String] {
        var operationsToReduce = operations
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            
            let result: Int
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            default: fatalError("Unknown operator !")
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
//            operationsToReduce.removeFirst(3)   Mieux ?
            operationsToReduce.insert(String(result), at: 0)
        }
        return operationsToReduce
    }
    
    mutating func reduceOperation() -> String {
        var operationsToReduce = elements
        
        if true { operationsToReduce = highPrecedenceOperation(operations: operationsToReduce) }
        // while  element.contains * /
        // pour chaque element.first( * /) . index
            // element index -1  * element index +1
        // push element at index
        // remove element a t index + 1 2x et index -1
        // remove elements
        //
        
        // si doMore = true : fonction au dessus ->
        
        // si basic = true : declence fonction du dessous ->
        
        // sinon / et  fonction de ce qui ya en dessous
        
        // Iterate over operations while an operand still here
        if true { operationsToReduce = lowPrecedenceOperation(operations: operationsToReduce) }
        
        //        while operationsToReduce.count > 1 {
        //            let left = Int(operationsToReduce[0])!
        //            let operand = operationsToReduce[1]
        //            let right = Int(operationsToReduce[2])!
        //
        //            let result: Int
        //            switch operand {
        //            case "+": result = left + right
        //            case "-": result = left - right
        //            default: fatalError("Unknown operator !")
        //            }
        //
        //            operationsToReduce = Array(operationsToReduce.dropFirst(3))
        ////            operationsToReduce.removeFirst(3)   Mieux ?
        //            operationsToReduce.insert("\(result)", at: 0) // move outside???
//        }
        
        //
        
        
//        let s = NSString(format: "%.2f", f)
        currentOperation.append(" = \(operationsToReduce.first!)")
        return currentOperation
    }
}


//if let floatValue = Float("2,47") {
//    print(floatValue)
//}
