//
//  Calculator.swift
//  unit_tests_failing_swift_testing
//
//  Created by Mateusz Bąk on 8/18/25.
//

import Foundation

/// A simple calculator class for demonstrating failing tests
class Calculator {
    
    func add(_ a: Int, _ b: Int) -> Int {
        return a + b
    }
    
    func subtract(_ a: Int, _ b: Int) -> Int {
        return a - b
    }
    
    func multiply(_ a: Int, _ b: Int) -> Int {
        return a * b
    }
    
    func divide(_ a: Int, _ b: Int) throws -> Int {
        guard b != 0 else {
            throw CalculatorError.divisionByZero
        }
        return a / b
    }
    
    func factorial(_ n: Int) -> Int {
        guard n >= 0 else { return 0 }
        guard n > 1 else { return 1 }
        return n * factorial(n - 1)
    }
    
    func isPrime(_ number: Int) -> Bool {
        guard number > 1 else { return false }
        guard number > 3 else { return true }
        guard number % 2 != 0 && number % 3 != 0 else { return false }
        
        var i = 5
        while i * i <= number {
            if number % i == 0 || number % (i + 2) == 0 {
                return false
            }
            i += 6
        }
        return true
    }
}

enum CalculatorError: Error, Equatable {
    case divisionByZero
    case invalidInput
}