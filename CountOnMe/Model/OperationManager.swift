//
//  expressionChecker.swift
//  CountOnMe
//
//  Created by Merouane Bellaha on 12/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol OperationManagerDelegate: AnyObject {
    func didUpdateOperation(with currentOperation: String)
    func didFailWithError(message: String)
}

struct OperationManager {

    weak var delegate: OperationManagerDelegate?

    var currentOperation: String = "" { // better way to do it ? default value ? delegate part must be test ? // private ??
        didSet {
            delegate?.didUpdateOperation(with: currentOperation)
        }
    }
    private var elements: [String] {
        return currentOperation.split(separator: " ").map { "\($0)" }
    }

    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }

    private var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/" && !elements.isEmpty
    }

    private var expressionAlreadyCalculated: Bool {
        elements.contains("=")
    }

    private var canAddMinusInFront: Bool {
        return elements.last == "+" || elements.last == "x" || elements.last == "/" || elements.last == "" || elements.isEmpty // les deux derniers font la mm chose ?
    }

    mutating func manageNumber(_ number: String) {
        if expressionAlreadyCalculated { currentOperation = "" }
        currentOperation.append(number)
    }

    mutating func manageOperator(_ sign: String) {
        if expressionAlreadyCalculated { currentOperation = "" }

        guard !(canAddMinusInFront && sign == "-") else {
            currentOperation.append(" \(sign)")
            return
        }
        guard !expressionIsCorrect else {
            print(elements)
            currentOperation.append(" \(sign) ")
            return
        }
        delegate?.didFailWithError(message: "Impossible d'ajouter un opérateur !")
    }

    mutating func manageClear() {
        currentOperation = ""
    }

    mutating func manageDecimal() {
        guard expressionIsCorrect && !(elements.last?.contains(".") ?? false) && !expressionAlreadyCalculated else {
            delegate?.didFailWithError(message: "Impossible d'ajouter un point !")
            return
        }
        currentOperation.append(".")
    }

    mutating func manageResult() {
        guard controlDoability() else { return }
        var calculator = Calculator(elementsToCalculate: elements)
        let result = calculator.calcul()
        let resultFormatted = formatResult(of: result.first!)
        currentOperation.append(" = \(resultFormatted)")
    }

    private func formatResult(of number: String) -> String {
        guard number != "inf" else {
            delegate?.didFailWithError(message: "Error: Division par 0 impossible")
            return "Error" }
        var result = String(format: "%.3f", Double(number)!)
        while result.contains(".") && (result.last == "0" || result.last == ".") {
            result.removeLast()
        }
        return result
    }

    private func controlDoability() -> Bool {
        guard expressionHaveEnoughElement,
            !expressionAlreadyCalculated else {
                delegate?.didFailWithError(message: "Démarrez un nouveau calcul !")
                return false
        }
        guard expressionIsCorrect else {
            delegate?.didFailWithError(message: "Un operateur est déja mis !")
            return false
        }
        return true
    }
}


//    private var expressionHaveResult: Bool { // same as expressionAlreadyCalculated ?
//        return currentOperation.firstIndex(of: "=") != nil
//    }

//    private var expressionIsCorrect: Bool { // same as canAddOperator ?
//        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
//    }


// l.
//            if let index = currentCalculation.findOperatorIndice {
//                if let result = calculate(leftOperand: index-1, rightOperand: index+1, currentOperator: index, in: currentCalculation) {
//                    currentCalculation.insert(String(result), at: index)
//                    currentCalculation.removeUselessElement(around: index)
//                }
//            }