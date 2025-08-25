import Foundation

// MARK: - Generic Collections

struct PaginatedResponse<T: Codable>: Codable {
    let items: [T]
    let totalCount: Int
    let pageSize: Int
    let currentPage: Int
    
    var hasNextPage: Bool {
        (currentPage * pageSize) < totalCount
    }
}

// MARK: - Generic Data Manager

class DataManager<T: Identifiable & Serializable>: ObservableObject {
    private var items: [UUID: T] = [:]
    
    func save(_ item: T) {
        items[item.id] = item
    }
    
    func find(by id: UUID) -> T? {
        items[id]
    }
    
    func findAll(where predicate: (T) -> Bool = { _ in true }) -> [T] {
        Array(items.values.filter(predicate))
    }
    
    func update(_ item: T) throws {
        guard items[item.id] != nil else {
            throw DataError.itemNotFound
        }
        items[item.id] = item
    }
    
    func delete(id: UUID) throws {
        guard items[id] != nil else {
            throw DataError.itemNotFound
        }
        items.removeValue(forKey: id)
    }
}
