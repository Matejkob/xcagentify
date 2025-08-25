import SwiftUI

class ThemeManager: ObservableObject {
    @Published var currentTheme: UserPreferences.AppTheme = .system {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "app_theme")
        }
    }
    
    @Published var notificationsEnabled = true {
        didSet {
            UserDefaults.standard.set(notificationsEnabled, forKey: "notifications_enabled")
        }
    }
    
    var colorScheme: ColorScheme? {
        switch currentTheme {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
    
    init() {
        if let themeString = UserDefaults.standard.object(forKey: "app_theme") as? String,
           let theme = UserPreferences.AppTheme(rawValue: themeString) {
            self.currentTheme = theme
        }
        
        self.notificationsEnabled = UserDefaults.standard.object(forKey: "notifications_enabled") as? Bool ?? true
    }
}

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var settings = Settings()
    @State private var showingResetAlert = false
    @State private var showingAbout = false
    @State private var hapticFeedback = true
    @State private var analyticsEnabled = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Appearance") {
                    Picker("Theme", selection: $themeManager.currentTheme) {
                        ForEach(UserPreferences.AppTheme.allCases, id: \.self) { theme in
                            Text(theme.displayName).tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Audio") {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Volume")
                            Spacer()
                            Text("\(settings.volume)%")
                                .foregroundColor(.secondary)
                        }
                        
                        Slider(value: Binding(
                            get: { Double(settings.volume) },
                            set: { settings.volume = Int($0) }
                        ), in: 0...100, step: 1) {
                            Text("Volume")
                        } minimumValueLabel: {
                            Image(systemName: "speaker.fill")
                                .foregroundColor(.secondary)
                        } maximumValueLabel: {
                            Image(systemName: "speaker.wave.3.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Playback Speed")
                            Spacer()
                            Text(String(format: "%.1fx", settings.playbackSpeed))
                                .foregroundColor(.secondary)
                        }
                        
                        Slider(value: $settings.playbackSpeed, in: 0.1...5.0, step: 0.1) {
                            Text("Playback Speed")
                        } minimumValueLabel: {
                            Text("0.1x")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } maximumValueLabel: {
                            Text("5.0x")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section("Notifications") {
                    Toggle("Enable Notifications", isOn: $themeManager.notificationsEnabled)
                    
                    if themeManager.notificationsEnabled {
                        NavigationLink("Notification Settings") {
                            NotificationSettingsView()
                        }
                    }
                }
                
                Section("Experience") {
                    Toggle("Haptic Feedback", isOn: $hapticFeedback)
                    Toggle("Analytics", isOn: $analyticsEnabled)
                }
                
                Section("Data") {
                    Button("Export Data") {
                        exportUserData()
                    }
                    
                    Button("Reset All Settings", role: .destructive) {
                        showingResetAlert = true
                    }
                }
                
                Section("About") {
                    NavigationLink("App Information") {
                        AboutView()
                    }
                    
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Build")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Reset Settings", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    resetSettings()
                }
            } message: {
                Text("This will reset all settings to their default values. This action cannot be undone.")
            }
        }
    }
    
    private func exportUserData() {
        // Simulate data export
        let hapticImpact = UIImpactFeedbackGenerator(style: .medium)
        hapticImpact.impactOccurred()
    }
    
    private func resetSettings() {
        settings = Settings()
        themeManager.currentTheme = .system
        themeManager.notificationsEnabled = true
        hapticFeedback = true
        analyticsEnabled = false
        
        let hapticNotification = UINotificationFeedbackGenerator()
        hapticNotification.notificationOccurred(.success)
    }
}

struct NotificationSettingsView: View {
    @State private var pushNotifications = true
    @State private var emailNotifications = false
    @State private var weeklyDigest = true
    @State private var breakingNews = false
    @State private var quietHoursEnabled = false
    @State private var quietHoursStart = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var quietHoursEnd = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date()) ?? Date()
    
    var body: some View {
        Form {
            Section("Notification Types") {
                Toggle("Push Notifications", isOn: $pushNotifications)
                Toggle("Email Notifications", isOn: $emailNotifications)
                Toggle("Weekly Digest", isOn: $weeklyDigest)
                Toggle("Breaking News", isOn: $breakingNews)
            }
            
            Section("Quiet Hours") {
                Toggle("Enable Quiet Hours", isOn: $quietHoursEnabled)
                
                if quietHoursEnabled {
                    DatePicker("Start Time", selection: $quietHoursStart, displayedComponents: .hourAndMinute)
                    DatePicker("End Time", selection: $quietHoursEnd, displayedComponents: .hourAndMinute)
                }
            }
            
            Section {
                Button("Open System Settings") {
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsUrl)
                    }
                }
            } footer: {
                Text("Open iOS Settings to manage app-level notification permissions.")
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    @State private var showingLicenses = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(spacing: 16) {
                    Image(systemName: "app.badge")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Swift iOS Success")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("A demonstration app showcasing advanced Swift and SwiftUI features for testing xcagentify parsing capabilities.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                
                VStack(alignment: .leading, spacing: 16) {
                    FeatureRow(icon: "swift", title: "Swift 5.9", description: "Built with the latest Swift features")
                    FeatureRow(icon: "iphone", title: "iOS 17+", description: "Optimized for modern iOS devices")
                    FeatureRow(icon: "network", title: "Async/Await", description: "Modern concurrency patterns")
                    FeatureRow(icon: "gear.badge", title: "SwiftUI", description: "Declarative user interface")
                    FeatureRow(icon: "lock.shield", title: "Privacy First", description: "Your data stays on your device")
                }
                .padding(.horizontal)
                
                VStack(spacing: 12) {
                    Button("View Source Code") {
                        if let url = URL(string: "https://github.com/example/swift-ios-success") {
                            UIApplication.shared.open(url)
                        }
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Third-Party Licenses") {
                        showingLicenses = true
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Report an Issue") {
                        if let url = URL(string: "https://github.com/example/swift-ios-success/issues") {
                            UIApplication.shared.open(url)
                        }
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingLicenses) {
            LicensesView()
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct LicensesView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let licenses = [
        License(name: "SwiftUI", author: "Apple Inc.", description: "Apple's declarative UI framework"),
        License(name: "Foundation", author: "Apple Inc.", description: "Core system frameworks"),
        License(name: "Combine", author: "Apple Inc.", description: "Reactive programming framework")
    ]
    
    var body: some View {
        NavigationView {
            List(licenses) { license in
                VStack(alignment: .leading, spacing: 8) {
                    Text(license.name)
                        .font(.headline)
                    
                    Text("by \(license.author)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(license.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Licenses")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct License: Identifiable {
    let id = UUID()
    let name: String
    let author: String
    let description: String
}

#Preview {
    SettingsView()
        .environmentObject(ThemeManager())
}