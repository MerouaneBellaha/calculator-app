//
//  expressionChecker.swift
//  CountOnMe
//
//  Created by Merouane Bellaha on 12/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

struct Calculator {

    weak var calculatorDelegate: CalculatorDelegate?

//    var currentOperation = "" // private ? but can't acces it for test
    var currentOperation: String = "" { // better way to do it ? default value ? delegate part must be test ?
        didSet {
            calculatorDelegate?.getCurrentOperation(currentOperation)
        }
    }
    private var elements: [String] {
        return currentOperation.split(separator: " ").map { "\($0)" }
    }

    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }

    private var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/" && !elements.isEmpty
    }

//    private var expressionHaveResult: Bool { // same as expressionAlreadyCalculated ?
//        return currentOperation.firstIndex(of: "=") != nil
//    }

    private var expressionIsCorrect: Bool { // same as canAddOperator ?
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }

    private var expressionAlreadyCalculated: Bool {
        elements.contains("=")
    }

    private var canAddMinusOnFront: Bool {
        return elements.last == "+" || elements.last == "x" || elements.last == "/" || elements.last == "" || elements.isEmpty
    }

    mutating func manageNumber(number: String) {
        if expressionAlreadyCalculated { currentOperation = "" }
        currentOperation.append(number)
//        calculatorDelegate?.getCurrentOperation(currentOperation)
    }


    // si sign = - /
    mutating func manageOperator(sign: String) {
        var operatorAdded = false

        if expressionAlreadyCalculated { currentOperation = "" }

        if canAddMinusOnFront && sign == "-" {
            currentOperation.append(" \(sign)")
            operatorAdded = true
        }
        if canAddOperator {
            print(elements)
            currentOperation.append(" \(sign) ")
            operatorAdded = true
        }
//        calculatorDelegate?.getCurrentOperation(currentOperation)
        if !operatorAdded { calculatorDelegate?.handleError(with: "Impossible d'ajouter un opérateur !") }
    }

    mutating func manageCleanButton() {
        currentOperation = ""
//        calculatorDelegate?.getCurrentOperation(currentOperation)
    }

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

    private func calculHighPrecedenceOperation(in calculation: [String]) -> [String] {
        var currentCalculation = calculation
        while currentCalculation.containsHighPrecedenceOperation { // Guard statement ?
            guard let index = currentCalculation.findOperatorIndice else { return [] } // < ??
            guard let result = calculate(leftOperand: index-1, rightOperand: index+1,
                                         currentOperator: index, in: currentCalculation) else { return [] }
            currentCalculation.insert(String(result), at: index)
            currentCalculation.removeUselessElement(around: index)
//            if let index = currentCalculation.findOperatorIndice {
//                if let result = calculate(leftOperand: index-1, rightOperand: index+1, currentOperator: index, in: currentCalculation) {
//                    currentCalculation.insert(String(result), at: index)
//                    currentCalculation.removeUselessElement(around: index)
//                }
//            }
        }
        return currentCalculation
    }

    private func calculLowPrecedenceOperation(in calculation: [String]) -> [String] {
        var currentCalculation = calculation
        while currentCalculation.count > 1 {
            if let result = calculate(leftOperand: 0, rightOperand: 2, currentOperator: 1, in: currentCalculation) {
//                currentCalculation = Array(currentCalculation.dropFirst(3))
                currentCalculation.removeFirst(3)
                currentCalculation.insert(String(result), at: 0)
            }
        }
        return currentCalculation
    }

    mutating func calculResult() {
        guard controlDoability() else { return }
        var calculation = elements
        if calculation.containsHighPrecedenceOperation { calculation = calculHighPrecedenceOperation(in: calculation) }
        if calculation.containsLowPrecedenceOperation { calculation = calculLowPrecedenceOperation(in: calculation) }
        let resultFormatted = formatResult(of: calculation.first!)
        currentOperation.append(" = \(resultFormatted)")
//        calculatorDelegate?.getCurrentOperation(currentOperation)
    }

    private func formatResult(of number: String) -> String {
        guard number != "inf" else {
            calculatorDelegate?.handleError(with: "Error: Division par 0 impossible")
            return "Error" }
        var result = String(format: "%.3f", Double(number)!)
        while result.contains(".") && (result.last == "0" || result.last == ".") {
            result.removeLast()
        }
        return result
    }

    private func controlDoability() -> Bool {
        guard expressionIsCorrect else {
            calculatorDelegate?.handleError(with: "Un operateur est déja mis !")
            return false
        }
        guard expressionHaveEnoughElement,
            !expressionAlreadyCalculated else {
                calculatorDelegate?.handleError(with: "Démarrez un nouveau calcul !")
                return false
        }
        return true
    }
}
