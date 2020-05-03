//
//  OperationManager.swift
//  CountOnMe
//
//  Created by Merouane Bellaha on 12/04/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

protocol OperationManagerDelegate: class {
    func didUpdateOperation(with currentOperation: String)
    func didFailWithError(message: String)
}

struct OperationManager {

    weak var delegate: OperationManagerDelegate?

    var currentOperation: String = "" {
        didSet {
            delegate?.didUpdateOperation(with: currentOperation)
        }
    }
    private var expression: [String] {
        return currentOperation.split(separator: " ").map { "\($0)" }
    }

    mutating func manageNumber(_ number: String) {
        if expression.alreadyCalculated { currentOperation.removeAll() }
        currentOperation.append(number)
    }

    mutating func manageOperator(_ sign: String) {
        if expression.alreadyCalculated { currentOperation.removeAll() }

        guard !(expression.canAddMinusInFront && sign == "-") else {
            currentOperation.append(" \(sign)")
            return
        }
        guard !expression.isCorrect else {
            currentOperation.append(" \(sign) ")
            return
        }
        delegate?.didFailWithError(message: "Impossible d'ajouter un opérateur !")
    }

    mutating func manageClear() {
        currentOperation.removeAll()
    }

    mutating func manageDecimal() {
        guard expression.isCorrect && !expression.containsDecimal && !expression.alreadyCalculated else {
            delegate?.didFailWithError(message: "Impossible d'ajouter un point !")
            return
        }
        currentOperation.append(".")
    }

    mutating func manageResult() {
        guard calculIsDoable() else { return }
        var calculator = Calculator(elementsToCalculate: expression)
        guard let unformattedResult = calculator.calcul() else { return }
        guard let resultFormatted = format(unformattedResult) else { return }
        currentOperation.append(" = \(resultFormatted)")
    }

    private mutating func calculIsDoable() -> Bool {
        guard expression.haveEnoughElement,
            !expression.alreadyCalculated  else {
                delegate?.didFailWithError(message: "Démarrez un nouveau calcul !")
                return false
        }
        guard expression.isCorrect else {
            delegate?.didFailWithError(message: "Un operateur est déja mis !")
            return false
        }
        guard !expression.containsDivisionByZero else {
            currentOperation.append(" = Error")
            delegate?.didFailWithError(message: "Division par zéro impossible")
            return false
        }
        return true
    }

    private func format(_ number: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 3
        if String(number).count > 6 { formatter.numberStyle = .scientific }
        guard let result = formatter.string(from: number as NSNumber) else { return nil }
        return result
    }
}
