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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appRouter)
        }
    }
}
