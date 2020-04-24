//
//  Calculator.swift
//  CountOnMe
//
//  Created by Merouane Bellaha on 21/04/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

struct Calculator {

    var elementsToCalculate: [String]

    private func calculate(leftOperand: Int, rightOperand: Int, currentOperator: Int, in operation: [String]) -> Double? {
        guard let leftOperand = Double(operation[leftOperand]),
            let rightOperand = Double(operation[rightOperand])
            else { return nil }
        let currentOperator = operation[currentOperator]

        let result: Double
        switch currentOperator {
        case "x": result = leftOperand * rightOperand
        case "/": result = leftOperand / rightOperand
        case "+": result = leftOperand + rightOperand
        case "-": result = leftOperand - rightOperand
        default: fatalError("Unknown operator !")
        }
        return result
    }

    private mutating func calculHighPrecedenceOperation() {
        while elementsToCalculate.containsHighPrecedenceOperation {
            guard let index = elementsToCalculate.findOperatorIndice else { return }
            guard let result = calculate(leftOperand: index-1, rightOperand: index+1,
                                         currentOperator: index, in: elementsToCalculate) else { return }
            elementsToCalculate.insert(String(result), at: index)
            elementsToCalculate.removeUselessElement(around: index)
        }
    }

    private mutating func calculLowPrecedenceOperation() {
        while elementsToCalculate.count > 1 {
            guard let result = calculate(leftOperand: 0, rightOperand: 2,
                                         currentOperator: 1, in: elementsToCalculate) else { return }
            //                currentCalculation = Array(currentCalculation.dropFirst(3))
            elementsToCalculate.removeFirst(3)
            elementsToCalculate.insert(String(result), at: 0)
        }
    }

    mutating func calcul() -> [String] {
        if elementsToCalculate.containsHighPrecedenceOperation { calculHighPrecedenceOperation() }
        if elementsToCalculate.containsLowPrecedenceOperation { calculLowPrecedenceOperation() }
        return elementsToCalculate
    }

}
