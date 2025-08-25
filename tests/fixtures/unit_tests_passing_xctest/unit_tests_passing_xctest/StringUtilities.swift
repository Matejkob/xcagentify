//
//  StringUtilities.swift
//  unit_tests_passing_xctest
//
//  Created by Mateusz Bąk on 8/18/25.
//

import Foundation

/// Utility functions for string manipulation
public class StringUtilities {
    
    /// Reverses a string
    /// - Parameter input: The string to reverse
    /// - Returns: Reversed string
    public static func reverse(_ input: String) -> String {
        return String(input.reversed())
    }
    
    /// Counts the number of words in a string
    /// - Parameter input: The string to count words in
    /// - Returns: Number of words
    public static func wordCount(_ input: String) -> Int {
        let words = input.components(separatedBy: .whitespacesAndNewlines)
        return words.filter { !$0.isEmpty }.count
    }
    
    /// Checks if a string is a palindrome (reads the same forwards and backwards)
    /// - Parameter input: The string to check
    /// - Returns: True if palindrome, false otherwise
    public static func isPalindrome(_ input: String) -> Bool {
        let cleaned = input.lowercased().replacingOccurrences(of: " ", with: "")
        return cleaned == String(cleaned.reversed())
    }
    
    /// Capitalizes the first letter of each word
    /// - Parameter input: The string to title case
    /// - Returns: Title-cased string
    public static func titleCase(_ input: String) -> String {
        return input.capitalized
    }
    
    /// Removes all vowels from a string
    /// - Parameter input: The string to process
    /// - Returns: String without vowels
    public static func removeVowels(_ input: String) -> String {
        let vowels = "aeiouAEIOU"
        return String(input.filter { !vowels.contains($0) })
    }
    
    /// Counts occurrences of a character in a string
    /// - Parameters:
    ///   - input: The string to search in
    ///   - character: The character to count
    /// - Returns: Number of occurrences
    public static func countOccurrences(of character: Character, in input: String) -> Int {
        return input.filter { $0 == character }.count
    }
    
    /// Checks if string contains only alphabetic characters
    /// - Parameter input: The string to check
    /// - Returns: True if only letters, false otherwise
    public static func isAlphabetic(_ input: String) -> Bool {
        return !input.isEmpty && input.allSatisfy { $0.isLetter }
    }
    
    /// Checks if string contains only numeric characters
    /// - Parameter input: The string to check
    /// - Returns: True if only numbers, false otherwise
    public static func isNumeric(_ input: String) -> Bool {
        return !input.isEmpty && input.allSatisfy { $0.isNumber }
    }
}