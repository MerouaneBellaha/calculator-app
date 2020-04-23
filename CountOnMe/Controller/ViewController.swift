//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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

// MARK: - Methods

    private func setAlertVc(with message: String) { // -> ext UIViexcontroller 
        let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
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
