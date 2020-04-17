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
    
//    var delegate: CalculatorDelegate?
    var calc = Calculator()
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        calc.calculatorDelegate = self
        
    }
    
    private func setAlertVc(message: String) {
           let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
           alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
           self.present(alertVC, animated: true, completion: nil)
       }
    
    // View actions
    @IBAction private func tappedNumberButton(_ sender: UIButton) {
        let numberText = sender.currentTitle!
        calc.manageNumber(number: numberText)
    }
    
    
    @IBAction private func tappedOperatorButton(_ sender: UIButton) {
        calc.manageOperator(sign: sender.currentTitle!)
    }

    @IBAction private func tappedEqualButton(_ sender: UIButton) { // erreur quand appuie une seconde fois sur =
        guard calc.expressionIsCorrect else {
            setAlertVc(message: "Un operateur est déja mis !")
            return
        }
        
        guard calc.expressionHaveEnoughElement,
            !calc.expressionAlreadyCalculated else {
            setAlertVc(message: "Démarrez un nouveau calcul !")
            return
        }
        calc.calculResult()
    }

   
}

extension ViewController: CalculatorDelegate {
    func getCurrentOperation(_ currentOperation: String) {
        textView.text = currentOperation
    }
    func operatorHasBeenAdded(_ operatorAdded: Bool) {
        if operatorAdded == false { setAlertVc(message: "Un operateur est déja mis !") }
    }
}

