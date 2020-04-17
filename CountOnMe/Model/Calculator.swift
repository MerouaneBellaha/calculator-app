//
//  expressionChecker.swift
//  CountOnMe
//
//  Created by Merouane Bellaha on 12/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol CalculatorDelegate {
    func getCurrentOperation(_ currentOperation: String)
    func operatorHasBeenAdded(_ operatorAdded: Bool)
}

struct Calculator {
    
    var calculatorDelegate: CalculatorDelegate!
    
    var currentOperation = ""
    
    var elements: [String] {
        return currentOperation.split(separator: " ").map { "\($0)" }
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "*" && elements.last != "/" && !elements.isEmpty
    }
    
    var expressionHaveResult: Bool {
        return currentOperation.firstIndex(of: "=") != nil
    }
    
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "*" && elements.last != "/"
    }
    
    var expressionAlreadyCalculated: Bool {
        elements.contains("=")
    }
    
    mutating func manageNumber(number: String) {
        if expressionHaveResult { currentOperation = "" }
        currentOperation.append(number)
        calculatorDelegate.getCurrentOperation(currentOperation)
    }
    
    mutating func manageOperator(sign: String) {
        var operatorAdded = false
        if expressionHaveResult { currentOperation = "" }
        // si operateur tous sauf moins ou "" alors je peux mettrer - et append sign ( sans espace a droite ) et
        
        // peux mettre un - pendant le calcul devant un operand, et marche :)
        if (elements.last == "+" || elements.last == "*" || elements.last == "/" || elements.last == "")
            && sign == "-" {
            print("ah")
            currentOperation.append(" \(sign)")
            operatorAdded = true
        }
        
        //
        if elements.isEmpty && sign == "-" {
            print("ho")
            currentOperation.append(" \(sign)")
            operatorAdded = true
        }
        
        if canAddOperator /*&& canStartWithOperator(sign)*/  {
            print(elements)
            currentOperation.append(" \(sign) ")
            operatorAdded = true
        }
        calculatorDelegate.getCurrentOperation(currentOperation)
        calculatorDelegate.operatorHasBeenAdded(operatorAdded)
    }
    
    private func calculate(leftOperand: Int, rightOperand: Int, currentOperator: Int, in operation: [String]) -> Double? {
        guard let leftOperand = Double(operation[leftOperand]),
            let rightOperand = Double(operation[rightOperand])
            else { return nil }
        let currentOperator = operation[currentOperator]
        
        let result: Double
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
    
    mutating func calculResult() {
        
        var calculation = elements
        if calculation.containsHighPrecedenceOperation { calculation = calculHighPrecedenceOperation(in: calculation) }
        if calculation.containsLowPrecedenceOperation { calculation = calculLowPrecedenceOperation(in: calculation) }
        let resultFormatted = formatResult(of: calculation.first!)
        currentOperation.append(" = \(resultFormatted)")
        calculatorDelegate.getCurrentOperation(currentOperation)
    }
    
    private func formatResult(of number: String) -> String {
        guard number != "inf" else { return "Error" }
        var result = String(format: "%.3f", Double(number)!)
        while result.contains(".") && (result.last == "0" || result.last == ".") {
            result.removeLast()
        }
        return result
    }
}
