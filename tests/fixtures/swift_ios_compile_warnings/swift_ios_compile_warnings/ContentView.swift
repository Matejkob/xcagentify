//
//  ContentView.swift
//  swift_ios_compile_warnings
//
//  Created by Mateusz Bąk on 8/18/25.
//

import SwiftUI
import Foundation  // Unused import warning
import UIKit       // Unused import warning

enum CompileStatus {
    case loading
    case success
    case error
}

struct ContentView: View {
    // Unused variable warning
    let unusedConstant = "This will never be used"
    
    // Variable shadowing warning
    let title = "App Title"
    
    @State private var counter = 0
    @State private var optionalText: String? = "Hello"
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            // Variable shadowing warning - 'title' shadows the property
            let title = "Local Title"
            Text(title)
            
            // Force unwrapping warning
            Text(optionalText!)
                .foregroundColor(.blue)
            
            // Deprecated API usage warning
            Text("Counter: \(counter)")
                .foregroundColor(.red)  // Deprecated in favor of .foregroundStyle
            
            Button("Increment") {
                // Unused variable warning
                let unusedButtonVar = "Not used"
                counter += 1
                
                // Force unwrapping in closure
                let forcedString = optionalText!
                print(forcedString)
            }
            
            // Switch statement with missing cases warning - use enum to force the issue
            let status: CompileStatus = .loading
            switch status {
            case .loading:
                Text("Loading")
            case .success:
                Text("Success")
            // Missing .error case - will generate warning
            default:
                Text("Other")
            }
        }
        .padding()
        .onAppear {
            setupWarnings()
        }
    }
    
    private func setupWarnings() {
        // Unused variable in function
        let localUnused = "Function scope unused"
        
        // Force unwrapping in method
        let unwrapped = optionalText!
        print("Unwrapped: \(unwrapped)")
        
        // Variable shadowing in function
        let counter = 99  // Shadows the @State property
        print("Local counter: \(counter)")
    }
    
    // Unused private method warning
    private func unusedMethod() {
        print("This method is never called")
    }
}

#Preview {
    ContentView()
}
