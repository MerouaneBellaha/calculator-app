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

    func testGivenCurrentOperationEndWithAClosureParenthesis_WhenTappingNumberButton_ThenCurrentOperationShouldStayTheSame() {
        setExpression(operand: ["", "5"], sign: ["-"])
        operationManager.manageSwitchOperator()
        let savedCurrentOperation = operationManager.currentOperation

        operationManager.manageNumber("4")

        XCTAssertTrue(savedCurrentOperation == operationManager.currentOperation)
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

        XCTAssert(expression.count == 1 && expression.last?.last == "-")
    }

    func testGivenCurrentOperationIsEmpty_WhenTappingMinusButtonAndTappingNumberButton5_ThenCurrentOperationShouldBeMinus5() {
        setExpression(operand: ["-5"])

        XCTAssert(expression.count == 1 && expression.last == "(-5")
    }

    func testGivenCurrentOperationIsMinus_WhenTappingAnyOperator_ThenCurrentOperationIsTheSame() {
        operationManager.manageOperator("-")

        for element in ["x", "/", "+", "-"] {

            operationManager.manageOperator(element)
            print(operationManager.currentOperation)
            XCTAssertTrue(operationManager.currentOperation == " (-")
        }

    }


    func testGivenCurrentOperationIs5MinusMinus_WhenTappingMinusButton_ThenCurrentOperationShouldBeTheSame() {
        setExpression(operand: ["5"], sign: ["-"])
        operationManager.manageOperator("-")
        let savedCurrentOperation = operationManager.currentOperation

        operationManager.manageOperator("-")

        XCTAssertEqual(savedCurrentOperation, operationManager.currentOperation)
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

    func testGivenLastElementInExpressionEndWhitAPointAndStartWithAParenthesis_WhenTappingOperatorButton_ThenCurrentOperationShouldStayTheSame() {
        setExpression(operand: ["", "5."], sign: ["-"])
        let savedCurrentOperation = operationManager.currentOperation

        operationManager.manageOperator("+")

        XCTAssertTrue(savedCurrentOperation == operationManager.currentOperation)
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

    func testGivenOperationsOperandAreGreaterThanNumberMaxLength_WhenCalculate_ThenResultNumberShouldNotBeGreaterthanNumberMaxLength() {
        setExpression(operand: ["504657888888", "50456"], sign: ["+"], calculOperation: true)

        XCTAssert(expression.last?.contains("E") == true)
    }

    // MARK: - manageKeepResult

    func testGivenOperationIsCalculated_WhenTappingKeepButton_ThenCurrentOperationIsResultOfTheLastOperation() {
        setExpression(operand: ["5.1234", "5.1234"], sign: ["+"], calculOperation: true)

        operationManager.manageKeepResult()

        XCTAssertTrue(operationManager.currentOperation == String(format: "%.03f", 5.1234+5.1234))
    }

    func testGivenOperationIsNotCalculated_WhenTappingKeepButton_ThenCurrentOperationShouldStayTheSame() {
        setExpression(operand: ["5", "5"], sign: ["+"])

        let savedExpression = expression
        operationManager.manageKeepResult()


        XCTAssertTrue(expression == savedExpression)
    }

    // MARK: - manageSwitchOperator

    func testGivenLastElementOfCurrentOperationIsPositive_WhenTappingSwitchOperatorButton_ThenLastElementOfCurrentOperationIsNegative() {
        setExpression(operand: ["5", "5"], sign: ["+"])

        operationManager.manageSwitchOperator()

        XCTAssertTrue(expression.last == "(-5)")

    }

    func testGivenOperationIs5Plus5_WhenTappingSwitchOperatorButtonAndTappingEqualButton_ThenResultIs0() {
        setExpression(operand: ["5", "5"], sign: ["+"])

        operationManager.manageSwitchOperator()
        operationManager.manageResult()

        XCTAssertTrue(expression.last == "0")
    }

    func testGivenLastElementOfCurrentOperationIsNegative_WhenTappingSwitchOperatorButton_ThenLastElementOfCurrentOperationIsPositive() {
        setExpression(operand: ["5", "-5"], sign: ["+"])

        operationManager.manageSwitchOperator()

        XCTAssertTrue(expression.last == "(+5)")

    }

    func testGivenOperationIs5Minus5_WhenTappingSwitchOperatorButtonAndTappingEqualButton_ThenResultIs10() {
        setExpression(operand: ["5", "5"], sign: ["-"])

        operationManager.manageSwitchOperator()
        operationManager.manageResult()

        XCTAssertTrue(expression.last == "10")
    }

    func testGivenLastElementOfCurrentOperationIsNotANumber_WhenTappingSwitchOperatorButton_ThenCurrentOperationShouldStayTheSame() {
        setExpression(operand: ["5", "5"], sign: ["-", "+"])

        let savedCurrentOperation = operationManager.currentOperation
        operationManager.manageSwitchOperator()
        print(operationManager.currentOperation)

        XCTAssertEqual(savedCurrentOperation, operationManager.currentOperation)
    }

    func testGivenCurrentOperationIs5plus5AndSwitchOperatorHabeBeenTapped_WhenTappingSwitchOperator_ThenCurrentOperationShouldBe5plusplus5() {
        setExpression(operand: ["5", "5"], sign: ["+"])

         operationManager.manageSwitchOperator()
         operationManager.manageSwitchOperator()

        XCTAssertEqual("5 + (+5)", operationManager.currentOperation)
    }

    func testGivenCurrentOperationIsCalculated_WhenTappingSwitchOperator_ThenResulShouldNotSwitchOperator() {
        setExpression(operand: ["5", "5"], sign: ["+"], calculOperation: true)

        let savedCurrentOperation = operationManager.currentOperation
        operationManager.manageSwitchOperator()

        XCTAssertEqual(savedCurrentOperation, operationManager.currentOperation)
    }
}
