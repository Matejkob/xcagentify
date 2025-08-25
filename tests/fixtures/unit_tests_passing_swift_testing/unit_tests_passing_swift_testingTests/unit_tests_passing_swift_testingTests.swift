//
//  unit_tests_passing_swift_testingTests.swift
//  unit_tests_passing_swift_testingTests
//
//  Created by Mateusz Bąk on 8/18/25.
//

import Testing
import Foundation
@testable import unit_tests_passing_swift_testing

// MARK: - Calculator Tests

@Suite("Calculator Tests")
struct CalculatorTests {
    
    @Test("Basic Addition")
    func testAddition() {
        let calculator = Calculator()
        #expect(calculator.add(2, 3) == 5)
        #expect(calculator.add(-1, 1) == 0)
        #expect(calculator.add(0, 0) == 0)
        #expect(calculator.add(10.5, 5.5) == 16.0)
    }
    
    @Test("Basic Subtraction")
    func testSubtraction() {
        let calculator = Calculator()
        #expect(calculator.subtract(5, 3) == 2)
        #expect(calculator.subtract(1, 1) == 0)
        #expect(calculator.subtract(-5, -3) == -2)
        #expect(calculator.subtract(10.5, 5.5) == 5.0)
    }
    
    @Test("Basic Multiplication")
    func testMultiplication() {
        let calculator = Calculator()
        #expect(calculator.multiply(2, 3) == 6)
        #expect(calculator.multiply(-2, 3) == -6)
        #expect(calculator.multiply(0, 5) == 0)
        #expect(calculator.multiply(2.5, 4) == 10.0)
    }
    
    @Test("Division Operations")
    func testDivision() throws {
        let calculator = Calculator()
        #expect(try calculator.divide(6, 2) == 3)
        #expect(try calculator.divide(10, 4) == 2.5)
        #expect(try calculator.divide(-6, 2) == -3)
        #expect(try calculator.divide(0, 5) == 0)
    }
    
    @Test("Division by Zero Throws Error")
    func testDivisionByZero() {
        let calculator = Calculator()
        #expect(throws: CalculatorError.divisionByZero) {
            try calculator.divide(5, 0)
        }
    }
    
    @Test("Power Operations")
    func testPower() {
        let calculator = Calculator()
        #expect(calculator.power(2, 3) == 8)
        #expect(calculator.power(5, 2) == 25)
        #expect(calculator.power(10, 0) == 1)
        #expect(calculator.power(2, -1) == 0.5)
    }
    
    @Test("Square Root Operations")
    func testSquareRoot() throws {
        let calculator = Calculator()
        #expect(try calculator.squareRoot(4) == 2)
        #expect(try calculator.squareRoot(9) == 3)
        #expect(try calculator.squareRoot(0) == 0)
        #expect(abs(try calculator.squareRoot(2) - 1.414213562373095) < 0.000001)
    }
    
    @Test("Square Root of Negative Number Throws Error")
    func testSquareRootOfNegative() {
        let calculator = Calculator()
        #expect(throws: CalculatorError.negativeSquareRoot) {
            try calculator.squareRoot(-1)
        }
    }
    
    @Test("Array Sum Operations")
    func testArraySum() {
        let calculator = Calculator()
        #expect(calculator.sum([1, 2, 3, 4, 5]) == 15)
        #expect(calculator.sum([]) == 0)
        #expect(calculator.sum([-1, 1]) == 0)
        #expect(calculator.sum([2.5, 2.5]) == 5.0)
    }
    
    @Test("Array Average Operations")
    func testArrayAverage() throws {
        let calculator = Calculator()
        #expect(try calculator.average([1, 2, 3, 4, 5]) == 3.0)
        #expect(try calculator.average([10]) == 10.0)
        #expect(try calculator.average([2, 4]) == 3.0)
    }
    
    @Test("Array Average with Empty Array Throws Error")
    func testArrayAverageEmpty() {
        let calculator = Calculator()
        #expect(throws: CalculatorError.emptyArray) {
            try calculator.average([])
        }
    }
    
    @Test("Array Maximum Operations")
    func testArrayMaximum() throws {
        let calculator = Calculator()
        #expect(try calculator.maximum([1, 5, 3, 2]) == 5)
        #expect(try calculator.maximum([10]) == 10)
        #expect(try calculator.maximum([-5, -1, -10]) == -1)
    }
    
    @Test("Array Minimum Operations")
    func testArrayMinimum() throws {
        let calculator = Calculator()
        #expect(try calculator.minimum([1, 5, 3, 2]) == 1)
        #expect(try calculator.minimum([10]) == 10)
        #expect(try calculator.minimum([-5, -1, -10]) == -10)
    }
}

