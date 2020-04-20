//
//  CalculatorTestCase.swift
//  CountOnMeTests
//
//  Created by Merouane Bellaha on 19/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalculatorTestCase: XCTestCase {

    var calculator: Calculator!
//    var viewController: ViewController!

    override func setUp() {
        super.setUp()
        calculator = Calculator()
//        viewController = ViewController()
//        calculator.calculatorDelegate = viewController
    }

    func setCurrentOperation(_ operation: String) {
        calculator.currentOperation = operation
    }

    func testGivenCurrentOperationIsEmpty_WhenTappingNumberButton5_ThenCurrentOperationShouldBe5() {
        setCurrentOperation("")

        calculator.manageNumber(number: "5")

        XCTAssertEqual("5", calculator.currentOperation)
    }

    func testGivenCurrentOperationHasBeenCalculated_WhenTappingNumberButton5_ThenCurrentOperationShouldBe5() {
        setCurrentOperation("5 + 14 = 19")

        calculator.manageNumber(number: "5")

        XCTAssertEqual("5", calculator.currentOperation)
    }

    func testGivenCurrentOperationIsNotEmpty_WhenTappingCleanButton_ThenCurrentOperationShouldBeEmpty() {
        setCurrentOperation("5 + 14 x 14")

        calculator.manageCleanButton()

        XCTAssertEqual("", calculator.currentOperation)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}


// cmd u lance tous les tests
// Behavior Driven Dev. : Given When Then : "GivenPostHasZeroLike_WhenPostIsLiked_ThenPostHasOneLike"
// 
