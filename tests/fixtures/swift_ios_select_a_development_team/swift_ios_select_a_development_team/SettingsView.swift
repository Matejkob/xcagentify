import SwiftUI

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("autoRefresh") private var autoRefresh = true
    @AppStorage("refreshInterval") private var refreshInterval = 30.0
    
    @State private var showingAbout = false
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        List {
            Section("Preferences") {
                HStack {
                    Image(systemName: "bell")
                        .foregroundColor(.blue)
                        .frame(width: 20)
                    Toggle("Notifications", isOn: $notificationsEnabled)
                }
                
                HStack {
                    Image(systemName: "moon")
                        .foregroundColor(.purple)
                        .frame(width: 20)
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                }
                
                HStack {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.green)
                        .frame(width: 20)
                    Toggle("Auto Refresh", isOn: $autoRefresh)
                }
                
                if autoRefresh {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.orange)
                                .frame(width: 20)
                            Text("Refresh Interval")
                            Spacer()
                            Text("\(Int(refreshInterval))s")
                                .foregroundColor(.secondary)
                        }
                        
                        Slider(value: $refreshInterval, in: 10...300, step: 10) {
                            Text("Refresh Interval")
                        } minimumValueLabel: {
                            Text("10s")
                                .font(.caption)
                        } maximumValueLabel: {
                            Text("5m")
                                .font(.caption)
                        }
                    }
                }
            }
            
            Section("Account") {
                Button {
                    // Logout action
                } label: {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.blue)
                            .frame(width: 20)
                        Text("Sign Out")
                            .foregroundColor(.blue)
                    }
                }
                
                Button {
                    showingDeleteConfirmation = true
                } label: {
                    HStack {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .frame(width: 20)
                        Text("Delete Account")
                            .foregroundColor(.red)
                    }
                }
            }
            
            Section("About") {
                Button {
                    showingAbout = true
                } label: {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                            .frame(width: 20)
                        Text("About")
                            .foregroundColor(.blue)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    Image(systemName: "doc.text")
                        .foregroundColor(.gray)
                        .frame(width: 20)
                    Text("Privacy Policy")
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(.gray)
                        .frame(width: 20)
                    Text("Support")
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Section("Debug") {
                DisclosureGroup("Debug Information") {
                    VStack(alignment: .leading, spacing: 8) {
                        DebugInfoRow(label: "App Version", value: "1.0.0")
                        DebugInfoRow(label: "Build Number", value: "42")
                        DebugInfoRow(label: "iOS Version", value: UIDevice.current.systemVersion)
                        DebugInfoRow(label: "Device Model", value: UIDevice.current.model)
                        DebugInfoRow(label: "Notifications", value: notificationsEnabled ? "Enabled" : "Disabled")
                        DebugInfoRow(label: "Auto Refresh", value: autoRefresh ? "Enabled (\(Int(refreshInterval))s)" : "Disabled")
                    }
                    .font(.caption)
                    .monospaced()
                }
            }
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
        .confirmationDialog("Delete Account", isPresented: $showingDeleteConfirmation) {
            Button("Delete Account", role: .destructive) {
                // Delete account action
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone. All your data will be permanently deleted.")
        }
    }
}

struct DebugInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label + ":")
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // App Icon
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 80, height: 80)
                        .overlay {
                            Image(systemName: "swift")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                    
                    VStack(spacing: 8) {
                        Text("Swift iOS Success")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Version 1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("A demonstration app showcasing advanced Swift and SwiftUI patterns for comprehensive build testing.")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        FeatureRow(icon: "person.3", title: "User Management", description: "Advanced user roles and permissions")
                        FeatureRow(icon: "doc.text", title: "Post System", description: "Rich content creation and management")
                        FeatureRow(icon: "network", title: "Networking", description: "Async/await API integration")
                        FeatureRow(icon: "gear", title: "Settings", description: "Comprehensive preferences")
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Text("Built with ❤️ for testing xcagentify")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top)
                }
                .padding()
            }
            .navigationTitle("About")
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

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
