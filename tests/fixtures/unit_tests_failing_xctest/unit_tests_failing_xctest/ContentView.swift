//
//  ContentView.swift
//  unit_tests_failing_xctest
//
//  Created by Mateusz Bąk on 8/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private var calculator = Calculator()
    @State private var userManager = UserManager()
    @State private var result: String = "0"
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Calculator & User Manager Demo")
                .font(.title2)
                .padding()
            
            Text("Result: \(result)")
                .font(.headline)
            
            HStack {
                Button("Add 5+3") {
                    result = String(calculator.add(5, 3))
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button("Test Users") {
                    testUsers()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
    }
    
    private func testUsers() {
        let user = User(name: "John Doe", email: "john@example.com", age: 30)
        do {
            try userManager.addUser(user)
            result = "Users: \(userManager.getUserCount())"
        } catch {
            result = "Error: \(error)"
        }
    }
}

#Preview {
    ContentView()
}
