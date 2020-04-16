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
        if expressionHaveResult { currentOperation = "" }
        currentOperation.append(number)
        return currentOperation
    }
    
    mutating func manageOperator(sign: String) -> (String, Bool) {
        var added = false
        if canAddOperator {
            currentOperation.append(" \(sign) ")
            added = true
        }
        return (currentOperation, added)
    }
    
    private func calculate(leftOperand: Int, rightOperand: Int, currentOperator: Int, in operation: [String]) -> Int? {
        guard let leftOperand = Int(operation[leftOperand]),
            let rightOperand = Int(operation[rightOperand])
            else { return nil }
        let currentOperator = operation[currentOperator]
        
        let result: Int
        switch currentOperator {
        case "*": result = leftOperand * rightOperand
        case "/": result = leftOperand / rightOperand
        case "+": result = leftOperand + rightOperand
        case "-": result = leftOperand - rightOperand
        default: fatalError("Unknown operator !")
        }
        return result
    }
    
    private func calculHighPrecedenceOperation(in calculation: [String]) -> [String] {
        var currentCalculation = calculation
        while currentCalculation.containsHighPrecedenceOperation {
            if let index = currentCalculation.findOperatorIndice {
                if let result = calculate(leftOperand: index-1, rightOperand: index+1, currentOperator: index, in: currentCalculation) {
                    currentCalculation.insert(String(result), at: index)
                    currentCalculation.removeUselessElement(around: index)
                }
            }
        }
        return currentCalculation
    }
    
    private func calculLowPrecedenceOperation(in calculation: [String]) -> [String] {
        var currentCalculation = calculation
        while currentCalculation.count > 1 {
            if let result = calculate(leftOperand: 0, rightOperand: 2, currentOperator: 1, in: currentCalculation) {
                currentCalculation = Array(currentCalculation.dropFirst(3))
                //            operationsToReduce.removeFirst(3)   Mieux ?
                currentCalculation.insert(String(result), at: 0)
            }
        }
        return currentCalculation
    }
    
    mutating func calculResult() -> String {
        var calcultation = elements
        if calcultation.containsHighPrecedenceOperation { calcultation = calculHighPrecedenceOperation(in: calcultation) }
        if calcultation.containsLowPrecedenceOperation { calcultation = calculLowPrecedenceOperation(in: calcultation) }
        currentOperation.append(" = \(calcultation.first!)")
        return currentOperation
    }
}
