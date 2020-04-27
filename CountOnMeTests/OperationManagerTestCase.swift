//
//  CalculatorTestCase.swift
//  CountOnMeTests
//
//  Created by Merouane Bellaha on 19/04/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import XCTest
@testable import CountOnMe

class OperationManagerTestCase: XCTestCase {

    var operationManager: OperationManager!

    override func setUp() {
        super.setUp()
        operationManager = OperationManager()
    }

    func setExpression(operand: [String], sign: [String] = [], equal: Bool = false, clear: Bool = false) {
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
        if equal == true { operationManager.manageResult() }
        if clear == true { operationManager.manageClear() }
    }

    // MARK: - manageNumber()

//    func testGivenCurrentOperationIsEmpty_WhenTappingNumberButton5_ThenCurrentOperationShouldBe5() {
//        setExpression(operand: ["5"])
//
//        XCTAssertEqual("5", operationManager.currentOperation)
//    }

//    func testGivenCurrentOperationHasBeenCalculated_WhenTappingNumberButton5_ThenCurrentOperationShouldBe5() {
//        setExpression(operand: ["5", "14"], sign: ["-"], equal: true)
//
//        operationManager.manageNumber("5")
//
//        XCTAssertEqual("5", operationManager.currentOperation)
//    }

    // MARK: - manageOperator

    func testGivenCurrentOperationHasBeenCalculated_WhenTappingSignButtonDifferentThanMinus_ThenCurrentOperationShouldBeEmpty() {
        setExpression(operand: ["5", "14"], sign: ["+"], equal: true)

        operationManager.manageOperator("/")

        XCTAssertTrue(operationManager.currentOperation.isEmpty)
    }

    func testGivenCurrentOperationIsEmpty_WhenTappingMinusButtonThenAndTappingNumberButton5_ThenCurrentOperationShouldBeMinus5() {
        setExpression(operand: ["-5"])

        XCTAssertEqual(" -5", operationManager.currentOperation)
    }

    // MARK: - manageClear

    func testGivenCurrentOperationIsNotEmpty_WhenTappingClearButton_ThenCurrentOperationShouldBeEmpty() {
        setExpression(operand: ["5", "14"], sign: ["+"], clear: true)

        XCTAssertTrue(operationManager.currentOperation.isEmpty)
    }

    // MARK: - manageDecimal

    func testGivenCurrentIsEmpty_WhenTapping4point7point_ThenCurrentOperationShouldBe4point7() {
        setExpression(operand: ["4.7."])

        XCTAssertEqual("4.7", operationManager.currentOperation)
    }

    // MARK: - manageResult

    func testGivenCurrentOperationIsLessThan3Elements_WhenTappingEquaButton_ThenCurrentOperationShoudStayTheSame() {
        setExpression(operand: ["5"], sign: ["+"], equal: true)

        XCTAssertEqual("5 + ", operationManager.currentOperation)
    }

    func testGivenCurrentOperationEndedWithASign_WhenTappingEquaButton_ThenCurrentOperationShoudStayTheSame() {
        setExpression(operand: ["5", "122"], sign: ["+", "-"], equal: true)

        XCTAssertEqual("5 + 122 - ", operationManager.currentOperation)
    }

    func testGivenOperationContainsDivisionBy0_WhenTappingEqualButton_ThenCurrentOperationShouldDisplayError() {
        setExpression(operand: ["5", "122", "0"], sign: ["x", "/"], equal: true)

        XCTAssertEqual("5 x 122 / 0 = Error", operationManager.currentOperation)
    }

    func testGivenCurrentOperationContainsHighPrecedenceOperation_WhenTappingEqualButton_ThenCurrentOperationShouldMakeThemFirst() {
        setExpression(operand: ["2", "4", "2", "6"], sign: ["+", "/", "x"], equal: true)

        XCTAssertEqual("2 + 4 / 2 x 6 = \(2+4/2*6)", operationManager.currentOperation)
       }
}


// cmd u lance tous les tests
// Behavior Driven Dev. : Given When Then : "GivenPostHasZeroLike_WhenPostIsLiked_ThenPostHasOneLike"
// 
