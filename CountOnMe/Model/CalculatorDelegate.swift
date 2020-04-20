//
//  CalculatorDelegate.swift
//  CountOnMe
//
//  Created by Merouane Bellaha on 19/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol CalculatorDelegate: AnyObject {
    func getCurrentOperation(_ currentOperation: String)
    func handleError(with message: String)
}
