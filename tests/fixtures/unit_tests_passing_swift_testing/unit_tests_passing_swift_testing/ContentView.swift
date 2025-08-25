//
//  ContentView.swift
//  unit_tests_passing_swift_testing
//
//  Created by Mateusz Bąk on 8/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private var calculator = Calculator()
    @State private var userManager = UserManager()
    @State private var result: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "function")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Test App")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Calculator Result: \(result)")
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            Button("Calculate 10 + 5") {
                result = String(calculator.add(10, 5))
            }
            .buttonStyle(.bordered)
            
            Text("Users: \(userManager.getUserCount())")
            
            Button("Add Test User") {
                let user = User(name: "Test User", email: "test@example.com", age: 25)
                try? userManager.addUser(user)
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
