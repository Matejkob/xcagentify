//
//  swift_ios_compile_warningsApp.swift
//  swift_ios_compile_warnings
//
//  Created by Mateusz Bąk on 8/18/25.
//

import SwiftUI
import Combine    // Unused import warning
import CoreData   // Unused import warning

@main
struct swift_ios_compile_warningsApp: App {
    // Unused property warning
    let appVersion = "1.0.0"
    
    // Optional property for force unwrapping warning
    let optionalAppName: String? = "TestApp"
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    initializeApp()
                }
        }
    }
    
    private func initializeApp() {
        // Unused variable warning
        let startupMessage = "App is starting up"
        
        // Force unwrapping warning
        let appName = optionalAppName!
        print("App name: \(appName)")
        
        // Variable shadowing warning
        let appVersion = "2.0.0"  // Shadows the property
        print("Version: \(appVersion)")
        
        // Deprecated API usage (if available)
        performLegacyOperation()
    }
    
    // Method with deprecated practices
    private func performLegacyOperation() {
        // Force unwrapping in nested context
        if let name = optionalAppName {
            let forcedName = optionalAppName!  // Unnecessary force unwrap
            print("Processing: \(forcedName)")
        }
        
        // Unused variable in conditional
        let condition = true
        if condition {
            let unusedInIf = "Not used"
            print("Condition met")
        }
    }
    
    // Unused private method
    private func unusedAppMethod() -> String {
        // More warnings inside unused method
        let unused1 = "First unused"
        let unused2 = "Second unused"
        return optionalAppName!  // Force unwrap in return
    }
}
