//
//  StringProcessor.swift
//  unit_tests_failing_swift_testing
//
//  Created by Mateusz Bąk on 8/18/25.
//

import Foundation

/// A string processing utility for demonstrating failing tests
class StringProcessor {
    
    func reverseString(_ input: String) -> String {
        return String(input.reversed())
    }
    
    func isPalindrome(_ input: String) -> Bool {
        let cleaned = input.lowercased().replacingOccurrences(of: " ", with: "")
        return cleaned == String(cleaned.reversed())
    }
    
    func wordCount(_ input: String) -> Int {
        let words = input.components(separatedBy: .whitespacesAndNewlines)
        return words.filter { !$0.isEmpty }.count
    }
    
    func capitalizeWords(_ input: String) -> String {
        return input.capitalized
    }
    
    func removeVowels(_ input: String) -> String {
        let vowels = CharacterSet(charactersIn: "aeiouAEIOU")
        return String(input.unicodeScalars.filter { !vowels.contains($0) })
    }
    
    func longestWord(_ input: String) -> String {
        let words = input.components(separatedBy: .whitespacesAndNewlines)
        return words.max(by: { $0.count < $1.count }) ?? ""
    }
    
    func countOccurrences(of substring: String, in text: String) -> Int {
        guard !substring.isEmpty else { return 0 }
        let nsString = text as NSString
        let range = NSRange(location: 0, length: nsString.length)
        let regex = try? NSRegularExpression(pattern: NSRegularExpression.escapedPattern(for: substring))
        return regex?.numberOfMatches(in: text, range: range) ?? 0
    }
    
    func truncate(_ input: String, to length: Int, suffix: String = "...") -> String {
        guard input.count > length else { return input }
        let truncated = String(input.prefix(length))
        return truncated + suffix
    }
}