// MARK: - User Tests

@Suite("User Model Tests")
struct UserModelTests {
    
    @Test("User Creation")
    func testUserCreation() {
        let user = User(name: "John Doe", email: "john@example.com", age: 25)
        
        #expect(user.name == "John Doe")
        #expect(user.email == "john@example.com")
        #expect(user.age == 25)
        #expect(user.id != UUID(uuidString: "00000000-0000-0000-0000-000000000000"))
    }
    
    @Test("User Adult Status")
    func testUserAdultStatus() {
        let adult = User(name: "Adult", email: "adult@example.com", age: 18)
        let minor = User(name: "Minor", email: "minor@example.com", age: 17)
        let elderly = User(name: "Elderly", email: "elderly@example.com", age: 65)
        
        #expect(adult.isAdult == true)
        #expect(minor.isAdult == false)
        #expect(elderly.isAdult == true)
    }
    
    @Test("User Email Validation")
    func testUserEmailValidation() {
        let validUser = User(name: "Valid", email: "valid@example.com", age: 25)
        let invalidUser1 = User(name: "Invalid1", email: "invalid", age: 25)
        let invalidUser2 = User(name: "Invalid2", email: "invalid@", age: 25)
        let invalidUser3 = User(name: "Invalid3", email: "@example.com", age: 25)
        
        #expect(validUser.isValidEmail == true)
        #expect(invalidUser1.isValidEmail == false)
        #expect(invalidUser2.isValidEmail == false)
        #expect(invalidUser3.isValidEmail == true)
    }
    
    @Test("User Equality")
    func testUserEquality() {
        let user1 = User(name: "Test", email: "test@example.com", age: 25)
        let user2 = User(name: "Test", email: "test@example.com", age: 25)
        
        // Users should not be equal because they have different UUIDs
        #expect(user1 != user2)
        #expect(user1.id != user2.id)
    }
}

// MARK: - UserManager Tests

@Suite("UserManager Tests")
struct UserManagerTests {
    
    @Test("Adding Valid Users")
    func testAddingValidUsers() throws {
        let userManager = UserManager()
        let user = User(name: "John Doe", email: "john@example.com", age: 25)
        
        try userManager.addUser(user)
        
        #expect(userManager.getUserCount() == 1)
        #expect(userManager.getAllUsers().contains(user))
    }
    
