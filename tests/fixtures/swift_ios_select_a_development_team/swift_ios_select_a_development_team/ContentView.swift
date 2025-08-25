import SwiftUI

struct ContentView: View {
    @StateObject private var userManager = DataManager<User>()
    @StateObject private var postManager = DataManager<Post>()
    @State private var selectedTab = 0
    @State private var showingUserDetail = false
    @State private var searchText = ""
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                UserListView(userManager: userManager, searchText: $searchText)
                    .navigationTitle("Users")
                    .searchable(text: $searchText)
            }
            .tabItem {
                Label("Users", systemImage: "person.3")
            }
            .tag(0)
            
            NavigationStack {
                PostListView(postManager: postManager, userManager: userManager)
                    .navigationTitle("Posts")
            }
            .tabItem {
                Label("Posts", systemImage: "doc.text")
            }
            .tag(1)
            
            NavigationStack {
                SettingsView()
                    .navigationTitle("Settings")
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(2)
        }
        .onAppear {
            setupSampleData()
        }
    }
    
    private func setupSampleData() {
        let sampleUsers = [
            User(username: "john_doe", email: "john@example.com", role: .admin),
            User(username: "jane_smith", email: "jane@example.com", role: .moderator),
            User(username: "bob_wilson", email: "bob@example.com", role: .user)
        ]
        
        sampleUsers.forEach { userManager.save($0) }
        
        let users = userManager.findAll()
        if let firstUser = users.first {
            let samplePosts = [
                Post(authorId: firstUser.id, title: "Welcome to SwiftUI", content: "This is my first post about SwiftUI!", tags: ["swiftui", "ios"]),
                Post(authorId: firstUser.id, title: "Advanced Swift Patterns", content: "Let's explore some advanced Swift programming patterns.", tags: ["swift", "programming"])
            ]
            samplePosts.forEach { postManager.save($0) }
        }
    }
}

#Preview {
    ContentView()
}
