//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    var operationManager = OperationManager()
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        operationManager.delegate = self
    }

    // View actions
    @IBAction private func tappedNumberButton(_ sender: UIButton) {
        operationManager.manageNumber(sender.currentTitle!)
    }

    @IBAction private func tappedOperatorButton(_ sender: UIButton) {
        operationManager.manageOperator(sender.currentTitle!)
    }

    @IBAction func tappedClearButton(_ sender: UIButton) {
        operationManager.manageClear()
    }

    @IBAction private func tappedEqualButton(_ sender: UIButton) {
        operationManager.manageResult()
    }

    @IBAction func tappedDecimalButton(_ sender: UIButton) {
        operationManager.manageDecimal()
    }

    private func setAlertVc(with message: String) {
        let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension ViewController: OperationManagerDelegate {
    func didUpdateOperation(with currentOperation: String) {
        textView?.text = currentOperation
    }
    func didFailWithError(message: String) {
        setAlertVc(with: message)
    }
}
