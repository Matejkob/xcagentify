//
//  ContentView.swift
//  swift_ios_compile_errors
//
//  Created by Mateusz Bąk on 8/18/25.
//

// Missing import SwiftUI - will cause "Use of undeclared type 'View'" error

struct ContentView: View {
    // Error 1: Undefined variable
    @State private var userName: String = undefinedVariable
    
    // Error 2: Type mismatch
    @State private var counter: String = 42
    
    var body: some View {
        VStack {
            // Error 3: Syntax error - missing closing quote
            Text("Hello, world!
            
            // Error 4: Invalid function call - nonExistentFunction doesn't exist
            Button("Tap me") {
                nonExistentFunction()
            }
            
            // Error 5: Type mismatch in assignment
            let result: Int = "This is a string"
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
                
            // Error 6: Using undefined property
            Text(self.nonExistentProperty)
            
            // Error 7: Invalid modifier chain
            Rectangle()
                .invalidModifier()
                .frame(width: 100, height: 100)
        }
        .padding()
        // Error 8: Syntax error - missing closing brace for VStack
    
    // Error 9: Function with wrong return type
    func calculateSum() -> String {
        return 10 + 20  // Returns Int but declared as String
    }
}

#Preview {
    ContentView()
}
