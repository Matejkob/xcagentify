//
//  ContentView.swift
//  linking_errors
//
//  Created by Mateusz Bąk on 8/18/25.
//

import SwiftUI
// These imports will compile but cause linking errors
import CoreML
import Vision
import MapKit

// External C function declarations that don't exist
@_silgen_name("missing_c_function")
func missingCFunction() -> Int32

@_silgen_name("undefined_external_symbol")
func undefinedExternalSymbol(_ value: Int32) -> Bool

// Reference to a missing Objective-C class
@objc class MissingObjCInterop: NSObject {
    @objc dynamic func callMissingFramework() {
        // This will try to call a method that doesn't exist in any linked framework
        let _ = UndefinedFrameworkClass()
    }
}

struct ContentView: View {
    @State private var analysisResult = "No analysis yet"
    @State private var mapCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Linking Errors Demo")
                .font(.title)
            
            // This will compile but fail at linking due to missing framework symbols
            Button("Call Missing C Function") {
                let result = missingCFunction()
                print("Result: \(result)")
            }
            
            Button("Call Undefined External Symbol") {
                let success = undefinedExternalSymbol(42)
                print("Success: \(success)")
            }
            
            // Reference to missing Vision framework symbols
            Button("Use Missing Vision Framework") {
                // This creates a reference to Vision framework symbols that may not be properly linked
                do {
                    let request = VNRecognizeTextRequest { _, _ in }
                    // This will create linking issues if Vision framework is not properly included
                    let handler = VNImageRequestHandler(data: Data(), options: [:])
                    try handler.perform([request])
                } catch {
                    print("Vision error: \(error)")
                }
            }
            
            // Missing MapKit framework usage
            Button("Use Missing MapKit Symbols") {
                // Create references to MapKit symbols that might not be linked
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapCoordinate
                print("Annotation: \(annotation)")
                
                // Reference to potentially missing MapKit class
                let mapView = MKMapView()
                mapView.setRegion(MKCoordinateRegion(), animated: false)
            }
            
            // This will try to instantiate a missing Objective-C class
            Button("Call Missing ObjC Framework") {
                let objcInterop = MissingObjCInterop()
                objcInterop.callMissingFramework()
            }
            
            Text(analysisResult)
                .padding()
        }
        .padding()
        .onAppear {
            // These calls will create linking errors for missing external symbols
            callMissingExternalLibrary()
            initializeMissingFramework()
        }
    }
    
    // Functions that reference undefined external symbols
    private func callMissingExternalLibrary() {
        // This references a symbol that doesn't exist in any linked library
        let result = missingCFunction()
        analysisResult = "External library result: \(result)"
    }
    
    private func initializeMissingFramework() {
        // Reference to undefined framework initialization function
        let success = undefinedExternalSymbol(100)
        if success {
            analysisResult += "\nFramework initialized successfully"
        } else {
            analysisResult += "\nFramework initialization failed"
        }
    }
}

// External class reference that doesn't exist - will cause linking error
class UndefinedFrameworkClass {
    init() {
        // This references a symbol that doesn't exist
        fatalError("This class should not exist - linking error expected")
    }
}

#Preview {
    ContentView()
}
