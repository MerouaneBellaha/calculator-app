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
    @IBOutlet var numberButtons: [UIButton]!
    
    var calc = Calculator()
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    private func setAlerctVc(message: String) {
           let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
           alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
           self.present(alertVC, animated: true, completion: nil)
       }
    
    // View actions
    @IBAction private func tappedNumberButton(_ sender: UIButton) { // Private ?
        let numberText = sender.currentTitle!
        textView.text = calc.manageNumber(number: numberText)
    }
    
    // TODO: plus et moins en fonction
    // transformet en double ou float pour avoir des resultats coherents 
    
    @IBAction private func tappedOperatorButton(_ sender: UIButton) { // pluriels ?
        let values = calc.manageOperator(sign: sender.currentTitle!)
        textView.text = values.0
        if !values.1 { setAlerctVc(message: "Un operateur est déja mis !") }
    }

    @IBAction private func tappedEqualButton(_ sender: UIButton) { // erreur quand appuie une seconde fois sur =
        guard calc.expressionIsCorrect else {
            setAlerctVc(message: "Un operateur est déja mis !")
            return
        }
        
        guard calc.expressionHaveEnoughElement else {
            setAlerctVc(message: "Démarrez un nouveau calcul !")
            return
        }
        textView.text = calc.calculResult()
    }

   
}

