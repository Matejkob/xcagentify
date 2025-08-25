//
//  UserManager.swift
//  unit_tests_passing_swift_testing
//
//  Created by Mateusz Bąk on 8/18/25.
//

import Foundation

/// A user model for testing
struct User: Equatable, Codable {
    let id: UUID
    let name: String
    let email: String
    let age: Int
    
    init(name: String, email: String, age: Int) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.age = age
    }
    
    var isAdult: Bool {
        return age >= 18
    }
    
    var isValidEmail: Bool {
        return email.contains("@") && email.contains(".")
    }
}

/// A service for managing users with various operations
class UserManager {
    private var users: [User] = []
    
    // MARK: - User Management
    
    func addUser(_ user: User) throws {
        guard user.isValidEmail else {
            throw UserManagerError.invalidEmail
        }
        guard user.age >= 0 else {
            throw UserManagerError.invalidAge
        }
        guard !user.name.isEmpty else {
            throw UserManagerError.emptyName
        }
        
        // Check for duplicate email
        guard !users.contains(where: { $0.email.lowercased() == user.email.lowercased() }) else {
            throw UserManagerError.duplicateEmail
        }
        
        users.append(user)
    }
    
    func removeUser(withId id: UUID) -> Bool {
        if let index = users.firstIndex(where: { $0.id == id }) {
            users.remove(at: index)
            return true
        }
        return false
    }
    
    func getUser(withId id: UUID) -> User? {
        return users.first { $0.id == id }
    }
    
    func getAllUsers() -> [User] {
        return users
    }
    
    func clearAllUsers() {
        users.removeAll()
    }
    
    // MARK: - Query Operations
    
    func getAdultUsers() -> [User] {
        return users.filter { $0.isAdult }
    }
    
    func getMinorUsers() -> [User] {
        return users.filter { !$0.isAdult }
    }
    
    func getUsersOlderThan(_ age: Int) -> [User] {
        return users.filter { $0.age > age }
    }
    
    func getUsersByEmailDomain(_ domain: String) -> [User] {
        return users.filter { $0.email.lowercased().hasSuffix("@\(domain.lowercased())") }
    }
    
    func searchUsersByName(_ query: String) -> [User] {
        return users.filter { $0.name.lowercased().contains(query.lowercased()) }
    }
    
    // MARK: - Statistics
    
    func getUserCount() -> Int {
        return users.count
    }
    
    func getAverageAge() throws -> Double {
        guard !users.isEmpty else {
            throw UserManagerError.noUsers
        }
        let totalAge = users.map { $0.age }.reduce(0, +)
        return Double(totalAge) / Double(users.count)
    }
    
    func getOldestUser() throws -> User {
        guard let oldest = users.max(by: { $0.age < $1.age }) else {
            throw UserManagerError.noUsers
        }
        return oldest
    }
    
    func getYoungestUser() throws -> User {
        guard let youngest = users.min(by: { $0.age < $1.age }) else {
            throw UserManagerError.noUsers
        }
        return youngest
    }
}

// MARK: - UserManager Errors

enum UserManagerError: Error, Equatable {
    case invalidEmail
    case invalidAge
    case emptyName
    case duplicateEmail
    case noUsers
    
    var localizedDescription: String {
        switch self {
        case .invalidEmail:
            return "Invalid email format"
        case .invalidAge:
            return "Age cannot be negative"
        case .emptyName:
            return "Name cannot be empty"
        case .duplicateEmail:
            return "User with this email already exists"
        case .noUsers:
            return "No users available"
        }
    }
}