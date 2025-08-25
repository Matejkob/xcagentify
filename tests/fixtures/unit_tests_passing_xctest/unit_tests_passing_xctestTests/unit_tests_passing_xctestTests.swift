//
//  unit_tests_passing_xctestTests.swift
//  unit_tests_passing_xctestTests
//
//  Created by Mateusz Bąk on 8/18/25.
//

import XCTest
@testable import unit_tests_passing_xctest

final class unit_tests_passing_xctestTests: XCTestCase {
    
    // MARK: - Properties
    var calculator: Calculator!
    var userManager: UserManager!
    
    // MARK: - Setup and Teardown
    
    override func setUpWithError() throws {
        // This method is called before the invocation of each test method in the class.
        // Initialize fresh instances for each test to ensure test isolation
        calculator = Calculator()
        userManager = UserManager()
    }

    override func tearDownWithError() throws {
        // This method is called after the invocation of each test method in the class.
        // Clean up resources
        calculator = nil
        userManager = nil
    }

    // MARK: - Calculator Tests
    
    func testCalculatorAddition() throws {
        // Test basic addition functionality
        let result = calculator.add(5.0, 3.0)
        XCTAssertEqual(result, 8.0, "Addition should return correct sum")
        
        // Test with negative numbers
        let negativeResult = calculator.add(-5.0, 3.0)
        XCTAssertEqual(negativeResult, -2.0, "Addition with negative numbers should work")
        
        // Test with decimals
        let decimalResult = calculator.add(2.5, 3.7)
        XCTAssertEqual(decimalResult, 6.2, accuracy: 0.01, "Addition with decimals should be accurate")
    }
    
    func testCalculatorSubtraction() throws {
        let result = calculator.subtract(10.0, 4.0)
        XCTAssertEqual(result, 6.0, "Subtraction should return correct difference")
        
        let negativeResult = calculator.subtract(3.0, 10.0)
        XCTAssertEqual(negativeResult, -7.0, "Subtraction resulting in negative should work")
    }
    
    func testCalculatorMultiplication() throws {
        let result = calculator.multiply(6.0, 7.0)
        XCTAssertEqual(result, 42.0, "Multiplication should return correct product")
        
        let zeroResult = calculator.multiply(5.0, 0.0)
        XCTAssertEqual(zeroResult, 0.0, "Multiplication by zero should return zero")
    }
    
    func testCalculatorDivision() throws {
        let result = try calculator.divide(15.0, 3.0)
        XCTAssertEqual(result, 5.0, "Division should return correct quotient")
        
        let decimalResult = try calculator.divide(7.0, 2.0)
        XCTAssertEqual(decimalResult, 3.5, "Division with decimal result should work")
    }
    
    func testCalculatorDivisionByZeroThrowsError() throws {
        // Test that division by zero throws the expected error
        XCTAssertThrowsError(try calculator.divide(10.0, 0.0)) { error in
            XCTAssertEqual(error as? CalculatorError, CalculatorError.divisionByZero,
                          "Division by zero should throw divisionByZero error")
        }
    }
    
    func testCalculatorPercentage() throws {
        let result = calculator.percentage(200.0, 25.0)
        XCTAssertEqual(result, 50.0, "25% of 200 should be 50")
        
        let zeroResult = calculator.percentage(100.0, 0.0)
        XCTAssertEqual(zeroResult, 0.0, "0% of any number should be 0")
    }
    
    func testCalculatorSquareRoot() throws {
        let result = try calculator.squareRoot(16.0)
        XCTAssertEqual(result, 4.0, "Square root of 16 should be 4")
        
        let decimalResult = try calculator.squareRoot(2.0)
        XCTAssertEqual(decimalResult, sqrt(2.0), accuracy: 0.0001, "Square root should be accurate")
    }
    
    func testCalculatorSquareRootOfNegativeNumberThrowsError() throws {
        XCTAssertThrowsError(try calculator.squareRoot(-4.0)) { error in
            XCTAssertEqual(error as? CalculatorError, CalculatorError.negativeSquareRoot,
                          "Square root of negative number should throw negativeSquareRoot error")
        }
    }
    
    // MARK: - UserManager Tests
    