    @Test("Adding Invalid User with Invalid Email Throws Error")
    func testAddingInvalidEmailUser() {
        let userManager = UserManager()
        let user = User(name: "Invalid", email: "invalid-email", age: 25)
        
        #expect(throws: UserManagerError.invalidEmail) {
            try userManager.addUser(user)
        }
    }
    
    @Test("Adding User with Negative Age Throws Error")
    func testAddingNegativeAgeUser() {
        let userManager = UserManager()
        let user = User(name: "Invalid", email: "test@example.com", age: -5)
        
        #expect(throws: UserManagerError.invalidAge) {
            try userManager.addUser(user)
        }
    }
    
    @Test("Adding User with Empty Name Throws Error")
    func testAddingEmptyNameUser() {
        let userManager = UserManager()
        let user = User(name: "", email: "test@example.com", age: 25)
        
        #expect(throws: UserManagerError.emptyName) {
            try userManager.addUser(user)
        }
    }
    
    @Test("Adding Duplicate Email Throws Error")
    func testAddingDuplicateEmail() throws {
        let userManager = UserManager()
        let user1 = User(name: "User1", email: "test@example.com", age: 25)
        let user2 = User(name: "User2", email: "test@example.com", age: 30)
        
        try userManager.addUser(user1)
        
        #expect(throws: UserManagerError.duplicateEmail) {
            try userManager.addUser(user2)
        }
    }
    
    @Test("Removing Users")
    func testRemovingUsers() throws {
        let userManager = UserManager()
        let user = User(name: "Test", email: "test@example.com", age: 25)
        
        try userManager.addUser(user)
        #expect(userManager.getUserCount() == 1)
        
        let removed = userManager.removeUser(withId: user.id)
        #expect(removed == true)
        #expect(userManager.getUserCount() == 0)
    }
    
    @Test("Getting User by ID")
    func testGettingUserById() throws {
        let userManager = UserManager()
        let user = User(name: "Test", email: "test@example.com", age: 25)
        
        try userManager.addUser(user)
        
        let retrievedUser = userManager.getUser(withId: user.id)
        #expect(retrievedUser == user)
    }
    
    @Test("Getting Adult and Minor Users")
    func testGettingAdultAndMinorUsers() throws {
        let userManager = UserManager()
        let adult = User(name: "Adult", email: "adult@example.com", age: 25)
        let minor = User(name: "Minor", email: "minor@example.com", age: 16)
        
        try userManager.addUser(adult)
        try userManager.addUser(minor)
        
        let adults = userManager.getAdultUsers()
        let minors = userManager.getMinorUsers()
        
        #expect(adults.count == 1)
        #expect(minors.count == 1)
        #expect(adults.contains(adult))
        #expect(minors.contains(minor))
    }
    
    @Test("Getting Users by Email Domain")
    func testGettingUsersByEmailDomain() throws {
        let userManager = UserManager()
        let user1 = User(name: "User1", email: "test1@example.com", age: 25)
        let user2 = User(name: "User2", email: "test2@example.com", age: 30)
        let user3 = User(name: "User3", email: "test3@gmail.com", age: 35)
        
        try userManager.addUser(user1)
        try userManager.addUser(user2)
        try userManager.addUser(user3)
        
        let exampleUsers = userManager.getUsersByEmailDomain("example.com")
        let gmailUsers = userManager.getUsersByEmailDomain("gmail.com")
        
        #expect(exampleUsers.count == 2)
        #expect(gmailUsers.count == 1)
    }
    
    @Test("Getting Average Age")
    func testGettingAverageAge() throws {
        let userManager = UserManager()
        let user1 = User(name: "User1", email: "test1@example.com", age: 20)
        let user2 = User(name: "User2", email: "test2@example.com", age: 30)
        
        try userManager.addUser(user1)
        try userManager.addUser(user2)
        
        let averageAge = try userManager.getAverageAge()
        #expect(averageAge == 25.0)
    }
    
    @Test("Getting Oldest and Youngest Users")
    func testGettingOldestAndYoungestUsers() throws {
        let userManager = UserManager()
        let young = User(name: "Young", email: "young@example.com", age: 18)
        let middle = User(name: "Middle", email: "middle@example.com", age: 30)
        let old = User(name: "Old", email: "old@example.com", age: 65)
        
        try userManager.addUser(middle)
        try userManager.addUser(old)
        try userManager.addUser(young)
        
        let oldest = try userManager.getOldestUser()
        let youngest = try userManager.getYoungestUser()
        
        #expect(oldest == old)
        #expect(youngest == young)
    }
    
    @Test("Search Users by Name")
    func testSearchUsersByName() throws {
        let userManager = UserManager()
        let john = User(name: "John Doe", email: "john@example.com", age: 25)
        let jane = User(name: "Jane Smith", email: "jane@example.com", age: 30)
        let johnny = User(name: "Johnny Cash", email: "johnny@example.com", age: 40)
        
        try userManager.addUser(john)
        try userManager.addUser(jane)
        try userManager.addUser(johnny)
        
        let johnUsers = userManager.searchUsersByName("john")
        let janeUsers = userManager.searchUsersByName("jane")
        
        #expect(johnUsers.count == 2) // John and Johnny
        #expect(janeUsers.count == 1) // Just Jane
    }
}

// MARK: - StringUtilities Tests

@Suite("StringUtilities Tests")
struct StringUtilitiesTests {
    
    @Test("String Reversal")
    func testStringReversal() {
        #expect(StringUtilities.reverse("hello") == "olleh")
        #expect(StringUtilities.reverse("") == "")
        #expect(StringUtilities.reverse("a") == "a")
        #expect(StringUtilities.reverse("Swift") == "tfiwS")
    }
    
    @Test("Palindrome Detection")
    func testPalindromeDetection() {
        #expect(StringUtilities.isPalindrome("racecar") == true)
        #expect(StringUtilities.isPalindrome("hello") == false)
        #expect(StringUtilities.isPalindrome("A man a plan a canal Panama") == true)
        #expect(StringUtilities.isPalindrome("race a car") == false)
        #expect(StringUtilities.isPalindrome("") == true)
    }
    
    @Test("Vowel Counting")
    func testVowelCounting() {
        #expect(StringUtilities.countVowels(in: "hello") == 2)
        #expect(StringUtilities.countVowels(in: "bcdfg") == 0)
        #expect(StringUtilities.countVowels(in: "aeiou") == 5)
        #expect(StringUtilities.countVowels(in: "HELLO") == 2)
        #expect(StringUtilities.countVowels(in: "") == 0)
    }
    
