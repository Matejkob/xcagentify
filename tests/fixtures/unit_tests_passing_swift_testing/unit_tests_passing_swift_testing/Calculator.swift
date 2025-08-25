//
//  Calculator.swift
//  unit_tests_passing_swift_testing
//
//  Created by Mateusz Bąk on 8/18/25.
//

import Foundation

/// A simple calculator class with various mathematical operations
/// This provides business logic that we can test comprehensively
class Calculator {
    
    // MARK: - Basic Operations
    
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
    
    // MARK: - Advanced Operations
    
    func power(_ base: Double, _ exponent: Double) -> Double {
        return pow(base, exponent)
    }
    
    func squareRoot(_ value: Double) throws -> Double {
        guard value >= 0 else {
            throw CalculatorError.negativeSquareRoot
        }
        return sqrt(value)
    }
    
    // MARK: - Array Operations
    
    func sum(_ numbers: [Double]) -> Double {
        return numbers.reduce(0, +)
    }
    
    func average(_ numbers: [Double]) throws -> Double {
        guard !numbers.isEmpty else {
            throw CalculatorError.emptyArray
        }
        return sum(numbers) / Double(numbers.count)
    }
    
    func maximum(_ numbers: [Double]) throws -> Double {
        guard let max = numbers.max() else {
            throw CalculatorError.emptyArray
        }
        return max
    }
    
    func minimum(_ numbers: [Double]) throws -> Double {
        guard let min = numbers.min() else {
            throw CalculatorError.emptyArray
        }
        return min
    }
}

// MARK: - Calculator Errors

enum CalculatorError: Error, Equatable {
    case divisionByZero
    case negativeSquareRoot
    case emptyArray
    
    var localizedDescription: String {
        switch self {
        case .divisionByZero:
            return "Cannot divide by zero"
        case .negativeSquareRoot:
            return "Cannot calculate square root of negative number"
        case .emptyArray:
            return "Cannot perform operation on empty array"
        }
    }
}