import Foundation

// MARK: - Core Protocols

protocol Identifiable {
    var id: UUID { get }
}

protocol Displayable {
    var displayName: String { get }
}

protocol Serializable: Codable {
    func toJSON() throws -> Data
    static func fromJSON<T: Serializable>(_ data: Data, type: T.Type) throws -> T
}

// MARK: - Generic Repository Protocol

protocol Repository<Item> {
    associatedtype Item
    func save(_ item: Item) async throws
    func fetch(id: UUID) async throws -> Item?
    func fetchAll() async throws -> [Item]
}

// MARK: - Protocol Extensions

extension Serializable {
    func toJSON() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
    static func fromJSON<T: Serializable>(_ data: Data, type: T.Type) throws -> T {
        try JSONDecoder().decode(type, from: data)
    }
}
