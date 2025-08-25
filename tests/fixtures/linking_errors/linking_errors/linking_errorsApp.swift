//
//  linking_errorsApp.swift
//  linking_errors
//
//  Created by Mateusz Bąk on 8/18/25.
//

import SwiftUI
import Foundation
// These imports may cause linking issues if frameworks aren't properly linked
import CoreML
import Vision
import MapKit
import AVFoundation
import CoreData

// External symbol references that will cause linking errors
@_silgen_name("missing_static_library_function")
func missingStaticLibraryFunction(_ param: UnsafePointer<CChar>) -> Int32

@_silgen_name("undefined_c_library_symbol")
func undefinedCLibrarySymbol() -> UnsafeMutableRawPointer?

// Missing Objective-C runtime symbols
@objc protocol MissingProtocol {
    @objc optional func missingProtocolMethod() -> Bool
}

// This class will create linking errors due to missing external symbols
class UndefinedFrameworkClass {
    init() {
        // Reference to missing external library initialization
        let result = missingStaticLibraryFunction("initialization")
        print("Library init result: \(result)")
        
        // Reference to undefined C library symbol
        let pointer = undefinedCLibrarySymbol()
        if pointer != nil {
            print("Got pointer from undefined symbol")
        }
    }
    
    func performMissingFrameworkOperation() {
        // This will reference symbols from frameworks that might not be linked
        let _ = AVAudioEngine() // May cause linking issues if AVFoundation not properly linked
        let _ = NSPersistentContainer(name: "NonExistentModel") // CoreData linking issue
    }
}

// Global variable that references missing external symbol
let globalMissingLibraryReference: Int32 = {
    return missingStaticLibraryFunction("global_init")
}()

@main
struct linking_errorsApp: App {
    // Create reference to missing symbols during app initialization  
    let missingLibraryManager = UndefinedFrameworkClass()
    
    init() {
        // These calls will create linking errors for undefined external symbols
        initializeMissingExternalLibraries()
        setupMissingFrameworkDependencies()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Reference to missing symbol in app lifecycle
                    performStartupLinkingOperations()
                }
        }
    }
    
    private func initializeMissingExternalLibraries() {
        // Reference undefined external library symbols
        let initResult = missingStaticLibraryFunction("app_startup")
        print("External library initialization: \(initResult)")
        
        // Reference to potentially missing dynamic library
        let dynamicResult = undefinedCLibrarySymbol()
        if dynamicResult != nil {
            print("Dynamic library symbol resolved")
        } else {
            print("Failed to resolve dynamic library symbol")
        }
    }
    
    private func setupMissingFrameworkDependencies() {
        // Create references to framework symbols that may not be properly linked
        missingLibraryManager.performMissingFrameworkOperation()
        
        // Reference to missing CoreML symbols
        do {
            // This may fail at linking if CoreML framework is not properly included
            let config = MLModelConfiguration()
            print("CoreML config created: \(config)")
        } catch {
            print("CoreML linking error: \(error)")
        }
        
        // Reference to missing Vision framework symbols
        let textRequest = VNRecognizeTextRequest()
        print("Vision request created: \(textRequest)")
        
        // Reference to missing AVFoundation symbols
        let audioSession = AVAudioSession.sharedInstance()
        print("Audio session: \(audioSession)")
    }
    
    private func performStartupLinkingOperations() {
        // Additional references to missing symbols during runtime
        print("Global missing library reference: \(globalMissingLibraryReference)")
        
        // This will try to access the duplicate symbol, causing linking conflicts
        let duplicateInstance = UndefinedFrameworkClass()
        duplicateInstance.performMissingFrameworkOperation()
    }
}

// Additional external C function references for more linking errors
@_silgen_name("missing_crypto_function")
func missingCryptoFunction(_ data: UnsafePointer<UInt8>, _ length: Int) -> Int32

@_silgen_name("undefined_network_library_symbol")
func undefinedNetworkLibrarySymbol(_ host: UnsafePointer<CChar>, _ port: UInt16) -> Int32

// Global initialization that will cause linking errors
private let cryptoInitialization: () = {
    let testData: [UInt8] = [0x01, 0x02, 0x03, 0x04]
    let result = testData.withUnsafeBufferPointer { buffer in
        return missingCryptoFunction(buffer.baseAddress!, buffer.count)
    }
    print("Crypto initialization result: \(result)")
}()

private let networkInitialization: () = {
    let result = undefinedNetworkLibrarySymbol("localhost", 8080)
    print("Network library initialization: \(result)")
}()
