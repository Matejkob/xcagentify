import Foundation

// MARK: - User Model

struct User: Identifiable, Displayable, Serializable {
    let id: UUID
    let username: String
    let email: String
    let role: UserRole
    let createdAt: Date
    let profile: UserProfile?
    
    var displayName: String {
        profile?.fullName ?? username
    }
    
    init(username: String, email: String, role: UserRole = .user) {
        self.id = UUID()
        self.username = username
        self.email = email
        self.role = role
        self.createdAt = Date()
        self.profile = nil
    }
}

// MARK: - User Profile

struct UserProfile: Codable {
    let firstName: String
    let lastName: String
    let avatar: URL?
    let bio: String?
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}
