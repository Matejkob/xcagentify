//
//  UserManager.swift
//  unit_tests_failing_xctest
//
//  Created by Mateusz Bąk on 8/18/25.
//

import Foundation

struct User {
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
}

class UserManager {
    private var users: [UUID: User] = [:]
    
    func addUser(_ user: User) throws {
        guard !user.name.isEmpty else {
            throw UserManagerError.emptyName
        }
        guard user.email.contains("@") && user.email.contains(".") else {
            throw UserManagerError.invalidEmail
        }
        guard user.age >= 0 && user.age <= 150 else {
            throw UserManagerError.invalidAge
        }
        
        users[user.id] = user
    }
    
    func getUser(by id: UUID) -> User? {
        return users[id]
    }
    
    func getUserByEmail(_ email: String) -> User? {
        return users.values.first { $0.email == email }
    }
    
    func getAllUsers() -> [User] {
        return Array(users.values)
    }
    
    func removeUser(by id: UUID) -> Bool {
        return users.removeValue(forKey: id) != nil
    }
    
    func updateUser(_ user: User) throws {
        guard users[user.id] != nil else {
            throw UserManagerError.userNotFound
        }
        guard !user.name.isEmpty else {
            throw UserManagerError.emptyName
        }
        guard user.email.contains("@") && user.email.contains(".") else {
            throw UserManagerError.invalidEmail
        }
        guard user.age >= 0 && user.age <= 150 else {
            throw UserManagerError.invalidAge
        }
        
        users[user.id] = user
    }
    
    func getUserCount() -> Int {
        return users.count
    }
    
    func clearAllUsers() {
        users.removeAll()
    }
}

enum UserManagerError: Error {
    case emptyName
    case invalidEmail
    case invalidAge
    case userNotFound
}