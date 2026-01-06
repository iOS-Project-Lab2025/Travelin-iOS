//
//  TravelingApp.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 21-10-25.
//

import SwiftUI

@main
struct TravelingApp: App {

    @State private var appRouter = AppRouter.Main.shared

    init() {
        UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appRouter)
        }
    }
}
