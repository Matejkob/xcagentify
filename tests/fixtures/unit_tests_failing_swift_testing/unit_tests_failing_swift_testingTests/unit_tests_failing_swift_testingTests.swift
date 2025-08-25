//
//  unit_tests_failing_swift_testingTests.swift
//  unit_tests_failing_swift_testingTests
//
//  Created by Mateusz Bąk on 8/18/25.
//

import Testing
import Foundation
@testable import unit_tests_failing_swift_testing

// MARK: - Calculator Tests (Intentionally Failing)
struct CalculatorFailingTests {
    let calculator = Calculator()
    
    @Test("Addition should fail - wrong expected result")
    func additionWithWrongExpectation() {
        let result = calculator.add(2, 3)
        #expect(result == 6) // This will fail because 2 + 3 = 5, not 6
    }
    
    @Test("Subtraction should fail - wrong expected result")
    func subtractionWithWrongExpectation() {
        let result = calculator.subtract(10, 4)
        #expect(result == 7) // This will fail because 10 - 4 = 6, not 7
    }
    
    @Test("Multiplication should fail - incorrect assertion")
    func multiplicationWithWrongExpectation() {
        let result = calculator.multiply(3, 4)
        #expect(result == 13) // This will fail because 3 * 4 = 12, not 13
    }
    
    @Test("Division should fail - expecting wrong error")
    func divisionShouldThrowWrongError() {
        #expect(throws: CalculatorError.invalidInput) {
            try calculator.divide(10, 0) // This throws divisionByZero, not invalidInput
        }
    }
    
    @Test("Factorial should fail - wrong calculation expectation")
    func factorialWithWrongExpectation() {
        let result = calculator.factorial(5)
        #expect(result == 100) // This will fail because 5! = 120, not 100
    }
    
    @Test("Prime number check should fail - wrong assertion")
    func primeCheckWithWrongExpectation() {
        let isPrime = calculator.isPrime(9)
        #expect(isPrime == true) // This will fail because 9 is not prime
    }
    
    @Test("Division by zero should not throw")
    func divisionByZeroShouldNotThrow() {
        #expect(throws: Never.self) {
            try calculator.divide(10, 0) // This will fail because it does throw
        }
    }
}

// MARK: - UserManager Tests (Intentionally Failing)
struct UserManagerFailingTests {
    let userManager = UserManager()
    
    @Test("Adding valid user should fail - wrong expectation")
    func addValidUserShouldFail() async throws {
        let user = User(name: "John Doe", email: "john@example.com", age: 25)
        
        #expect(throws: UserError.invalidEmail) {
            try userManager.addUser(user) // This won't throw, so test will fail
        }
    }
    
    @Test("User count should be wrong")
    func userCountShouldBeWrong() throws {
        let user = User(name: "Jane Smith", email: "jane@example.com", age: 30)
        try userManager.addUser(user)
        
        let count = userManager.getUserCount()
        #expect(count == 5) // This will fail because count is 1, not 5
    }
    
    @Test("Getting non-existent user should return user")
    func getNonExistentUserShouldReturnUser() {
        let user = userManager.getUser(by: "nonexistent@example.com")
        #expect(user != nil) // This will fail because user is nil
    }
    
    @Test("Email validation should fail for valid email")
    func emailValidationShouldFailForValidEmail() {
        let isValid = userManager.isValidEmail("test@example.com")
        #expect(isValid == false) // This will fail because the email is valid
    }
    
    @Test("Updating user age should throw wrong error")
    func updateUserAgeShouldThrowWrongError() throws {
        let user = User(name: "Bob Wilson", email: "bob@example.com", age: 25)
        try userManager.addUser(user)
        
        #expect(throws: UserError.invalidEmail) {
            try userManager.updateUserAge("bob@example.com", newAge: 30) // This won't throw any error
        }
    }
    
    @Test("Deleting existing user should throw error")
    func deleteExistingUserShouldThrowError() throws {
        let user = User(name: "Alice Brown", email: "alice@example.com", age: 28)
        try userManager.addUser(user)
        
        #expect(throws: UserError.userNotFound) {
            try userManager.deleteUser(email: "alice@example.com") // This won't throw because user exists
        }
    }
}

// MARK: - StringProcessor Tests (Intentionally Failing)
struct StringProcessorFailingTests {
    let processor = StringProcessor()
    
