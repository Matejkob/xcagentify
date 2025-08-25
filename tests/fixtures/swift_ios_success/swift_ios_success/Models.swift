import Foundation
import Combine

// MARK: - Core Data Models

protocol UserProtocol {
    var name: String { get set }
    var email: String { get set }
}

struct User: Codable, Identifiable, UserProtocol {
    let id: UUID
    var name: String
    var email: String
    var createdAt: Date
    var preferences: UserPreferences
    
    init(name: String, email: String) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.createdAt = Date()
        self.preferences = UserPreferences()
    }
}

struct UserPreferences: Codable {
    var theme: AppTheme = .system
    var notificationsEnabled: Bool = true
    var language: String = "en"
    
    enum AppTheme: String, CaseIterable, Codable {
        case light = "light"
        case dark = "dark"
        case system = "system"
        
        var displayName: String {
            switch self {
            case .light: return "Light"
            case .dark: return "Dark"
            case .system: return "System"
            }
        }
    }
}

// MARK: - Generic Repository Pattern

protocol Repository {
    associatedtype Entity
    func save(_ entity: Entity) async throws
    func fetch(by id: UUID) async throws -> Entity?
    func fetchAll() async throws -> [Entity]
    func delete(by id: UUID) async throws
}

final class UserRepository: Repository, ObservableObject, @unchecked Sendable {
    typealias Entity = User
    
    @Published var users: [User] = []
    private let queue = DispatchQueue(label: "user.repository", qos: .userInitiated)
    
    func save(_ user: User) async throws {
        await withCheckedContinuation { [weak self] continuation in
            self?.queue.async {
                if let index = self?.users.firstIndex(where: { $0.id == user.id }) {
                    self?.users[index] = user
                } else {
                    self?.users.append(user)
                }
                DispatchQueue.main.async {
                    self?.objectWillChange.send()
                    continuation.resume()
                }
            }
        }
    }
    
    func fetch(by id: UUID) async throws -> User? {
        return await withCheckedContinuation { [weak self] continuation in
            self?.queue.async {
                let user = self?.users.first { $0.id == id }
                continuation.resume(returning: user)
            }
        }
    }
    
    func fetchAll() async throws -> [User] {
        return await withCheckedContinuation { [weak self] continuation in
            self?.queue.async {
                continuation.resume(returning: self?.users ?? [])
            }
        }
    }
    
    func delete(by id: UUID) async throws {
        await withCheckedContinuation { [weak self] continuation in
            self?.queue.async {
                self?.users.removeAll { $0.id == id }
                DispatchQueue.main.async {
                    self?.objectWillChange.send()
                    continuation.resume()
                }
            }
        }
    }
}

// MARK: - Result and Error Handling

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(Int)
    case networkUnavailable
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL provided"
        case .noData:
            return "No data received from server"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .networkUnavailable:
            return "Network is unavailable"
        }
    }
}

// MARK: - Complex Generic Types

struct APIResponse<T: Codable>: Codable {
    let data: T
    let metadata: ResponseMetadata
    let success: Bool
    
    struct ResponseMetadata: Codable {
        let timestamp: Date
        let requestId: String
        let version: String
    }
}

// MARK: - Property Wrappers and Advanced Swift Features

@propertyWrapper
struct Clamped<Value: Comparable> {
    private var value: Value
    private let range: ClosedRange<Value>
    
    init(wrappedValue: Value, _ range: ClosedRange<Value>) {
        self.range = range
        self.value = max(range.lowerBound, min(range.upperBound, wrappedValue))
    }
    
    var wrappedValue: Value {
        get { value }
        set { value = max(range.lowerBound, min(range.upperBound, newValue)) }
    }
}

struct Settings {
    @Clamped(0...100) var volume: Int = 50
    @Clamped(0.1...5.0) var playbackSpeed: Double = 1.0
}
