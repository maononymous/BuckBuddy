//
//  BuckBuddyApp.swift
//  BuckBuddy
//
//  Created by Abdullah Omer Mohammed on 5/14/25.
//

import SwiftUI
import Firebase

@main
struct BuckBuddyApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
