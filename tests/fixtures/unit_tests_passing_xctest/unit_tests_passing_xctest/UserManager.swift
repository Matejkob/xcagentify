//
//  UserManager.swift
//  unit_tests_passing_xctest
//
//  Created by Mateusz Bąk on 8/18/25.
//

import Foundation

/// Represents a user in the system
public struct User: Equatable, Codable {
    public let id: UUID
    public let name: String
    public let email: String
    public let age: Int
    
    public init(id: UUID = UUID(), name: String, email: String, age: Int) {
        self.id = id
        self.name = name
        self.email = email
        self.age = age
    }
    
    /// Validates if the user's email is in a valid format
    public var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    /// Determines if the user is an adult (18 or older)
    public var isAdult: Bool {
        return age >= 18
    }
}

/// Manages user operations
public class UserManager {
    private var users: [User] = []
    
    public init() {}
    
    /// Adds a new user to the system
    /// - Parameter user: The user to add
    /// - Throws: UserManagerError.invalidUser if user data is invalid
    public func addUser(_ user: User) throws {
        guard !user.name.isEmpty else {
            throw UserManagerError.invalidUser("Name cannot be empty")
        }
        
        guard user.isEmailValid else {
            throw UserManagerError.invalidUser("Email format is invalid")
        }
        
        guard user.age >= 0 && user.age <= 150 else {
            throw UserManagerError.invalidUser("Age must be between 0 and 150")
        }
        
        // Check for duplicate email
        if users.contains(where: { $0.email == user.email }) {
            throw UserManagerError.duplicateUser("User with this email already exists")
        }
        
        users.append(user)
    }
    
    /// Retrieves a user by ID
    /// - Parameter id: The user's ID
    /// - Returns: The user if found, nil otherwise
    public func getUser(by id: UUID) -> User? {
        return users.first { $0.id == id }
    }
    
    /// Retrieves a user by email
    /// - Parameter email: The user's email
    /// - Returns: The user if found, nil otherwise
    public func getUser(by email: String) -> User? {
        return users.first { $0.email == email }
    }
    
    /// Returns all users
    public var allUsers: [User] {
        return users
    }
    
    /// Returns count of users
    public var userCount: Int {
        return users.count
    }
    
    /// Returns all adult users (18+)
    public var adultUsers: [User] {
        return users.filter { $0.isAdult }
    }
    
    /// Removes a user by ID
    /// - Parameter id: The user's ID
    /// - Returns: True if user was removed, false if not found
    @discardableResult
    public func removeUser(by id: UUID) -> Bool {
        if let index = users.firstIndex(where: { $0.id == id }) {
            users.remove(at: index)
            return true
        }
        return false
    }
    
    /// Clears all users
    public func clearAllUsers() {
        users.removeAll()
    }
}

/// Errors that can be thrown by UserManager
public enum UserManagerError: Error {
    case invalidUser(String)
    case duplicateUser(String)
    case userNotFound
    
    public var localizedDescription: String {
        switch self {
        case .invalidUser(let message):
            return "Invalid user: \(message)"
        case .duplicateUser(let message):
            return "Duplicate user: \(message)"
        case .userNotFound:
            return "User not found"
        }
    }
}