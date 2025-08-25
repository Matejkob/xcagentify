//
//  Calculator.swift
//  unit_tests_failing_xctest
//
//  Created by Mateusz Bąk on 8/18/25.
//

import Foundation

/// A simple calculator class for demonstration purposes
class Calculator {
    
    func add(_ a: Double, _ b: Double) -> Double {
        return a + b
    }
    
    func subtract(_ a: Double, _ b: Double) -> Double {
        return a - b
    }
    
    func multiply(_ a: Double, _ b: Double) -> Double {
        return a * b
    }
    
    func divide(_ a: Double, _ b: Double) throws -> Double {
        guard b != 0 else {
            throw CalculatorError.divisionByZero
        }
        return a / b
    }
    
    func sqrt(_ value: Double) throws -> Double {
        guard value >= 0 else {
            throw CalculatorError.negativeSquareRoot
        }
        return Foundation.sqrt(value)
    }
    
    func factorial(_ n: Int) throws -> Int {
        guard n >= 0 else {
            throw CalculatorError.negativeFactorial
        }
        guard n <= 20 else {
            throw CalculatorError.factorialTooLarge
        }
        
        if n == 0 || n == 1 {
            return 1
        }
        
        var result = 1
        for i in 2...n {
            result *= i
        }
        return result
    }
}

enum CalculatorError: Error {
    case divisionByZero
    case negativeSquareRoot
    case negativeFactorial
    case factorialTooLarge
}