//
//  swift_ios_mixed_issuesApp.swift
//  swift_ios_mixed_issues
//
//  Created by Mateusz Bąk on 8/18/25.
//

import SwiftUI

@main
struct swift_ios_mixed_issuesApp: App {
    // WARNING: Unused property
    let unusedAppProperty = "Not used anywhere"
    
    // ERROR: Invalid property - trying to use non-existent type
    let invalidProperty: NonExistentType = "Error"
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            
            // ERROR: Cannot use multiple root views in WindowGroup
            AnotherInvalidView()
        }
        
        // WARNING: This line will never be reached (unreachable code)
        print("This will never execute")
    }
    
    // ERROR: Invalid function syntax - missing function keyword
    invalidFunction() {
        print("This is broken")
    }
}
