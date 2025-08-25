//
//  swift_ios_compile_errorsApp.swift
//  swift_ios_compile_errors
//
//  Created by Mateusz Bąk on 8/18/25.
//

import SwiftUI
// Missing import Foundation - will cause issues with some Foundation types

@main
struct swift_ios_compile_errorsApp: App {
    // Error 10: Property with wrong type
    var invalidProperty: NonExistentType = "test"
    
    var body: some Scene {
        WindowGroup {
            // Error 11: Passing wrong parameter type
            ContentView(invalidParameter: 123)
            
            // Error 12: Using undefined class
            UndefinedViewController()
        }
        
        // Error 13: Invalid scene type
        InvalidSceneType {
            Text("This won't work")
        }
    }
    
    // Error 14: Function with syntax error - missing return keyword
    func getData() -> [String] {
        ["item1", "item2"]  // Missing 'return' keyword
        // Error 15: Unreachable code after return
        print("This will never execute")
    }
}