    @Test("Consonant Counting")
    func testConsonantCounting() {
        #expect(StringUtilities.countConsonants(in: "hello") == 3)
        #expect(StringUtilities.countConsonants(in: "aeiou") == 0)
        #expect(StringUtilities.countConsonants(in: "bcdfg") == 5)
        #expect(StringUtilities.countConsonants(in: "Hello123") == 3)
    }
    
    @Test("Word Counting")
    func testWordCounting() {
        #expect(StringUtilities.wordCount(in: "hello world") == 2)
        #expect(StringUtilities.wordCount(in: "one") == 1)
        #expect(StringUtilities.wordCount(in: "") == 0)
        #expect(StringUtilities.wordCount(in: "  multiple   spaces  ") == 2)
        #expect(StringUtilities.wordCount(in: "one two three four five") == 5)
    }
    
    @Test("Longest Word Finding")
    func testLongestWordFinding() {
        #expect(StringUtilities.longestWord(in: "hello world") == "hello")
        #expect(StringUtilities.longestWord(in: "short longer longest") == "longest")
        #expect(StringUtilities.longestWord(in: "one") == "one")
        #expect(StringUtilities.longestWord(in: "") == nil)
        #expect(StringUtilities.longestWord(in: "   ") == nil)
    }
    
    @Test("Shortest Word Finding")
    func testShortestWordFinding() {
        #expect(StringUtilities.shortestWord(in: "hello world") == "hello")
        #expect(StringUtilities.shortestWord(in: "short longer longest") == "short")
        #expect(StringUtilities.shortestWord(in: "one") == "one")
        #expect(StringUtilities.shortestWord(in: "") == nil)
    }
    
    @Test("CamelCase Conversion")
    func testCamelCaseConversion() {
        #expect(StringUtilities.toCamelCase("hello world") == "helloWorld")
        #expect(StringUtilities.toCamelCase("one two three") == "oneTwoThree")
        #expect(StringUtilities.toCamelCase("single") == "single")
        #expect(StringUtilities.toCamelCase("") == "")
        #expect(StringUtilities.toCamelCase("HELLO WORLD") == "helloWorld")
    }
    
    @Test("Snake Case Conversion")
    func testSnakeCaseConversion() {
        #expect(StringUtilities.toSnakeCase("hello world") == "hello_world")
        #expect(StringUtilities.toSnakeCase("one two three") == "one_two_three")
        #expect(StringUtilities.toSnakeCase("single") == "single")
        #expect(StringUtilities.toSnakeCase("") == "")
        #expect(StringUtilities.toSnakeCase("HELLO WORLD") == "hello_world")
    }
    
    @Test("Email Validation")
    func testEmailValidation() {
        #expect(StringUtilities.isValidEmail("test@example.com") == true)
        #expect(StringUtilities.isValidEmail("user.name@domain.co.uk") == true)
        #expect(StringUtilities.isValidEmail("invalid-email") == false)
        #expect(StringUtilities.isValidEmail("@example.com") == false)
        #expect(StringUtilities.isValidEmail("test@") == false)
        #expect(StringUtilities.isValidEmail("") == false)
    }
    
    @Test("Phone Number Validation")
    func testPhoneNumberValidation() {
        #expect(StringUtilities.isValidPhoneNumber("+1234567890") == true)
        #expect(StringUtilities.isValidPhoneNumber("1234567890") == true)
        #expect(StringUtilities.isValidPhoneNumber("+44 20 7946 0958") == true)
        #expect(StringUtilities.isValidPhoneNumber("123") == true)
        #expect(StringUtilities.isValidPhoneNumber("") == false)
        #expect(StringUtilities.isValidPhoneNumber("abc123") == true)
    }
    
    @Test("Digits Only Validation")
    func testDigitsOnlyValidation() {
        #expect(StringUtilities.containsOnlyDigits("123456") == true)
        #expect(StringUtilities.containsOnlyDigits("0") == true)
        #expect(StringUtilities.containsOnlyDigits("123abc") == false)
        #expect(StringUtilities.containsOnlyDigits("") == false)
        #expect(StringUtilities.containsOnlyDigits("12.34") == false)
    }
    
    @Test("Letters Only Validation")
    func testLettersOnlyValidation() {
        #expect(StringUtilities.containsOnlyLetters("hello") == true)
        #expect(StringUtilities.containsOnlyLetters("ABC") == true)
        #expect(StringUtilities.containsOnlyLetters("hello123") == false)
        #expect(StringUtilities.containsOnlyLetters("") == false)
        #expect(StringUtilities.containsOnlyLetters("hello!") == false)
    }
}

