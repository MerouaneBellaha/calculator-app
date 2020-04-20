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

    var calc = Calculator()
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        calc.calculatorDelegate = self
    }

    // View actions
    @IBAction private func tappedNumberButton(_ sender: UIButton) {
        calc.manageNumber(number: sender.currentTitle!)
    }

    @IBAction private func tappedOperatorButton(_ sender: UIButton) {
        calc.manageOperator(sign: sender.currentTitle!)
    }

    @IBAction func tappedCleanButton(_ sender: UIButton) {
        calc.manageCleanButton()
    }

    @IBAction private func tappedEqualButton(_ sender: UIButton) {
        calc.calculResult()
    }

    private func setAlertVc(with message: String) {
        let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension ViewController: CalculatorDelegate {
    func getCurrentOperation(_ currentOperation: String) {
        textView?.text = currentOperation
    }
    func handleError(with message: String) {
        setAlertVc(with: message)
    }
}
