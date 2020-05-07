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

    private var expressionWithoutParentheses: [String] {
        let parentheses = CharacterSet.init(charactersIn: "()")
        return currentOperation.components(separatedBy: parentheses).joined(separator: "").split(separator: " ").map { "\($0)" }
    }

    mutating func manageNumber(_ number: String) {
        if expression.alreadyCalculated { currentOperation.removeAll() }
        guard currentOperation.last != ")" else {
            delegate?.didFailWithError(message: "Impossible d'ajouter un chiffre !")
            return
        }
        currentOperation.append(number)
    }

    mutating func manageOperator(_ sign: String) {
        if expression.alreadyCalculated { currentOperation.removeAll() }
        if expression.shouldCloseParenthesis { currentOperation.append(")") }
        guard !(expression.canAddMinusInFront && sign == "-") else {
            currentOperation.append(" (\(sign)")
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
        guard expression.isCorrect && !expression.containsDecimal && !expression.alreadyCalculated  && currentOperation.last != ")" else {
            delegate?.didFailWithError(message: "Impossible d'ajouter un point !")
            return
        }
        currentOperation.append(".")
    }

    mutating func manageKeepResult() {
        guard expression.alreadyCalculated,
            let result = expression.last else {
                delegate?.didFailWithError(message: "Pas de résultat à garder !")
                return
        }
        currentOperation = result
    }

    mutating func manageSwitchOperator() {
        guard expression.isCorrect, !expression.alreadyCalculated else {
            delegate?.didFailWithError(message: "L'élément n'est pas modifiable!")
            return
        }

        var expressionToModify = expression
        let lastElementWithOutParentheses = expressionToModify.reversed()[0].replacingOccurrences(of: "[()]", with: "", options: .regularExpression)
        expressionToModify[expressionToModify.count - 1] = lastElementWithOutParentheses

        guard let lastElement = expressionToModify.last else { return }
        switch lastElement.first {
        case "+" : expressionToModify.switchTheOperator(with: "-", remove: true)
        case "-" : expressionToModify.switchTheOperator(with: "+", remove: true)
        default : expressionToModify.switchTheOperator(with: "-")
        }
        currentOperation = expressionToModify.joined(separator: " ")
    }

    mutating func manageResult() {
        guard calculIsDoable() else { return }
        if expression.shouldCloseParenthesis { currentOperation.append(")") }
        var calculator = Calculator(elementsToCalculate: expressionWithoutParentheses)
        guard let unformattedResult = calculator.calcul() else { return }
        guard let resultFormatted = format(unformattedResult) else { return }
        currentOperation.append(" = \(resultFormatted)")
    }

    private mutating func calculIsDoable() -> Bool {
        // separate this guard to display right error message depending of the situation
        guard expression.haveEnoughElement,
            !expression.alreadyCalculated  else {
                delegate?.didFailWithError(message: "Démarrez un nouveau calcul !")
                return false
        }
        guard expression.isCorrect else {
            delegate?.didFailWithError(message: "L'expression n'est pas correcte !")
            return false
        }
        guard !expression.containsDivisionByZero else {
            currentOperation.append(" = Error")
            delegate?.didFailWithError(message: "Division par zéro impossible !")
            return false
        }
        return true
    }

    private func format(_ number: Double) -> String? {
        let formatter = NumberFormatter()
        let numberMaxLength = 10
        formatter.maximumFractionDigits = 3
        if String(number).count > numberMaxLength { formatter.numberStyle = .scientific }
        guard let result = formatter.string(from: number as NSNumber) else { return nil }
        return result
    }
}
