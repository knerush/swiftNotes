//
//  ViewController.swift
//  Calculator
//
//  Created by Katya Nerush on 27/12/2015.
//  Copyright © 2015 Katya Nerush. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userInTheMiddleOfTyping = false
    
    var brain = CalculatorBrain()
    
    var displayValue: Double {
        get {
           return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
        }
    }
    
    @IBAction func operationPressed(sender: UIButton) {
        
        if userInTheMiddleOfTyping {
            enter()
        }
        
        if let operation = sender.currentTitle {
            
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
            
        }
        
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userInTheMiddleOfTyping {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func enter() {
        userInTheMiddleOfTyping = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
}

