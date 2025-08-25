//
//  UserManager.swift
//  unit_tests_failing_swift_testing
//
//  Created by Mateusz Bąk on 8/18/25.
//

import Foundation

/// A user management class for demonstrating failing tests
class UserManager {
    private var users: [User] = []
    
    func addUser(_ user: User) throws {
        guard !user.email.isEmpty else {
            throw UserError.invalidEmail
        }
        guard user.age >= 0 else {
            throw UserError.invalidAge
        }
        guard !users.contains(where: { $0.email == user.email }) else {
            throw UserError.userAlreadyExists
        }
        users.append(user)
    }
    
    func getUser(by email: String) -> User? {
        return users.first { $0.email == email }
    }
    
    func getAllUsers() -> [User] {
        return users
    }
    
    func updateUserAge(_ email: String, newAge: Int) throws {
        guard newAge >= 0 else {
            throw UserError.invalidAge
        }
        guard let index = users.firstIndex(where: { $0.email == email }) else {
            throw UserError.userNotFound
        }
        users[index].age = newAge
    }
    
    func deleteUser(email: String) throws {
        guard let index = users.firstIndex(where: { $0.email == email }) else {
            throw UserError.userNotFound
        }
        users.remove(at: index)
    }
    
    func getUserCount() -> Int {
        return users.count
    }
    
    func isValidEmail(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }
}

struct User: Equatable {
    let id: UUID
    let name: String
    let email: String
    var age: Int
    
    init(name: String, email: String, age: Int) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.age = age
    }
}

enum UserError: Error, Equatable {
    case invalidEmail
    case invalidAge
    case userAlreadyExists
    case userNotFound
}