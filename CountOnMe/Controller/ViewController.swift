//
//  ViewController.swift
//  CountOnMe
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

// MARK: - @IBOutlet

    @IBOutlet private weak var textView: UITextView!

// MARK: - Properties

    private var operationManager = OperationManager()

// MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        operationManager.delegate = self
    }

// MARK: - @IBAction

    @IBAction private func tappedNumberButton(_ sender: UIButton) {
        operationManager.manageNumber(sender.currentTitle!)
    }

    @IBAction private func tappedOperatorButton(_ sender: UIButton) {
        operationManager.manageOperator(sender.currentTitle!)
    }

    @IBAction private func tappedClearButton(_ sender: UIButton) {
        operationManager.manageClear()
    }

    @IBAction private func tappedEqualButton(_ sender: UIButton) {
        operationManager.manageResult()
    }

    @IBAction private func tappedDecimalButton(_ sender: UIButton) {
        operationManager.manageDecimal()
    }
}

// MARK: - OperationManagerDelegate

extension ViewController: OperationManagerDelegate {
    func didUpdateOperation(with currentOperation: String) {
        textView?.text = currentOperation
    }
    func didFailWithError(message: String) {
        setAlertVc(with: message)
    }
}
