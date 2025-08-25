//
//  CalculatorFailingTests.swift
//  unit_tests_failing_xctestTests
//
//  Created by Mateusz Bąk on 8/18/25.
//

import XCTest
@testable import unit_tests_failing_xctest

final class CalculatorFailingTests: XCTestCase {
    
    var calculator: Calculator!

    override func setUpWithError() throws {
        calculator = Calculator()
    }

    override func tearDownWithError() throws {
        calculator = nil
    }

    // MARK: - Edge Case Tests (All Intentionally Failing)
    
    func testAdditionWithDecimalsFails() throws {
        let result = calculator.add(0.1, 0.2)
        // This test intentionally fails due to floating point precision issues
        XCTAssertEqual(result, 0.3, accuracy: 0.0, "Expected 0.1 + 0.2 to exactly equal 0.3")
    }
    
    func testMultiplicationByZeroFails() throws {
        let result = calculator.multiply(5, 0)
        // This test intentionally fails - we expect 5 but get 0
        XCTAssertEqual(result, 5.0, "Expected 5 * 0 to equal 5")
    }
    
    func testFactorialOfZeroFails() throws {
        let result = try calculator.factorial(0)
        // This test intentionally fails - factorial(0) should be 1, we expect 0
        XCTAssertEqual(result, 0, "Expected factorial(0) to equal 0")
    }
    
    func testFactorialOfLargeNumberDoesNotThrow() throws {
        // This test intentionally fails - factorial(25) should throw an error for being too large
        XCTAssertNoThrow(try calculator.factorial(25), "Expected factorial(25) to not throw an error")
    }
    
    func testSqrtOfOneFails() throws {
        let result = try calculator.sqrt(1)
        // This test intentionally fails - sqrt(1) is 1, we expect 2
        XCTAssertEqual(result, 2.0, "Expected sqrt(1) to equal 2")
    }
    
    func testDivisionResultIsInteger() throws {
        let result = try calculator.divide(7, 2)
        // This test intentionally fails - 7/2 is 3.5, we check if it's an integer
        XCTAssertEqual(result, Double(Int(result)), "Expected 7/2 to be an integer")
    }

    // MARK: - Async Tests (All Intentionally Failing)
    
    func testAsyncCalculationFails() async throws {
        // Simulate an async calculation that fails
        let result = await performAsyncCalculation()
        XCTAssertEqual(result, 100.0, "Expected async calculation to return 100")
    }
    
    private func performAsyncCalculation() async -> Double {
        // Simulate some async work
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        return calculator.add(10, 15) // Returns 25, but we expect 100
    }
    
    func testAsyncFactorialFails() async throws {
        let result = await performAsyncFactorial(5)
        // This test intentionally fails - factorial(5) is 120, we expect 200
        XCTAssertEqual(result, 200, "Expected async factorial(5) to return 200")
    }
    
    private func performAsyncFactorial(_ n: Int) async -> Int {
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds
        do {
            return try calculator.factorial(n)
        } catch {
            return 0
        }
    }

    // MARK: - Exception Expectation Tests (All Intentionally Failing)
    
    func testExpectsWrongExceptionType() throws {
        // This test fails because we expect the wrong error type
        XCTAssertThrowsError(try calculator.divide(10, 0)) { error in
            XCTAssertTrue(error is UserManagerError, "Expected UserManagerError but got \(type(of: error))")
        }
    }
    
    func testExpectsNoExceptionButGetsOne() throws {
        // This test fails because division by zero throws an error
        let result = try calculator.divide(10, 0)
        XCTAssertEqual(result, Double.infinity, "Expected division by zero to return infinity")
    }
    
    func testNegativeFactorialExpectsWrongError() throws {
        XCTAssertThrowsError(try calculator.factorial(-5)) { error in
            guard let calcError = error as? CalculatorError else {
                XCTFail("Expected CalculatorError")
                return
            }
            // This fails because we expect the wrong specific error type
            XCTAssertEqual(calcError, .factorialTooLarge, "Expected factorialTooLarge error")
        }
    }

    // MARK: - Timeout Tests (May Fail Due to Timing)
    
    func testCalculationTimeout() throws {
        let expectation = XCTestExpectation(description: "Calculation should complete quickly")
        
        DispatchQueue.global().async {
            // Simulate a slow calculation
            Thread.sleep(forTimeInterval: 2.0)
            let _ = self.calculator.add(1, 1)
            expectation.fulfill()
        }
        
        // This may fail if the calculation takes longer than 1 second
        wait(for: [expectation], timeout: 1.0)
    }

}