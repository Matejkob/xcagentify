import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var userService = UserService()
    @StateObject private var themeManager = ThemeManager()
    @State private var selectedTab = 0
    @State private var showingUserSheet = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                UsersListView()
                    .tabItem {
                        Image(systemName: "person.3")
                        Text("Users")
                    }
                    .tag(0)
                
                SettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .tag(1)
                
                ChartsView()
                    .tabItem {
                        Image(systemName: "chart.bar")
                        Text("Analytics")
                    }
                    .tag(2)
            }
            .navigationTitle("Swift iOS Success")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingUserSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingUserSheet) {
                CreateUserView()
            }
        }
        .environmentObject(userService)
        .environmentObject(themeManager)
        .preferredColorScheme(themeManager.colorScheme)
    }
}

struct UsersListView: View {
    @EnvironmentObject var userService: UserService
    @State private var searchText = ""
    @State private var sortOrder = SortOrder.name
    @State private var showingDeleteAlert = false
    @State private var userToDelete: User?
    
    enum SortOrder: CaseIterable {
        case name, email, dateCreated
        
        var displayName: String {
            switch self {
            case .name: return "Name"
            case .email: return "Email"
            case .dateCreated: return "Date Created"
            }
        }
    }
    
    var filteredAndSortedUsers: [User] {
        let filtered = searchText.isEmpty ? userService.users : 
            userService.users.filter { user in
                user.name.localizedCaseInsensitiveContains(searchText) ||
                user.email.localizedCaseInsensitiveContains(searchText)
            }
        
        return filtered.sorted { user1, user2 in
            switch sortOrder {
            case .name:
                return user1.name < user2.name
            case .email:
                return user1.email < user2.email
            case .dateCreated:
                return user1.createdAt > user2.createdAt
            }
        }
    }
    
    var body: some View {
        VStack {
            if userService.isLoading {
                ProgressView("Loading users...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if userService.users.isEmpty {
                EmptyStateView()
            } else {
                List {
                    ForEach(filteredAndSortedUsers) { user in
                        UserRowView(user: user)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button("Delete", role: .destructive) {
                                    userToDelete = user
                                    showingDeleteAlert = true
                                }
                            }
                    }
                }
                .searchable(text: $searchText, prompt: "Search users...")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu("Sort") {
                            ForEach(SortOrder.allCases, id: \.self) { order in
                                Button(order.displayName) {
                                    sortOrder = order
                                }
                            }
                        }
                    }
                }
            }
        }
        .task {
            await userService.loadUsers()
        }
        .alert("Delete User", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let user = userToDelete {
                    Task {
                        await userService.deleteUser(user)
                    }
                }
            }
        } message: {
            Text("Are you sure you want to delete this user? This action cannot be undone.")
        }
        .overlay {
            if let errorMessage = userService.errorMessage {
                ErrorBannerView(message: errorMessage) {
                    Task {
                        await userService.loadUsers()
                    }
                }
            }
        }
    }
}

struct UserRowView: View {
    let user: User
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                AsyncImage(url: URL(string: "https://api.dicebear.com/7.x/avataaars/svg?seed=\(user.name)")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay {
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                        }
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(user.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(user.createdAt, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button(action: { withAnimation(.spring()) { isExpanded.toggle() } }) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    
                    HStack {
                        Label("Theme", systemImage: "paintbrush")
                        Spacer()
                        Text(user.preferences.theme.displayName)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Label("Notifications", systemImage: "bell")
                        Spacer()
                        Text(user.preferences.notificationsEnabled ? "Enabled" : "Disabled")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Label("Language", systemImage: "globe")
                        Spacer()
                        Text(user.preferences.language.uppercased())
                            .foregroundColor(.secondary)
                    }
                }
                .font(.caption)
                .padding(.leading, 48)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.vertical, 4)
        .animation(.spring(), value: isExpanded)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.3.sequence")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Users Yet")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Tap the + button to create your first user")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ErrorBannerView: View {
    let message: String
    let retry: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                
                Text(message)
                    .font(.subheadline)
                    .lineLimit(2)
                
                Spacer()
                
                Button("Retry", action: retry)
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 2)
            
            Spacer()
        }
        .padding()
    }
}

struct CreateUserView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userService: UserService
    
    @State private var name = ""
    @State private var email = ""
    @State private var isCreating = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    private var isValidForm: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        email.contains("@") && email.contains(".")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("User Information") {
                    TextField("Full Name", text: $name)
                        .textContentType(.name)
                    
                    TextField("Email Address", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section {
                    Button("Create User") {
                        Task {
                            await createUser()
                        }
                    }
                    .disabled(!isValidForm || isCreating)
                }
            }
            .navigationTitle("New User")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .overlay {
                if isCreating {
                    ProgressView("Creating user...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.3))
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func createUser() async {
        isCreating = true
        
        await userService.createUser(name: name.trimmingCharacters(in: .whitespacesAndNewlines), 
                                   email: email.trimmingCharacters(in: .whitespacesAndNewlines))
        
        if let error = userService.errorMessage {
            errorMessage = error
            showingError = true
        } else {
            dismiss()
        }
        
        isCreating = false
    }
}

#Preview {
    ContentView()
}