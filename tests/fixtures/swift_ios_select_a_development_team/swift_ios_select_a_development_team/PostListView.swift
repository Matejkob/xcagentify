import SwiftUI

struct PostListView: View {
    @ObservedObject var postManager: DataManager<Post>
    @ObservedObject var userManager: DataManager<User>
    @State private var isLoading = false
    @State private var showingAddPost = false
    
    var posts: [Post] {
        postManager.findAll().sorted { $0.createdAt > $1.createdAt }
    }
    
    var body: some View {
        Group {
            if posts.isEmpty {
                ContentUnavailableView(
                    "No Posts Yet",
                    systemImage: "doc.text",
                    description: Text("Start by creating your first post!")
                )
            } else {
                List {
                    ForEach(posts, id: \.id) { post in
                        PostRowView(post: post, author: userManager.find(by: post.authorId))
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                }
                .listStyle(.plain)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add") {
                    showingAddPost = true
                }
            }
        }
        .sheet(isPresented: $showingAddPost) {
            AddPostView(postManager: postManager, userManager: userManager)
        }
        .refreshable {
            await loadPosts()
        }
    }
    
    @MainActor
    private func loadPosts() async {
        isLoading = true
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        isLoading = false
    }
}

struct PostRowView: View {
    let post: Post
    let author: User?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Circle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 32, height: 32)
                    .overlay {
                        Text(author?.username.prefix(1).uppercased() ?? "?")
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(author?.displayName ?? "Unknown User")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(post.createdAt.formatted(.relative(presentation: .named)))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if let author = author {
                    RoleBadge(role: author.role)
                }
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(post.title)
                    .font(.headline)
                
                Text(post.content)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            // Tags
            if !post.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(post.tags, id: \.self) { tag in
                            TagView(tag: tag)
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2, y: 1)
    }
}

struct TagView: View {
    let tag: String
    
    var body: some View {
        Text("#\(tag)")
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.blue)
            .clipShape(Capsule())
    }
}

#Preview {
    NavigationStack {
        PostListView(
            postManager: {
                let manager = DataManager<Post>()
                let samplePost = Post(
                    authorId: UUID(),
                    title: "Sample Post",
                    content: "This is a sample post for preview purposes.",
                    tags: ["sample", "preview"]
                )
                manager.save(samplePost)
                return manager
            }(),
            userManager: DataManager<User>()
        )
    }
}
