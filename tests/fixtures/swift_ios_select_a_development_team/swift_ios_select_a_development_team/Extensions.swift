import Foundation
import SwiftUI

// MARK: - Collection Extensions

extension Collection {
    var isNotEmpty: Bool {
        !isEmpty
    }
    
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
    
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
}

// MARK: - String Extensions

extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }
    
    var initials: String {
        return self.components(separatedBy: .whitespaces)
            .compactMap { $0.first }
            .map { String($0).uppercased() }
            .joined()
    }
    
    func truncated(to length: Int, trailing: String = "...") -> String {
        return count > length ? prefix(length) + trailing : self
    }
    
    func highlighted(searchTerm: String) -> AttributedString {
        var attributedString = AttributedString(self)
        
        if let range = self.range(of: searchTerm, options: .caseInsensitive) {
            let attributedRange = AttributedString.Index(range.lowerBound, within: attributedString)!..<AttributedString.Index(range.upperBound, within: attributedString)!
            attributedString[attributedRange].backgroundColor = .yellow
            attributedString[attributedRange].foregroundColor = .black
        }
        
        return attributedString
    }
}

// MARK: - Date Extensions

extension Date {
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    func formatted(_ style: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.string(from: self)
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? self
    }
}

// MARK: - URL Extensions

extension URL {
    func appendingQueryItems(_ items: [URLQueryItem]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.queryItems = (components?.queryItems ?? []) + items
        return components?.url ?? self
    }
}

// MARK: - Color Extensions

extension Color {
    static let customBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    static let customGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    static let customOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    var hexString: String {
        guard let components = cgColor?.components else { return "#000000" }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        
        return String(format: "#%02lX%02lX%02lX",
                     lroundf(r * 255),
                     lroundf(g * 255),
                     lroundf(b * 255))
    }
}

// MARK: - View Extensions

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    func conditionalModifier<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        Group {
            if condition {
                transform(self)
            } else {
                self
            }
        }
    }
    
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Custom Shapes

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Generic Result Extension

extension Result {
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    var isFailure: Bool {
        !isSuccess
    }
    
    var value: Success? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    var error: Failure? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

// MARK: - Optional Extensions

extension Optional {
    var isNil: Bool {
        self == nil
    }
    
    var isNotNil: Bool {
        self != nil
    }
}

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        self?.isEmpty ?? true
    }
    
    var isNotNilAndNotEmpty: Bool {
        self?.isEmpty == false
    }
}

// MARK: - Codable Extensions

extension KeyedDecodingContainer {
    func decodeIfPresent<T: Decodable>(_ type: T.Type, forKey key: Key) -> T? {
        return try? decodeIfPresent(type, forKey: key)
    }
    
    func decode<T: Decodable>(_ type: T.Type, forKey key: Key, default defaultValue: T) -> T {
        return (try? decode(type, forKey: key)) ?? defaultValue
    }
}

// MARK: - UserDefaults Extensions

extension UserDefaults {
    func set<T: Codable>(_ object: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(object) {
            set(data, forKey: key)
        }
    }
    
    func get<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}

// MARK: - Bundle Extensions

extension Bundle {
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    var buildNumber: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
    
    var appName: String {
        infoDictionary?["CFBundleDisplayName"] as? String ?? 
        infoDictionary?["CFBundleName"] as? String ?? "Unknown"
    }
}