    func testUserCreation() throws {
        let user = User(name: "John Doe", email: "john@example.com", age: 30)
        
        XCTAssertFalse(user.name.isEmpty, "User should have a name")
        XCTAssertTrue(user.isEmailValid, "User should have valid email")
        XCTAssertTrue(user.isAdult, "User should be an adult")
        XCTAssertNotNil(user.id, "User should have an ID")
    }
    
    func testUserEmailValidation() throws {
        let validUser = User(name: "Jane", email: "jane@example.com", age: 25)
        XCTAssertTrue(validUser.isEmailValid, "Valid email should pass validation")
        
        let invalidUser = User(name: "Bob", email: "invalid-email", age: 30)
        XCTAssertFalse(invalidUser.isEmailValid, "Invalid email should fail validation")
    }
    
    func testUserAgeValidation() throws {
        let adult = User(name: "Adult", email: "adult@example.com", age: 18)
        XCTAssertTrue(adult.isAdult, "18-year-old should be considered adult")
        
        let minor = User(name: "Minor", email: "minor@example.com", age: 17)
        XCTAssertFalse(minor.isAdult, "17-year-old should not be considered adult")
    }
    
    func testAddValidUser() throws {
        let user = User(name: "Alice", email: "alice@example.com", age: 28)
        
        XCTAssertNoThrow(try userManager.addUser(user), "Adding valid user should not throw")
        XCTAssertEqual(userManager.userCount, 1, "User count should be 1 after adding user")
        
        let retrievedUser = userManager.getUser(by: user.id)
        XCTAssertNotNil(retrievedUser, "Should be able to retrieve added user")
        XCTAssertEqual(retrievedUser, user, "Retrieved user should match added user")
    }
    
    func testAddUserWithEmptyNameThrowsError() throws {
        let user = User(name: "", email: "test@example.com", age: 25)
        
        XCTAssertThrowsError(try userManager.addUser(user)) { error in
            if case UserManagerError.invalidUser(let message) = error {
                XCTAssertTrue(message.contains("Name cannot be empty"), "Error should mention empty name")
            } else {
                XCTFail("Should throw invalidUser error")
            }
        }
    }
    
    func testAddUserWithInvalidEmailThrowsError() throws {
        let user = User(name: "Test", email: "invalid-email", age: 25)
        
        XCTAssertThrowsError(try userManager.addUser(user)) { error in
            if case UserManagerError.invalidUser(let message) = error {
                XCTAssertTrue(message.contains("Email format is invalid"), "Error should mention invalid email")
            } else {
                XCTFail("Should throw invalidUser error")
            }
        }
    }
    
    func testAddUserWithInvalidAgeThrowsError() throws {
        let youngUser = User(name: "Test", email: "test@example.com", age: -1)
        let oldUser = User(name: "Test2", email: "test2@example.com", age: 200)
        
        XCTAssertThrowsError(try userManager.addUser(youngUser))
        XCTAssertThrowsError(try userManager.addUser(oldUser))
    }
    
    func testAddDuplicateUserThrowsError() throws {
        let user1 = User(name: "John", email: "john@example.com", age: 30)
        let user2 = User(name: "Jane", email: "john@example.com", age: 25) // Same email
        
        try userManager.addUser(user1)
        
        XCTAssertThrowsError(try userManager.addUser(user2)) { error in
            if case UserManagerError.duplicateUser(let message) = error {
                XCTAssertTrue(message.contains("already exists"), "Error should mention duplicate")
            } else {
                XCTFail("Should throw duplicateUser error")
            }
        }
    }
    
    func testGetUserByEmail() throws {
        let user = User(name: "Test", email: "test@example.com", age: 30)
        try userManager.addUser(user)
        
        let retrievedUser = userManager.getUser(by: "test@example.com")
        XCTAssertNotNil(retrievedUser, "Should find user by email")
        XCTAssertEqual(retrievedUser?.email, "test@example.com", "Retrieved user should have correct email")
        
        let nonExistentUser = userManager.getUser(by: "nonexistent@example.com")
        XCTAssertNil(nonExistentUser, "Should return nil for non-existent email")
    }
    
