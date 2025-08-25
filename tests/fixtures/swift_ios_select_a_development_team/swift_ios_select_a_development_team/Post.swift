import Foundation

// MARK: - Post Model

struct Post: Identifiable, Serializable {
    let id: UUID
    let authorId: UUID
    let title: String
    let content: String
    let tags: [String]
    let createdAt: Date
    let updatedAt: Date?
    let metadata: [String: String]
    
    init(authorId: UUID, title: String, content: String, tags: [String] = []) {
        self.id = UUID()
        self.authorId = authorId
        self.title = title
        self.content = content
        self.tags = tags
        self.createdAt = Date()
        self.updatedAt = nil
        self.metadata = [:]
    }
}
