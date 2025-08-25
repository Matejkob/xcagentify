import SwiftUI

struct AddUserView: View {
    @ObservedObject var userManager: DataManager<User>
    @Environment(\.dismiss) private var dismiss
    
    @State private var username = ""
    @State private var email = ""
    @State private var selectedRole = UserRole.user
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var isFormValid: Bool {
        !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        email.contains("@")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("User Information") {
                    TextField("Username", text: $username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                }
                
                Section("Role") {
                    Picker("Select Role", selection: $selectedRole) {
                        ForEach(UserRole.allCases, id: \.self) { role in
                            HStack {
                                Text(role.rawValue.capitalized)
                                Spacer()
                                RoleBadge(role: role)
                            }
                            .tag(role)
                        }
                    }
                    .pickerStyle(.automatic)
                }
                
                Section("Permissions Preview") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(Array(selectedRole.permissions), id: \.self) { permission in
                            PermissionBadge(permission: permission)
                        }
                    }
                }
            }
            .navigationTitle("Add User")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveUser()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func saveUser() {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if username already exists
        let existingUsers = userManager.findAll()
        if existingUsers.contains(where: { $0.username.lowercased() == trimmedUsername.lowercased() }) {
            alertMessage = "Username '\(trimmedUsername)' already exists"
            showingAlert = true
            return
        }
        
        // Check if email already exists
        if existingUsers.contains(where: { $0.email.lowercased() == trimmedEmail.lowercased() }) {
            alertMessage = "Email '\(trimmedEmail)' already exists"
            showingAlert = true
            return
        }
        
        let newUser = User(username: trimmedUsername, email: trimmedEmail, role: selectedRole)
        userManager.save(newUser)
        dismiss()
    }
}

#Preview {
    AddUserView(userManager: DataManager<User>())
}
