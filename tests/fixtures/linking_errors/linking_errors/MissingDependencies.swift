//
//  MissingDependencies.swift
//  linking_errors
//
//  Created for testing linking errors in xcagentify
//

import Foundation
import UIKit
// Imports that may cause linking issues
import CoreLocation
import UserNotifications
import WebKit

// External library function declarations that don't exist
@_silgen_name("missing_openssl_init")
func missingOpenSSLInit() -> Int32

@_silgen_name("undefined_sqlite_function")
func undefinedSQLiteFunction(_ query: UnsafePointer<CChar>) -> UnsafeMutableRawPointer?

@_silgen_name("missing_third_party_library")
func missingThirdPartyLibrary(_ config: UnsafePointer<CChar>) -> Bool

// Objective-C interop that references missing symbols
@objc class MissingNativeLibrary: NSObject {
    @objc dynamic func initializeNativeLibrary() -> Bool {
        // Reference to missing native library initialization
        let result = missingOpenSSLInit()
        return result == 0
    }
    
    @objc dynamic func performDatabaseOperation(_ query: String) -> Bool {
        // Reference to missing SQLite library
        return query.withCString { cString in
            let result = undefinedSQLiteFunction(cString)
            return result != nil
        }
    }
    
    @objc dynamic func configureThirdPartySDK() -> Bool {
        // Reference to missing third-party SDK
        return "default_config".withCString { cString in
            return missingThirdPartyLibrary(cString)
        }
    }
}

// This class will create additional linking issues with missing dependencies
class MissingFrameworksManager {
    // Different implementation that will cause linking errors due to missing framework dependencies
    let identifier = "MissingDependencies_Version"
    
    func initializeMissingFrameworks() {
        // Reference to location services that might not be properly linked
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        // Reference to notification services that might cause linking issues
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            print("Notification permission granted: \(granted), error: \(String(describing: error))")
        }
        
        // Reference to WebKit that might not be properly linked
        let webView = WKWebView()
        print("WebView created: \(webView)")
    }
}

// Protocol that references missing framework symbols
protocol MissingFrameworkDelegate: AnyObject {
    func didInitializeMissingLibrary(_ library: MissingNativeLibrary, result: Bool)
    func didFailWithMissingSymbol(_ symbol: String)
    func didEncounterLinkingError(_ error: LinkingError)
}

// Enum that references external symbols
enum LinkingError: Int32, Error, CaseIterable {
    case missingStaticLibrary = 1001
    case missingDynamicLibrary = 1002
    case undefinedSymbol = 1003
    case duplicateSymbol = 1004
    case missingFramework = 1005
    
    var description: String {
        switch self {
        case .missingStaticLibrary:
            // Reference to missing static library function
            let code = missingOpenSSLInit()
            return "Missing static library (code: \(code))"
        case .missingDynamicLibrary:
            // Reference to missing dynamic library
            let pointer = undefinedSQLiteFunction("SELECT 1")
            return "Missing dynamic library (pointer: \(String(describing: pointer)))"
        case .undefinedSymbol:
            return "Undefined symbol in external library"
        case .duplicateSymbol:
            return "Duplicate symbol definition"
        case .missingFramework:
            // Reference to missing framework initialization
            let success = missingThirdPartyLibrary("test_config")
            return "Missing framework (success: \(success))"
        }
    }
}

// Singleton class that will create global linking issues
class MissingLibraryManager {
    static let shared = MissingLibraryManager()
    
    private let nativeLibrary = MissingNativeLibrary()
    private var isInitialized = false
    
    private init() {
        // Global initialization that references missing symbols
        initializeGlobalDependencies()
    }
    
    private func initializeGlobalDependencies() {
        // These calls will create linking errors during app startup
        isInitialized = nativeLibrary.initializeNativeLibrary()
        
        if !isInitialized {
            print("Failed to initialize native library")
            
            // Attempt alternative initialization with missing symbols
            let dbSuccess = nativeLibrary.performDatabaseOperation("CREATE TABLE test (id INTEGER)")
            let sdkSuccess = nativeLibrary.configureThirdPartySDK()
            
            print("Database init: \(dbSuccess), SDK init: \(sdkSuccess)")
        }
        
        // Reference to missing frameworks manager
        let frameworkInstance = MissingFrameworksManager()
        frameworkInstance.initializeMissingFrameworks()
    }
    
    func performOperationWithMissingDependencies() -> [LinkingError] {
        var errors: [LinkingError] = []
        
        // Try to use all missing dependencies
        for errorType in LinkingError.allCases {
            do {
                let description = errorType.description
                print("Error description: \(description)")
                errors.append(errorType)
            }
        }
        
        return errors
    }
}

// Global variables that reference missing external symbols
let globalOpenSSLReference: Int32 = missingOpenSSLInit()

let globalSQLiteReference: UnsafeMutableRawPointer? = undefinedSQLiteFunction("PRAGMA version")

let globalThirdPartyReference: Bool = missingThirdPartyLibrary("global_initialization")

// Function that will be called during module loading
@_cdecl("missing_dependencies_module_init")
public func missingDependenciesModuleInit() {
    print("Global OpenSSL reference: \(globalOpenSSLReference)")
    print("Global SQLite reference: \(String(describing: globalSQLiteReference))")
    print("Global third-party reference: \(globalThirdPartyReference)")
    
    // This will trigger the singleton initialization with missing symbols
    let _ = MissingLibraryManager.shared
}