    @Test("String reversal should fail - wrong expectation")
    func stringReversalShouldFail() {
        let result = processor.reverseString("hello")
        #expect(result == "hello") // This will fail because "hello" reversed is "olleh"
    }
    
    @Test("Palindrome check should fail - wrong assertion")
    func palindromeCheckShouldFail() {
        let isPalindrome = processor.isPalindrome("racecar")
        #expect(isPalindrome == false) // This will fail because "racecar" is a palindrome
    }
    
    @Test("Word count should be wrong")
    func wordCountShouldBeWrong() {
        let count = processor.wordCount("Hello world Swift testing")
        #expect(count == 10) // This will fail because there are 4 words, not 10
    }
    
    @Test("Capitalize words should fail - wrong expectation")
    func capitalizeWordsShouldFail() {
        let result = processor.capitalizeWords("hello world")
        #expect(result == "hello world") // This will fail because it returns "Hello World"
    }
    
    @Test("Remove vowels should fail - wrong expectation")
    func removeVowelsShouldFail() {
        let result = processor.removeVowels("hello")
        #expect(result == "hello") // This will fail because it returns "hll" (vowels removed)
    }
    
    @Test("Longest word should fail - wrong expectation")
    func longestWordShouldFail() {
        let result = processor.longestWord("short medium extraordinarily")
        #expect(result == "short") // This will fail because longest word is "extraordinarily"
    }
    
    @Test("Count occurrences should fail - wrong count")
    func countOccurrencesShouldFail() {
        let count = processor.countOccurrences(of: "test", in: "test this test case test")
        #expect(count == 1) // This will fail because "test" appears 3 times, not 1
    }
    
    @Test("Truncate should fail - wrong expectation")
    func truncateShouldFail() {
        let result = processor.truncate("This is a long sentence", to: 10)
        #expect(result == "This is a long sentence") // This will fail because it gets truncated
    }
}

// MARK: - Async/Await Tests (Intentionally Failing)
struct AsyncFailingTests {
    
    @Test("Async operation should fail")
    func asyncOperationShouldFail() async {
        let result = await simulateAsyncOperation()
        #expect(result == "failure") // This will fail because it returns "success"
    }
    
    @Test("Async throwing operation should not throw")
    func asyncThrowingOperationShouldNotThrow() async {
        await #expect(throws: Never.self) {
            try await simulateAsyncThrowingOperation()
        } // This will fail because the operation does throw
    }
    
    private func simulateAsyncOperation() async -> String {
        try? await Task.sleep(nanoseconds: 100_000) // 0.1 seconds
        return "success"
    }
    
    private func simulateAsyncThrowingOperation() async throws -> String {
        try await Task.sleep(nanoseconds: 100_000) // 0.1 seconds
        throw NSError(domain: "TestError", code: 1, userInfo: [:])
    }
}

// MARK: - Parameterized Tests (Intentionally Failing)
struct ParameterizedFailingTests {
    
    @Test("Multiple failing assertions", arguments: [1, 2, 3, 4, 5])
    func multipleFailingAssertions(number: Int) {
        let calculator = Calculator()
        let result = calculator.add(number, 10)
        #expect(result == 100) // This will fail for all inputs except when number is 90
    }
    
    @Test("String operations failing", arguments: ["hello", "world", "swift", "testing"])
    func stringOperationsFailing(input: String) {
        let processor = StringProcessor()
        let wordCount = processor.wordCount(input)
        #expect(wordCount == 5) // This will fail for all single words
    }
}

// MARK: - Collection Tests (Intentionally Failing)
struct CollectionFailingTests {
    
    @Test("Array operations should fail")
    func arrayOperationsShouldFail() {
        let numbers = [1, 2, 3, 4, 5]
        #expect(numbers.count == 10) // This will fail because count is 5
        #expect(numbers.contains(10)) // This will fail because 10 is not in the array
        #expect(numbers.first == 5) // This will fail because first is 1
        #expect(numbers.last == 1) // This will fail because last is 5
    }
    
    @Test("Dictionary operations should fail")
    func dictionaryOperationsShouldFail() {
        let dict = ["name": "John", "age": "25", "city": "New York"]
        #expect(dict.count == 10) // This will fail because count is 3
        #expect(dict["name"] == "Jane") // This will fail because value is "John"
        #expect(dict["country"] != nil) // This will fail because key doesn't exist
    }
}
