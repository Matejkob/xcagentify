//
//  unit_tests_failing_xctestTests.swift
//  unit_tests_failing_xctestTests
//
//  Created by Mateusz Bąk on 8/18/25.
//

import XCTest
@testable import unit_tests_failing_xctest

final class unit_tests_failing_xctestTests: XCTestCase {
    
    var calculator: Calculator!
    var userManager: UserManager!

    override func setUpWithError() throws {
        calculator = Calculator()
        userManager = UserManager()
    }

    override func tearDownWithError() throws {
        calculator = nil
        userManager = nil
    }

    // MARK: - Calculator Tests (All Intentionally Failing)
    
    func testCalculatorAdditionFails() throws {
        // This test intentionally fails - we expect 8 but get 7
        let result = calculator.add(3, 4)
        XCTAssertEqual(result, 8.0, "Expected 3 + 4 to equal 8, but got \(result)")
    }
    
    func testCalculatorSubtractionFails() throws {
        // This test intentionally fails - we expect 5 but get 1
        let result = calculator.subtract(4, 3)
        XCTAssertEqual(result, 5.0, "Expected 4 - 3 to equal 5, but got \(result)")
    }
    
    func testCalculatorMultiplicationFails() throws {
        // This test intentionally fails - we expect 20 but get 12
        let result = calculator.multiply(3, 4)
        XCTAssertEqual(result, 20.0, "Expected 3 * 4 to equal 20, but got \(result)")
    }
    
    func testCalculatorDivisionFails() throws {
        // This test intentionally fails - we expect 3 but get 2
        let result = try calculator.divide(6, 3)
        XCTAssertEqual(result, 3.0, "Expected 6 / 3 to equal 3, but got \(result)")
    }
    
    func testCalculatorSqrtFails() throws {
        // This test intentionally fails - we expect 4 but get 3
        let result = try calculator.sqrt(9)
        XCTAssertEqual(result, 4.0, "Expected sqrt(9) to equal 4, but got \(result)")
    }
    
    func testCalculatorFactorialFails() throws {
        // This test intentionally fails - we expect 25 but get 24
        let result = try calculator.factorial(4)
        XCTAssertEqual(result, 25, "Expected factorial(4) to equal 25, but got \(result)")
    }
    
    func testCalculatorDivisionByZeroDoesNotThrow() throws {
        // This test intentionally fails - we expect no error but division by zero should throw
        XCTAssertNoThrow(try calculator.divide(10, 0), "Expected division by zero to not throw an error")
    }
    
    func testCalculatorNegativeSqrtDoesNotThrow() throws {
        // This test intentionally fails - we expect no error but negative sqrt should throw
        XCTAssertNoThrow(try calculator.sqrt(-4), "Expected negative square root to not throw an error")
    }

    // MARK: - UserManager Tests (All Intentionally Failing)
    
    func testUserManagerAddUserFails() throws {
        let user = User(name: "John Doe", email: "john@example.com", age: 30)
        try userManager.addUser(user)
        
        // This test intentionally fails - we expect 2 users but have 1
        XCTAssertEqual(userManager.getUserCount(), 2, "Expected 2 users after adding one user")
    }
    
    func testUserManagerGetUserFails() throws {
        let user = User(name: "Jane Smith", email: "jane@example.com", age: 25)
        try userManager.addUser(user)
        
        let retrievedUser = userManager.getUser(by: user.id)
        
        // This test intentionally fails - we expect the name to be "John Doe" but it's "Jane Smith"
        XCTAssertEqual(retrievedUser?.name, "John Doe", "Expected user name to be 'John Doe'")
    }
    
    func testUserManagerGetUserByEmailFails() throws {
        let user = User(name: "Bob Wilson", email: "bob@example.com", age: 35)
        try userManager.addUser(user)
        
        let retrievedUser = userManager.getUserByEmail("bob@example.com")
        
        // This test intentionally fails - we expect the age to be 40 but it's 35
        XCTAssertEqual(retrievedUser?.age, 40, "Expected user age to be 40")
    }
    
