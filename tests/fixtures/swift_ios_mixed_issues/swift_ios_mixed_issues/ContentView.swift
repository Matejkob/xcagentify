//
//  ContentView.swift
//  swift_ios_mixed_issues
//
//  Created by Mateusz Bąk on 8/18/25.
//

import SwiftUI

struct ContentView: View {
    // WARNING: Unused variable
    let unusedVariable = "This will generate a warning"
    
    // WARNING: Force unwrapping
    let forceUnwrappedString = "Test"!
    
    var body: some View {
        VStack {
            // ERROR: Undefined variable
            Text(undefinedVariable)
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            // WARNING: Deprecated API usage (iOS 13+)
            Text("Hello, world!")
                .foregroundColor(.blue) // Deprecated in favor of .foregroundStyle
            
            // ERROR: Type mismatch - trying to pass String where Int is expected
            Text("Count: \(invalidTypeUsage)")
            
            // WARNING: Force try
            Text(try! riskyOperation())
            
            // ERROR: Missing closing parenthesis
            Button("Tap me", action: {
                // ERROR: Undefined method
                nonExistentMethod()
            }
            
            // ERROR: Syntax error - missing dot
            Text("Another text")
                foregroundStyle(.red)
        }
        .padding()
    }
    
    // This function will cause a warning about unused private function
    private func unusedPrivateFunction() {
        print("This function is never called")
    }
    
    // ERROR: Function with wrong return type
    func riskyOperation() -> String {
        return 42 // ERROR: Cannot convert return expression of type 'Int' to return type 'String'
    }
}

#Preview {
    ContentView()
}
