//
//  CalculatorTestCase.swift
//  CountOnMeTests
//
//  Created by Merouane Bellaha on 19/04/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import XCTest
@testable import CountOnMe

final class OperationManagerTestCase: XCTestCase {

    private var operationManager: OperationManager!

    override func setUp() {
        super.setUp()
        operationManager = OperationManager()
    }

    private func setExpression(operand: [String], sign: [String] = [], calculOperation: Bool = false, clearOperation: Bool = false) {
        for (index, operand) in operand.enumerated() {
            for element in operand {
                if element == "." {
                    operationManager.manageDecimal()
                    continue
                }
                if element == "-" {
                    operationManager.manageOperator("-")
                    continue
                }
                operationManager.manageNumber(String(element))
            }
            if index < sign.count {
                operationManager.manageOperator(sign[index])
            }
        }
        if calculOperation { operationManager.manageResult() }
        if clearOperation { operationManager.manageClear() }
    }

    private var expression: [String] {
//        return operationManager.currentOperation.trimmingCharacters(in: .whitespaces).components(separatedBy: " ") // ??
        return operationManager.currentOperation.split(separator: " ").map { String($0) }
    }


    // MARK: - manageNumber()

    func testGivenCurrentOperationIsEmpty_WhenTapping0123456789_ThenCurrentOperationShouldBe0123456789() {
        setExpression(operand: ["0123456789"])

        XCTAssertEqual(operationManager.currentOperation, "0123456789")
    }

    func testGivenCurrentOperationIsAlreadyCalculated_WhenTappingNumberButton_ThenExpressionShouldContainsOnlyOneElement() {
        setExpression(operand: ["5", "4"], sign: ["+"], calculOperation: true)

        operationManager.manageNumber("5")

        XCTAssert(expression.count == 1)
    }

    // MARK: - manageOperator

    func testGivenCurrentOperationIsEmpty_WhenTapping2plus4minus5multiply2divide7_ThenCurrentOperationMustContainsAll4Operators() {
        var containsAllOperators: Bool {
            return expression.contains("+") && expression.contains("-") && expression.contains("/") && expression.contains("x")
        }
        setExpression(operand: ["2", "4", "5", "7"], sign: ["+", "- ", "x", "/"])

        XCTAssert(containsAllOperators)
    }

    func testGivenCurrentOperationHasBeenCalculated_WhenTappingSignButtonDifferentThanMinus_ThenCurrentOperationShouldBeEmpty() {
        for element in ["x", "/", "+"] {
            setExpression(operand: ["5", "14"], sign: ["+"], calculOperation: true)

            operationManager.manageOperator(element)

            XCTAssertTrue(operationManager.currentOperation.isEmpty)
        }
    }

    func testGivenOperationHasBeenCalculated_WhenTappingMinus_ThenCurrentOperationShouldBeMinusSign() {
        setExpression(operand: ["5", "14"], sign: ["+"], calculOperation: true)

        operationManager.manageOperator("-")

        XCTAssert(expression.count == 1 && expression.last == "-")
    }
    //

    func testGivenCurrentOperationIsEmpty_WhenTappingMinusButtonAndTappingNumberButton5_ThenCurrentOperationShouldBeMinus5() {
        setExpression(operand: ["-5"])

        XCTAssert(expression.count == 1 && expression.last == "-5")
    }

    // MARK: - manageClear

    func testGivenCurrentOperationIsNotEmpty_WhenTappingClearButton_ThenCurrentOperationShouldBeEmpty() {
        setExpression(operand: ["5", "14"], sign: ["+"], clearOperation: true)

        XCTAssertTrue(operationManager.currentOperation.isEmpty)
    }

    // MARK: - manageDecimal

    func testGivenLastElementOfCurrentOperationIsNotANumber_WhenTappingDecimalButton_ThenLastElementShouldNotBeAPoint() {
        for element in ["x", "+", "-", "/"] {
            setExpression(operand: ["4"], sign: [element])

            operationManager.manageDecimal()

            XCTAssert(expression.last != ".")
        }
    }

    func testGiventLastElementOfCurrentOperationIsANumber_WhenTappingDecimalButtonAndANumberButton_ThenLastElementShouldBeADecimalNumber() {
        setExpression(operand: ["5", "14"], sign: ["+"])

        operationManager.manageDecimal()
        operationManager.manageNumber("2")

        XCTAssert(expression.last?.contains(".") != nil)
    }

    func testGivenLastElementIsADecimal_WhenTappingDecimalButton_ThenLastElementOfLastElementShouldNotBeAPoint() {
        setExpression(operand: ["5.23"])

        operationManager.manageDecimal()

        XCTAssert(expression.last?.last != ".")
    }

    // MARK: - manageResult

    func testGivenCurrentOperationIsLessThan3Elements_WhenTappingEquaButton_ThenCurrentOperationShoudStayTheSame() {
        setExpression(operand: ["5"], sign: ["+"], calculOperation: true)

        XCTAssert(operationManager.currentOperation == "5 + ")
    }

    func testGivenCurrentOperationIsAlreadyCalcultaed_ThenTappingEqualButton_ThenCurrentOperationShouldStayTheSame() {
        setExpression(operand: ["5", "4"], sign: ["+"], calculOperation: true)
        let savedExpression = expression

        operationManager.manageResult()

        XCTAssert(savedExpression == expression)
    }

    func testGivenCurrentOperationEndedWithASign_WhenTappingEquaButton_ThenCurrentOperationShoudStayTheSame() {
        setExpression(operand: ["5", "122"], sign: ["+", "-"], calculOperation: true)
        // saved expression ?
        XCTAssert(operationManager.currentOperation == "5 + 122 - ")
    }

    func testGivenOperationContainsDivisionBy0_WhenTappingEqualButton_ThenCurrentOperationShouldDisplayError() {
        setExpression(operand: ["5", "122", "0"], sign: ["x", "/"], calculOperation: true)

        XCTAssert(expression.last == "Error")
    }

    func testGivenOperationResultShouldHaveMoreDecimals_WhenTappingEqualButton_ThenResultShouldBeRoundedUpTo3() {
        setExpression(operand: ["5.1234", "4.1235"], sign: ["+"], calculOperation: true)

        XCTAssert(expression.last?.count == 5)
    }
}
