//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Katya Nerush on 01/01/2016.
//  Copyright © 2016 Katya Nerush. All rights reserved.
//

import Foundation


class CalculatorBrain {
    
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let op, _):
                    return op
                case .BinaryOperation(let op, _):
                    return op
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String: Op]()
    
    //public property to represent programm
    var programm: AnyObject { //guaranteed to be PropertyList
        get {
            return opStack.map {$0.description}
//            var retValue = [String]()
//            for op in opStack {
//                retValue.append(op.description)
//            }
//            return retValue
        }
        
        set {
            if let opSymbols = newValue as? [String] {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    }
                }
            }
            
            
        }
    }
    
    init() {
        
        func learnOp(op:Op) {
            knownOps[op.description] = op
        }
        learnOp(.BinaryOperation("✖︎", *))
        learnOp(.BinaryOperation("➗", { $1 / $0 }))
        learnOp(.BinaryOperation("➖", { $1 - $0 }))
        learnOp(.BinaryOperation("➕", +))
        learnOp(.UnaryOperation("√", sqrt))
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if (!ops.isEmpty) {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            
            case .Operand(let operand):
                return (operand, remainingOps)
                
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
                
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                
                if let op1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    
                    if let op2 = op2Evaluation.result {
                        return (operation(op1, op2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}
