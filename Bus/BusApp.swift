//
//  BusApp.swift
//  Bus
//
//  Created by Ayaan on 2023-04-14.
//

import SwiftUI

@main
struct BusApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Network())
        }
    }
}
