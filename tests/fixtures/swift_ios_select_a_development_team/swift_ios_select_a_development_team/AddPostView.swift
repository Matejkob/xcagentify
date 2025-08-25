import SwiftUI

struct AddPostView: View {
    @ObservedObject var postManager: DataManager<Post>
    @ObservedObject var userManager: DataManager<User>
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var content = ""
    @State private var tagInput = ""
    @State private var tags: [String] = []
    @State private var selectedAuthor: User?
    
    var availableAuthors: [User] {
        userManager.findAll()
    }
    
    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        selectedAuthor != nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Post Details") {
                    TextField("Title", text: $title)
                    
                    TextField("Content", text: $content, axis: .vertical)
                        .lineLimit(5...10)
                }
                
                Section("Author") {
                    Group {
                        if availableAuthors.isEmpty {
                            Text("No users available")
                                .foregroundColor(.secondary)
                        } else {
                            Picker("Select Author", selection: $selectedAuthor) {
                                Text("Select Author")
                                    .tag(nil as User?)
                                ForEach(availableAuthors, id: \.id) { user in
                                    HStack {
                                        Text(user.displayName)
                                        Spacer()
                                        RoleBadge(role: user.role)
                                    }
                                    .tag(user as User?)
                                }
                            }
                        }
                    }
                }
                
                Section("Tags") {
                    HStack {
                        TextField("Add tag", text: $tagInput)
                            .onSubmit {
                                addTag()
                            }
                        
                        Button("Add") {
                            addTag()
                        }
                        .disabled(tagInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    
                    if !tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(tags, id: \.self) { tag in
                                    HStack(spacing: 4) {
                                        TagView(tag: tag)
                                        Button {
                                            removeTag(tag)
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 1)
                        }
                    }
                }
                
                Section("Preview") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(title.isEmpty ? "Post Title" : title)
                            .font(.headline)
                            .foregroundColor(title.isEmpty ? .secondary : .primary)
                        
                        Text(content.isEmpty ? "Post content will appear here..." : content)
                            .font(.body)
                            .foregroundColor(content.isEmpty ? .secondary : .primary)
                        
                        if !tags.isEmpty {
                            HStack {
                                ForEach(tags.prefix(3), id: \.self) { tag in
                                    TagView(tag: tag)
                                }
                                if tags.count > 3 {
                                    Text("+\(tags.count - 3) more")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        createPost()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private func addTag() {
        let trimmedTag = tagInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !trimmedTag.isEmpty && !tags.contains(trimmedTag) {
            tags.append(trimmedTag)
            tagInput = ""
        }
    }
    
    private func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }
    
    private func createPost() {
        guard let author = selectedAuthor else { return }
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let newPost = Post(
            authorId: author.id,
            title: trimmedTitle,
            content: trimmedContent,
            tags: tags
        )
        
        postManager.save(newPost)
        dismiss()
    }
}

#Preview {
    AddPostView(
        postManager: DataManager<Post>(),
        userManager: {
            let manager = DataManager<User>()
            manager.save(User(username: "preview", email: "preview@example.com"))
            return manager
        }()
    )
}