    func testAdultUsersFilter() throws {
        let adult1 = User(name: "Adult1", email: "adult1@example.com", age: 25)
        let adult2 = User(name: "Adult2", email: "adult2@example.com", age: 30)
        let minor = User(name: "Minor", email: "minor@example.com", age: 16)
        
        try userManager.addUser(adult1)
        try userManager.addUser(adult2)
        try userManager.addUser(minor)
        
        let adults = userManager.adultUsers
        XCTAssertEqual(adults.count, 2, "Should have 2 adult users")
        XCTAssertTrue(adults.contains(adult1), "Should contain first adult")
        XCTAssertTrue(adults.contains(adult2), "Should contain second adult")
        XCTAssertFalse(adults.contains(minor), "Should not contain minor")
    }
    
    func testRemoveUser() throws {
        let user = User(name: "Test", email: "test@example.com", age: 30)
        try userManager.addUser(user)
        
        XCTAssertEqual(userManager.userCount, 1, "Should have 1 user before removal")
        
        let removed = userManager.removeUser(by: user.id)
        XCTAssertTrue(removed, "Should return true when user is removed")
        XCTAssertEqual(userManager.userCount, 0, "Should have 0 users after removal")
        
        let nonExistentRemoval = userManager.removeUser(by: UUID())
        XCTAssertFalse(nonExistentRemoval, "Should return false when trying to remove non-existent user")
    }
    
    func testClearAllUsers() throws {
        let user1 = User(name: "User1", email: "user1@example.com", age: 25)
        let user2 = User(name: "User2", email: "user2@example.com", age: 30)
        
        try userManager.addUser(user1)
        try userManager.addUser(user2)
        
        XCTAssertEqual(userManager.userCount, 2, "Should have 2 users")
        
        userManager.clearAllUsers()
        
        XCTAssertEqual(userManager.userCount, 0, "Should have 0 users after clearing")
        XCTAssertTrue(userManager.allUsers.isEmpty, "All users array should be empty")
    }
    
    // MARK: - StringUtilities Tests
    
    func testStringReverse() throws {
        XCTAssertEqual(StringUtilities.reverse("hello"), "olleh", "Should reverse string correctly")
        XCTAssertEqual(StringUtilities.reverse(""), "", "Should handle empty string")
        XCTAssertEqual(StringUtilities.reverse("a"), "a", "Should handle single character")
    }
    
    func testWordCount() throws {
        XCTAssertEqual(StringUtilities.wordCount("hello world"), 2, "Should count words correctly")
        XCTAssertEqual(StringUtilities.wordCount(""), 0, "Empty string should have 0 words")
        XCTAssertEqual(StringUtilities.wordCount("   "), 0, "Whitespace only should have 0 words")
        XCTAssertEqual(StringUtilities.wordCount("one"), 1, "Single word should count as 1")
        XCTAssertEqual(StringUtilities.wordCount("hello   world   test"), 3, "Should handle multiple spaces")
    }
    
    func testIsPalindrome() throws {
        XCTAssertTrue(StringUtilities.isPalindrome("racecar"), "Should recognize palindrome")
        XCTAssertTrue(StringUtilities.isPalindrome("A man a plan a canal Panama"), "Should handle complex palindrome")
        XCTAssertFalse(StringUtilities.isPalindrome("hello"), "Should reject non-palindrome")
        XCTAssertTrue(StringUtilities.isPalindrome(""), "Empty string should be palindrome")
        XCTAssertTrue(StringUtilities.isPalindrome("a"), "Single character should be palindrome")
    }
    
    func testTitleCase() throws {
        XCTAssertEqual(StringUtilities.titleCase("hello world"), "Hello World", "Should capitalize first letters")
        XCTAssertEqual(StringUtilities.titleCase(""), "", "Should handle empty string")
        XCTAssertEqual(StringUtilities.titleCase("a"), "A", "Should handle single character")
    }
    
    func testRemoveVowels() throws {
        XCTAssertEqual(StringUtilities.removeVowels("hello"), "hll", "Should remove vowels")
        XCTAssertEqual(StringUtilities.removeVowels("HELLO"), "HLL", "Should remove uppercase vowels")
        XCTAssertEqual(StringUtilities.removeVowels("bcdfg"), "bcdfg", "Should leave consonants unchanged")
        XCTAssertEqual(StringUtilities.removeVowels(""), "", "Should handle empty string")
    }
    
