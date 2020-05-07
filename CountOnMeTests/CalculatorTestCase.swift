//
//  Calculator.swift
//  CountOnMeTests
//
//  Created by Merouane Bellaha on 30/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalculatorTestCase: XCTestCase {

    private var calculator: Calculator!

    override func setUp() {
        super.setUp()
        calculator = Calculator()
    }

    func testGivenElements5andPlusSignAnd4_WhenCalcul_ThenResultShouldBe5plus4() {
        calculator.elementsToCalculate = ["5", "+", "4"]

        XCTAssertEqual(calculator.calcul(), 5+4)
    }

    func testGivenElements7andMinusSignAnd6_WhenCalcul_ThenResultShouldBe7minus6() {
        calculator.elementsToCalculate = ["7", "-", "6"]

        XCTAssertEqual(calculator.calcul(), 7-6)
    }

    func testGivenElements3andMultiplySignAnd2_WhenCalcul_ThenResultShould3multipliedBy2() {
       calculator.elementsToCalculate = ["3", "x", "2"]

        XCTAssertEqual(calculator.calcul(), 3*2)
    }

    func testGivenElements1andDivideSignAnd8_WhenCalcul_ThenResultShouldBe1dividedBy8() {
        calculator.elementsToCalculate = ["1", "/", "8"]

        XCTAssertEqual(calculator.calcul(), 1/8)
    }

    func testGivenExpression2AndPlusSignAnd4AndDivideSignAnd3AndMultiplySignAnd6_WhenCalcul_ThenResultShouldBe10() {
        calculator.elementsToCalculate = ["2", "+", "4", "/", "3", "x", "6"]

        XCTAssertEqual(calculator.calcul(), 2+((4/3)*6))
        XCTAssertNotEqual(calculator.calcul(), ((2+4)/3)*6)
    }

    func testGivenExpression2AndPlusSignAnd4AndMultiplySignAnd3AndDivideSignAnd6_WhenCalcul_ThenResultShouldBe4() {
        calculator.elementsToCalculate = ["2", "+", "4", "x", "3", "/", "6"]

        XCTAssertEqual(calculator.calcul(), 2+((4*3)/6))
        XCTAssertNotEqual(calculator.calcul(), ((2+4)*3)/6)
    }
}
