import Foundation
import Combine

// MARK: - Network Service Protocol

protocol NetworkServiceProtocol {
    func fetch<T: Codable>(_ type: T.Type, from endpoint: APIEndpoint) async throws -> T
    func post<T: Codable, U: Codable>(_ data: T, to endpoint: APIEndpoint, expecting: U.Type) async throws -> U
}

// MARK: - API Endpoints

enum APIEndpoint {
    case users
    case user(id: UUID)
    case createUser
    case updateUser(id: UUID)
    case deleteUser(id: UUID)
    
    var path: String {
        switch self {
        case .users:
            return "/api/v1/users"
        case .user(let id):
            return "/api/v1/users/\(id.uuidString)"
        case .createUser:
            return "/api/v1/users"
        case .updateUser(let id):
            return "/api/v1/users/\(id.uuidString)"
        case .deleteUser(let id):
            return "/api/v1/users/\(id.uuidString)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .users, .user:
            return .GET
        case .createUser:
            return .POST
        case .updateUser:
            return .PUT
        case .deleteUser:
            return .DELETE
        }
    }
}

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

// MARK: - Network Service Implementation

class NetworkService: NetworkServiceProtocol, ObservableObject {
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    @Published var isLoading = false
    @Published var error: NetworkError?
    
    init(baseURL: String = "https://api.example.com") {
        guard let url = URL(string: baseURL) else {
            fatalError("Invalid base URL: \(baseURL)")
        }
        
        self.baseURL = url
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
        
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
        
        self.encoder = JSONEncoder()
        self.encoder.dateEncodingStrategy = .iso8601
    }
    
    func fetch<T: Codable>(_ type: T.Type, from endpoint: APIEndpoint) async throws -> T {
        let url = baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        await MainActor.run { self.isLoading = true }
        defer { Task { await MainActor.run { self.isLoading = false } } }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.serverError(0)
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            let decodedData = try decoder.decode(type, from: data)
            return decodedData
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        } catch let networkError as NetworkError {
            await MainActor.run { self.error = networkError }
            throw networkError
        } catch {
            let networkError = NetworkError.networkUnavailable
            await MainActor.run { self.error = networkError }
            throw networkError
        }
    }
    
    func post<T: Codable, U: Codable>(_ data: T, to endpoint: APIEndpoint, expecting: U.Type) async throws -> U {
        let url = baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try encoder.encode(data)
        } catch {
            throw NetworkError.decodingError(error)
        }
        
        await MainActor.run { self.isLoading = true }
        defer { Task { await MainActor.run { self.isLoading = false } } }
        
        do {
            let (responseData, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.serverError(0)
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            let decodedResponse = try decoder.decode(U.self, from: responseData)
            return decodedResponse
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        } catch let networkError as NetworkError {
            await MainActor.run { self.error = networkError }
            throw networkError
        } catch {
            let networkError = NetworkError.networkUnavailable
            await MainActor.run { self.error = networkError }
            throw networkError
        }
    }
}

// MARK: - User Service

@MainActor
class UserService: ObservableObject {
    @Published var users: [User] = []
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkService: NetworkServiceProtocol
    private let userRepository: UserRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(networkService: NetworkServiceProtocol = NetworkService(), 
         userRepository: UserRepository = UserRepository()) {
        self.networkService = networkService
        self.userRepository = userRepository
        
        // Observe repository changes
        self.userRepository.$users
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users in
                self?.users = users
            }
            .store(in: &cancellables)
    }
    
    func loadUsers() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await networkService.fetch(APIResponse<[User]>.self, from: .users)
            users = response.data
            
            // Also save to local repository
            for user in response.data {
                try await userRepository.save(user)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func createUser(name: String, email: String) async {
        isLoading = true
        errorMessage = nil
        
        let newUser = User(name: name, email: email)
        
        do {
            let response = try await networkService.post(newUser, to: .createUser, expecting: APIResponse<User>.self)
            try await userRepository.save(response.data)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func deleteUser(_ user: User) async {
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await networkService.fetch(APIResponse<Bool>.self, from: .deleteUser(id: user.id))
            try await userRepository.delete(by: user.id)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}