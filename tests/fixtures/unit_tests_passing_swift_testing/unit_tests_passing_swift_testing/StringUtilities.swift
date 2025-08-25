//
//  StringUtilities.swift
//  unit_tests_passing_swift_testing
//
//  Created by Mateusz Bąk on 8/18/25.
//

import Foundation

/// A utility class with various string operations for testing
class StringUtilities {
    
    // MARK: - Basic String Operations
    
    static func reverse(_ string: String) -> String {
        return String(string.reversed())
    }
    
    static func isPalindrome(_ string: String) -> Bool {
        let cleaned = string.lowercased().replacingOccurrences(of: " ", with: "")
        return cleaned == String(cleaned.reversed())
    }
    
    static func countVowels(in string: String) -> Int {
        let vowels = "aeiouAEIOU"
        return string.filter { vowels.contains($0) }.count
    }
    
    static func countConsonants(in string: String) -> Int {
        let letters = string.filter { $0.isLetter }
        return letters.count - countVowels(in: string)
    }
    
    // MARK: - Word Operations
    
    static func wordCount(in string: String) -> Int {
        let words = string.components(separatedBy: .whitespacesAndNewlines)
        return words.filter { !$0.isEmpty }.count
    }
    
    static func longestWord(in string: String) -> String? {
        let words = string.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
        return words.max { $0.count < $1.count }
    }
    
    static func shortestWord(in string: String) -> String? {
        let words = string.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
        return words.min { $0.count < $1.count }
    }
    
    // MARK: - Transformation Operations
    
    static func capitalizeWords(in string: String) -> String {
        return string.capitalized
    }
    
    static func toCamelCase(_ string: String) -> String {
        let words = string.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
        
        guard !words.isEmpty else { return "" }
        
        let firstWord = words[0].lowercased()
        let remainingWords = words.dropFirst().map { $0.capitalized }
        
        return firstWord + remainingWords.joined()
    }
    
    static func toSnakeCase(_ string: String) -> String {
        return string
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .map { $0.lowercased() }
            .joined(separator: "_")
    }
    
    // MARK: - Validation Operations
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailPattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let regex = try? NSRegularExpression(pattern: emailPattern)
        let range = NSRange(location: 0, length: email.utf16.count)
        return regex?.firstMatch(in: email, options: [], range: range) != nil
    }
    
    static func isValidPhoneNumber(_ phone: String) -> Bool {
        let phonePattern = #"^\+?[1-9]\d{1,14}$"#
        let cleaned = phone.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
        let regex = try? NSRegularExpression(pattern: phonePattern)
        let range = NSRange(location: 0, length: cleaned.utf16.count)
        return regex?.firstMatch(in: cleaned, options: [], range: range) != nil
    }
    
    static func containsOnlyDigits(_ string: String) -> Bool {
        return !string.isEmpty && string.allSatisfy { $0.isNumber }
    }
    
    static func containsOnlyLetters(_ string: String) -> Bool {
        return !string.isEmpty && string.allSatisfy { $0.isLetter }
    }
}