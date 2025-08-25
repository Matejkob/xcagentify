import SwiftUI

struct UserListView: View {
    @ObservedObject var userManager: DataManager<User>
    @Binding var searchText: String
    @State private var selectedUser: User?
    @State private var showingAddUser = false
    
    var filteredUsers: [User] {
        let users = userManager.findAll()
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { user in
                user.username.localizedCaseInsensitiveContains(searchText) ||
                user.email.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredUsers, id: \.id) { user in
                UserRowView(user: user)
                    .onTapGesture {
                        selectedUser = user
                    }
                    .swipeActions(edge: .trailing) {
                        Button("Delete", role: .destructive) {
                            try? userManager.delete(id: user.id)
                        }
                        
                        Button("Edit") {
                            selectedUser = user
                        }
                        .tint(.blue)
                    }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add") {
                    showingAddUser = true
                }
            }
        }
        .sheet(item: $selectedUser) { user in
            UserDetailView(user: user)
        }
        .sheet(isPresented: $showingAddUser) {
            AddUserView(userManager: userManager)
        }
        .refreshable {
            // Simulate refresh
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        }
    }
}

struct UserRowView: View {
    let user: User
    
    var body: some View {
        HStack {
            AsyncImage(url: user.profile?.avatar) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                    }
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.displayName)
                    .font(.headline)
                
                Text(user.email)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    RoleBadge(role: user.role)
                    Spacer()
                    Text(user.createdAt, style: .date)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct RoleBadge: View {
    let role: UserRole
    
    var color: Color {
        switch role {
        case .admin:
            return .red
        case .moderator:
            return .orange
        case .user:
            return .blue
        case .guest:
            return .gray
        }
    }
    
    var body: some View {
        Text(role.rawValue.capitalized)
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}

#Preview {
    NavigationStack {
        UserListView(
            userManager: {
                let manager = DataManager<User>()
                manager.save(User(username: "preview_user", email: "preview@example.com"))
                return manager
            }(),
            searchText: .constant("")
        )
    }
}
