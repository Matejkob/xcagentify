import Foundation

// MARK: - HTTP Methods

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

// MARK: - Network Request

struct NetworkRequest {
    let url: URL
    let method: HTTPMethod
    let headers: [String: String]
    let body: Data?
    
    init(url: URL, method: HTTPMethod = .GET, headers: [String: String] = [:], body: Data? = nil) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
    }
}

// MARK: - API Response

struct APIResponse<T: Codable>: Codable {
    let data: T?
    let message: String?
    let status: Int
    let timestamp: Date
    
    var isSuccess: Bool {
        (200...299).contains(status)
    }
}

// MARK: - Network Service Protocol

protocol NetworkServiceProtocol {
    func request<T: Codable>(_ request: NetworkRequest, responseType: T.Type) async throws -> T
    func upload<T: Codable>(data: Data, to url: URL, responseType: T.Type) async throws -> T
    func download(from url: URL) async throws -> Data
}

// MARK: - Network Service Implementation

@MainActor
class NetworkService: NetworkServiceProtocol, ObservableObject {
    static let shared = NetworkService()
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    @Published var isLoading = false
    @Published var lastError: NetworkError?
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
        
        // Configure date formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
    }
    
    func request<T: Codable>(_ request: NetworkRequest, responseType: T.Type) async throws -> T {
        isLoading = true
        defer { isLoading = false }
        
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        
        // Add headers
        for (key, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add default headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.serverError(0)
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
            let decodedResponse = try decoder.decode(responseType, from: data)
            return decodedResponse
            
        } catch let decodingError as DecodingError {
            lastError = .decodingFailed(decodingError)
            throw NetworkError.decodingFailed(decodingError)
        } catch let networkError as NetworkError {
            lastError = networkError
            throw networkError
        } catch {
            lastError = .serverError(500)
            throw NetworkError.serverError(500)
        }
    }
    
    func upload<T: Codable>(data: Data, to url: URL, responseType: T.Type) async throws -> T {
        let request = NetworkRequest(url: url, method: .POST, body: data)
        return try await self.request(request, responseType: responseType)
    }
    
    func download(from url: URL) async throws -> Data {
        isLoading = true
        defer { isLoading = false }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(0)
        }
        
        return data
    }
}

// MARK: - API Client

class APIClient: ObservableObject {
    private let networkService: NetworkServiceProtocol
    private let baseURL: URL
    
    @Published var users: [User] = []
    @Published var posts: [Post] = []
    @Published var isLoading = false
    
    init(baseURL: String = "https://api.example.com", networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.baseURL = URL(string: baseURL)!
        self.networkService = networkService
    }
    
    // MARK: - User Operations
    
    func fetchUsers() async throws -> [User] {
        let url = baseURL.appendingPathComponent("users")
        let request = NetworkRequest(url: url)
        let response: APIResponse<[User]> = try await networkService.request(request, responseType: APIResponse<[User]>.self)
        
        guard let users = response.data else {
            throw NetworkError.noData
        }
        
        await MainActor.run {
            self.users = users
        }
        
        return users
    }
    
    func createUser(_ user: User) async throws -> User {
        let url = baseURL.appendingPathComponent("users")
        let userData = try JSONEncoder().encode(user)
        let request = NetworkRequest(url: url, method: .POST, body: userData)
        
        let response: APIResponse<User> = try await networkService.request(request, responseType: APIResponse<User>.self)
        
        guard let createdUser = response.data else {
            throw NetworkError.noData
        }
        
        return createdUser
    }
    
    // MARK: - Post Operations
    
    func fetchPosts(page: Int = 1, limit: Int = 20) async throws -> PaginatedResponse<Post> {
        var components = URLComponents(url: baseURL.appendingPathComponent("posts"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        let request = NetworkRequest(url: url)
        return try await networkService.request(request, responseType: PaginatedResponse<Post>.self)
    }
    
    func createPost(_ post: Post) async throws -> Post {
        let url = baseURL.appendingPathComponent("posts")
        let postData = try JSONEncoder().encode(post)
        let request = NetworkRequest(url: url, method: .POST, body: postData)
        
        let response: APIResponse<Post> = try await networkService.request(request, responseType: APIResponse<Post>.self)
        
        guard let createdPost = response.data else {
            throw NetworkError.noData
        }
        
        return createdPost
    }
}

// MARK: - Mock Network Service for Testing

class MockNetworkService: NetworkServiceProtocol {
    var shouldFail = false
    var mockDelay: TimeInterval = 0.5
    
    func request<T: Codable>(_ request: NetworkRequest, responseType: T.Type) async throws -> T {
        if shouldFail {
            throw NetworkError.serverError(500)
        }
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: UInt64(mockDelay * 1_000_000_000))
        
        // Return mock data based on type
        if T.self == APIResponse<[User]>.self {
            let mockUsers = [
                User(username: "mock_user", email: "mock@example.com", role: .user)
            ]
            let response = APIResponse(data: mockUsers, message: "Success", status: 200, timestamp: Date())
            return response as! T
        }
        
        throw NetworkError.noData
    }
    
    func upload<T: Codable>(data: Data, to url: URL, responseType: T.Type) async throws -> T {
        return try await request(NetworkRequest(url: url, method: .POST, body: data), responseType: responseType)
    }
    
    func download(from url: URL) async throws -> Data {
        if shouldFail {
            throw NetworkError.serverError(500)
        }
        
        try await Task.sleep(nanoseconds: UInt64(mockDelay * 1_000_000_000))
        return Data("Mock file content".utf8)
    }
}