    func testCountOccurrences() throws {
        XCTAssertEqual(StringUtilities.countOccurrences(of: "l", in: "hello"), 2, "Should count character occurrences")
        XCTAssertEqual(StringUtilities.countOccurrences(of: "x", in: "hello"), 0, "Should return 0 for non-existent character")
        XCTAssertEqual(StringUtilities.countOccurrences(of: "o", in: ""), 0, "Should handle empty string")
    }
    
    func testIsAlphabetic() throws {
        XCTAssertTrue(StringUtilities.isAlphabetic("hello"), "Should recognize alphabetic string")
        XCTAssertTrue(StringUtilities.isAlphabetic("HelloWorld"), "Should handle mixed case")
        XCTAssertFalse(StringUtilities.isAlphabetic("hello123"), "Should reject alphanumeric string")
        XCTAssertFalse(StringUtilities.isAlphabetic("hello world"), "Should reject string with spaces")
        XCTAssertFalse(StringUtilities.isAlphabetic(""), "Should reject empty string")
    }
    
    func testIsNumeric() throws {
        XCTAssertTrue(StringUtilities.isNumeric("12345"), "Should recognize numeric string")
        XCTAssertFalse(StringUtilities.isNumeric("123a45"), "Should reject mixed alphanumeric")
        XCTAssertFalse(StringUtilities.isNumeric(""), "Should reject empty string")
        XCTAssertFalse(StringUtilities.isNumeric("123.45"), "Should reject decimal numbers")
    }
    
    // MARK: - Performance Tests
    
    func testCalculatorPerformance() throws {
        // Test performance of calculator operations
        self.measure {
            for i in 1...1000 {
                let _ = calculator.add(Double(i), Double(i + 1))
                let _ = calculator.multiply(Double(i), 2.0)
            }
        }
    }
    
    func testUserManagerPerformance() throws {
        // Test performance of adding multiple users
        self.measure {
            let tempManager = UserManager()
            for i in 1...100 {
                let user = User(name: "User\(i)", email: "user\(i)@example.com", age: 25)
                try! tempManager.addUser(user)
            }
        }
    }
    
    func testStringUtilitiesPerformance() throws {
        // Test performance of string operations
        let longString = String(repeating: "hello world ", count: 1000)
        
        self.measure {
            let _ = StringUtilities.wordCount(longString)
            let _ = StringUtilities.reverse(longString)
            let _ = StringUtilities.isAlphabetic(longString)
        }
    }
    
    // MARK: - Edge Cases and Integration Tests
    
    func testComplexCalculatorOperations() throws {
        // Test chaining operations
        let step1 = calculator.add(10.0, 5.0) // 15
        let step2 = calculator.multiply(step1, 2.0) // 30
        let step3 = try calculator.divide(step2, 3.0) // 10
        let step4 = calculator.subtract(step3, 2.0) // 8
        
        XCTAssertEqual(step4, 8.0, "Complex calculation should work correctly")
    }
    
    func testUserManagerWithMultipleOperations() throws {
        // Test complex user management scenario
        let users = [
            User(name: "Alice", email: "alice@example.com", age: 25),
            User(name: "Bob", email: "bob@example.com", age: 17),
            User(name: "Charlie", email: "charlie@example.com", age: 30)
        ]
        
        // Add all users
        for user in users {
            try userManager.addUser(user)
        }
        
        XCTAssertEqual(userManager.userCount, 3, "Should have 3 users")
        XCTAssertEqual(userManager.adultUsers.count, 2, "Should have 2 adults")
        
        // Remove one user
        let removed = userManager.removeUser(by: users[1].id)
        XCTAssertTrue(removed, "Should successfully remove user")
        XCTAssertEqual(userManager.userCount, 2, "Should have 2 users after removal")
    }
    
    func testStringUtilitiesWithComplexInput() throws {
        let complexString = "The Quick Brown Fox Jumps Over The Lazy Dog"
        
        // Test multiple operations on the same string
        XCTAssertEqual(StringUtilities.wordCount(complexString), 9, "Should count words correctly")
        XCTAssertEqual(StringUtilities.titleCase(complexString.lowercased()), complexString, "Title case should work")
        XCTAssertFalse(StringUtilities.isPalindrome(complexString), "Should not be palindrome")
        XCTAssertTrue(StringUtilities.removeVowels(complexString).count < complexString.count, "Should remove vowels")
    }

}
