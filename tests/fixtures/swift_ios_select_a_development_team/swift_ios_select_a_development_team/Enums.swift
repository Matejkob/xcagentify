import Foundation

// MARK: - User Role Enum

enum UserRole: String, CaseIterable, Codable {
    case admin = "admin"
    case moderator = "moderator"
    case user = "user"
    case guest = "guest"
    
    var permissions: Set<Permission> {
        switch self {
        case .admin:
            return [.read, .write, .delete, .manage]
        case .moderator:
            return [.read, .write, .delete]
        case .user:
            return [.read, .write]
        case .guest:
            return [.read]
        }
    }
}

enum Permission: String, CaseIterable {
    case read, write, delete, manage
}

// MARK: - Error Types

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingFailed(Error)
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL provided"
        case .noData:
            return "No data received from server"
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error with code: \(code)"
        }
    }
}

enum DataError: Error {
    case itemNotFound
    case invalidData
}
