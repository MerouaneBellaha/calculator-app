//
//  CalculatorTestCase.swift
//  CountOnMeTests
//
//  Created by Merouane Bellaha on 19/04/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalculatorTestCase: XCTestCase {

    var calculator: OperationManager!

    override func setUp() {
        super.setUp()
        calculator = OperationManager()
    }

    func setCurrentOperation(_ operation: String) {
        calculator.currentOperation = operation
    }

    func testGivenCurrentOperationIsEmpty_WhenTappingNumberButton5_ThenCurrentOperationShouldBe5() {
        setCurrentOperation("")

        calculator.manageNumber("5")

        XCTAssertEqual("5", calculator.currentOperation)
    }

    func testGivenCurrentOperationHasBeenCalculated_WhenTappingNumberButton5_ThenCurrentOperationShouldBe5() {
        setCurrentOperation("5 + 14 = 19")// decomposer

        calculator.manageNumber("5")

        XCTAssertEqual("5", calculator.currentOperation)
    }

    func testGivenCurrentOperationIsNotEmpty_WhenTappingCleanButton_ThenCurrentOperationShouldBeEmpty() {
        setCurrentOperation("5 + 14 x 14")

        calculator.manageClear()

        XCTAssertEqual("", calculator.currentOperation)
    }
}


// cmd u lance tous les tests
// Behavior Driven Dev. : Given When Then : "GivenPostHasZeroLike_WhenPostIsLiked_ThenPostHasOneLike"
// 