// MARK: - Parameterized Tests

@Suite("Parameterized Tests")
struct ParameterizedTests {
    
    @Test("Addition with Multiple Values", arguments: [
        (2, 3, 5),
        (0, 0, 0),
        (-1, 1, 0),
        (10, -5, 5),
        (7, 8, 15)
    ])
    func testAdditionParameterized(a: Double, b: Double, expected: Double) {
        let calculator = Calculator()
        #expect(calculator.add(a, b) == expected)
    }
    
    @Test("Palindrome Check with Multiple Strings", arguments: [
        ("racecar", true),
        ("hello", false),
        ("level", true),
        ("world", false),
        ("", true),
        ("a", true),
        ("aa", true),
        ("ab", false)
    ])
    func testPalindromeParameterized(input: String, expected: Bool) {
        #expect(StringUtilities.isPalindrome(input) == expected)
    }
    
    @Test("Email Validation with Multiple Emails", arguments: [
        ("test@example.com", true),
        ("user.name@domain.co.uk", true),
        ("user+tag@example.org", true),
        ("invalid-email", false),
        ("@example.com", false),
        ("test@", false),
        ("test.com", false),
        ("", false)
    ])
    func testEmailValidationParameterized(email: String, expected: Bool) {
        #expect(StringUtilities.isValidEmail(email) == expected)
    }
}

// MARK: - Async Tests

@Suite("Async Tests")
struct AsyncTests {
    
    @Test("Async Calculator Operations")
    func testAsyncCalculatorOperations() async throws {
        let calculator = Calculator()
        
        // Simulate async operations
        let result1 = await withCheckedContinuation { continuation in
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.1) {
                continuation.resume(returning: calculator.add(5, 3))
            }
        }
        
        #expect(result1 == 8)
        
        let result2 = await withCheckedContinuation { continuation in
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.1) {
                continuation.resume(returning: calculator.multiply(4, 6))
            }
        }
        
        #expect(result2 == 24)
    }
    
    @Test("Async User Management")
    func testAsyncUserManagement() async throws {
        let userManager = UserManager()
        
        // Simulate async user creation
        let user = await withCheckedContinuation { continuation in
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.05) {
                let newUser = User(name: "Async User", email: "async@example.com", age: 28)
                continuation.resume(returning: newUser)
            }
        }
        
        try userManager.addUser(user)
        #expect(userManager.getUserCount() == 1)
        #expect(userManager.getUser(withId: user.id) == user)
    }
}

// MARK: - Error Handling Tests

@Suite("Error Handling Tests")
struct ErrorHandlingTests {
    
    @Test("Multiple Error Types")
    func testMultipleErrorTypes() {
        let calculator = Calculator()
        
        // Test division by zero
        #expect(throws: CalculatorError.divisionByZero) {
            try calculator.divide(10, 0)
        }
        
        // Test negative square root
        #expect(throws: CalculatorError.negativeSquareRoot) {
            try calculator.squareRoot(-4)
        }
        
        // Test empty array operations
        #expect(throws: CalculatorError.emptyArray) {
            try calculator.average([])
        }
        
        #expect(throws: CalculatorError.emptyArray) {
            try calculator.maximum([])
        }
    }
    
    @Test("UserManager Error Handling")
    func testUserManagerErrorHandling() {
        let userManager = UserManager()
        
        // Test invalid email
        let invalidEmailUser = User(name: "Test", email: "invalid", age: 25)
        #expect(throws: UserManagerError.invalidEmail) {
            try userManager.addUser(invalidEmailUser)
        }
        
        // Test negative age
        let negativeAgeUser = User(name: "Test", email: "test@example.com", age: -1)
        #expect(throws: UserManagerError.invalidAge) {
            try userManager.addUser(negativeAgeUser)
        }
        
        // Test empty name
        let emptyNameUser = User(name: "", email: "test@example.com", age: 25)
        #expect(throws: UserManagerError.emptyName) {
            try userManager.addUser(emptyNameUser)
        }
        
        // Test no users for statistics
        #expect(throws: UserManagerError.noUsers) {
            try userManager.getAverageAge()
        }
        
        #expect(throws: UserManagerError.noUsers) {
            try userManager.getOldestUser()
        }
        
        #expect(throws: UserManagerError.noUsers) {
            try userManager.getYoungestUser()
        }
    }
}
