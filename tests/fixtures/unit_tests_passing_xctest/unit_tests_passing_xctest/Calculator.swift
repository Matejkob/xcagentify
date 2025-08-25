//
//  Calculator.swift
//  unit_tests_passing_xctest
//
//  Created by Mateusz Bąk on 8/18/25.
//

import Foundation

/// A simple calculator class to demonstrate unit testing with XCTest
public class Calculator {
    
    /// Adds two numbers
    /// - Parameters:
    ///   - a: First number
    ///   - b: Second number
    /// - Returns: Sum of a and b
    public func add(_ a: Double, _ b: Double) -> Double {
        return a + b
    }
    
    /// Subtracts second number from first
    /// - Parameters:
    ///   - a: First number
    ///   - b: Second number
    /// - Returns: a - b
    public func subtract(_ a: Double, _ b: Double) -> Double {
        return a - b
    }
    
    /// Multiplies two numbers
    /// - Parameters:
    ///   - a: First number
    ///   - b: Second number
    /// - Returns: Product of a and b
    public func multiply(_ a: Double, _ b: Double) -> Double {
        return a * b
    }
    
    /// Divides first number by second
    /// - Parameters:
    ///   - a: Dividend
    ///   - b: Divisor
    /// - Returns: Result of division
    /// - Throws: CalculatorError.divisionByZero if b is zero
    public func divide(_ a: Double, _ b: Double) throws -> Double {
        guard b != 0 else {
            throw CalculatorError.divisionByZero
        }
        return a / b
    }
    
    /// Calculates percentage
    /// - Parameters:
    ///   - value: The value to calculate percentage of
    ///   - percentage: The percentage (e.g., 25 for 25%)
    /// - Returns: Percentage of the value
    public func percentage(_ value: Double, _ percentage: Double) -> Double {
        return (value * percentage) / 100
    }
    
    /// Calculates square root
    /// - Parameter value: The number to find square root of
    /// - Returns: Square root of the value
    /// - Throws: CalculatorError.negativeSquareRoot if value is negative
    public func squareRoot(_ value: Double) throws -> Double {
        guard value >= 0 else {
            throw CalculatorError.negativeSquareRoot
        }
        return sqrt(value)
    }
}

/// Errors that can be thrown by Calculator
public enum CalculatorError: Error {
    case divisionByZero
    case negativeSquareRoot
    
    public var localizedDescription: String {
        switch self {
        case .divisionByZero:
            return "Cannot divide by zero"
        case .negativeSquareRoot:
            return "Cannot calculate square root of negative number"
        }
    }
}