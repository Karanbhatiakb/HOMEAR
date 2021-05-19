//
//  HOMEARApp.swift
//  HOMEAR
//
//  Created by Karan Bhatia on 16/05/21.
//

import SwiftUI

@main
struct HOMEARApp: App {
    @StateObject var placementSettings = PlacementSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(placementSettings)
        }
    }
}