    func testUserManagerRemoveUserFails() throws {
        let user = User(name: "Alice Brown", email: "alice@example.com", age: 28)
        try userManager.addUser(user)
        
        let wasRemoved = userManager.removeUser(by: user.id)
        
        // This test intentionally fails - we expect removal to fail but it succeeds
        XCTAssertFalse(wasRemoved, "Expected user removal to fail")
    }
    
    func testUserManagerInvalidEmailDoesNotThrow() throws {
        let user = User(name: "Invalid User", email: "not-an-email", age: 30)
        
        // This test intentionally fails - we expect no error but invalid email should throw
        XCTAssertNoThrow(try userManager.addUser(user), "Expected invalid email to not throw an error")
    }
    
    func testUserManagerEmptyNameDoesNotThrow() throws {
        let user = User(name: "", email: "empty@example.com", age: 30)
        
        // This test intentionally fails - we expect no error but empty name should throw
        XCTAssertNoThrow(try userManager.addUser(user), "Expected empty name to not throw an error")
    }
    
    func testUserManagerInvalidAgeDoesNotThrow() throws {
        let user = User(name: "Invalid Age User", email: "invalid@example.com", age: -5)
        
        // This test intentionally fails - we expect no error but invalid age should throw
        XCTAssertNoThrow(try userManager.addUser(user), "Expected invalid age to not throw an error")
    }

    // MARK: - Boolean and Nil Tests (All Intentionally Failing)
    
    func testBooleanAssertionFails() throws {
        let condition = false
        // This test intentionally fails - we assert true but condition is false
        XCTAssertTrue(condition, "Expected condition to be true")
    }
    
    func testNilAssertionFails() throws {
        let optionalValue: String? = "not nil"
        // This test intentionally fails - we assert nil but value is not nil
        XCTAssertNil(optionalValue, "Expected value to be nil")
    }
    
    func testNotNilAssertionFails() throws {
        let optionalValue: String? = nil
        // This test intentionally fails - we assert not nil but value is nil
        XCTAssertNotNil(optionalValue, "Expected value to not be nil")
    }
    
    func testGreaterThanAssertionFails() throws {
        let value = 5
        // This test intentionally fails - we assert 5 > 10 which is false
        XCTAssertGreaterThan(value, 10, "Expected \(value) to be greater than 10")
    }
    
    func testLessThanAssertionFails() throws {
        let value = 15
        // This test intentionally fails - we assert 15 < 10 which is false
        XCTAssertLessThan(value, 10, "Expected \(value) to be less than 10")
    }

    // MARK: - String and Collection Tests (All Intentionally Failing)
    
    func testStringContainsFails() throws {
        let text = "Hello, World!"
        // This test intentionally fails - text doesn't contain "Swift"
        XCTAssertTrue(text.contains("Swift"), "Expected text to contain 'Swift'")
    }
    
    func testArrayCountFails() throws {
        let numbers = [1, 2, 3, 4, 5]
        // This test intentionally fails - array has 5 elements, not 10
        XCTAssertEqual(numbers.count, 10, "Expected array to have 10 elements")
    }
    
    func testArrayContainsFails() throws {
        let fruits = ["apple", "banana", "orange"]
        // This test intentionally fails - array doesn't contain "grape"
        XCTAssertTrue(fruits.contains("grape"), "Expected fruits to contain 'grape'")
    }

    // MARK: - Performance Test (Intentionally Failing)
    
    func testPerformanceFailure() throws {
        // This performance test intentionally fails by having unrealistic expectations
        self.measure {
            // Simulate some work that takes time
            var sum = 0
            for i in 0..<1_000_000 {
                sum += i
            }
            // The baseline is set too low, so this will likely fail performance expectations
        }
    }

}
