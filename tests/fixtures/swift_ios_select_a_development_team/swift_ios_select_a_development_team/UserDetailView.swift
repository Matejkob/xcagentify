import SwiftUI

struct UserDetailView: View {
    let user: User
    @Environment(\.dismiss) private var dismiss
    @State private var showingPermissions = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    VStack(spacing: 16) {
                        AsyncImage(url: user.profile?.avatar) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                }
                        }
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        
                        VStack(spacing: 8) {
                            Text(user.displayName)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(user.email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            RoleBadge(role: user.role)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 2)
                    
                    // Information Cards
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        InfoCard(title: "Created", value: user.createdAt.formatted(date: .abbreviated, time: .omitted))
                        InfoCard(title: "User ID", value: String(user.id.uuidString.prefix(8)))
                    }
                    
                    // Permissions Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Permissions")
                                .font(.headline)
                            Spacer()
                            Button("View All") {
                                showingPermissions = true
                            }
                            .font(.caption)
                        }
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                            ForEach(Array(user.role.permissions), id: \.self) { permission in
                                PermissionBadge(permission: permission)
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 2)
                    
                    if let profile = user.profile, let bio = profile.bio {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bio")
                                .font(.headline)
                            
                            Text(bio)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(UIColor.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 2)
                    }
                }
                .padding()
            }
            .navigationTitle("User Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingPermissions) {
            PermissionsView(permissions: user.role.permissions)
        }
    }
}

struct InfoCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 1)
    }
}

struct PermissionBadge: View {
    let permission: Permission
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: iconName)
                .font(.caption2)
            Text(permission.rawValue.capitalized)
                .font(.caption)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.blue.opacity(0.1))
        .foregroundColor(.blue)
        .clipShape(Capsule())
    }
    
    private var iconName: String {
        switch permission {
        case .read:
            return "eye"
        case .write:
            return "pencil"
        case .delete:
            return "trash"
        case .manage:
            return "gear"
        }
    }
}

struct PermissionsView: View {
    let permissions: Set<Permission>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(permissions), id: \.self) { permission in
                    HStack {
                        PermissionBadge(permission: permission)
                        Spacer()
                        Text(permissionDescription(permission))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("All Permissions")
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
    
    private func permissionDescription(_ permission: Permission) -> String {
        switch permission {
        case .read:
            return "Can view content"
        case .write:
            return "Can create and edit"
        case .delete:
            return "Can remove content"
        case .manage:
            return "Can manage users and settings"
        }
    }
}

#Preview {
    UserDetailView(user: User(username: "preview_user", email: "preview@example.com", role: .admin))
}
