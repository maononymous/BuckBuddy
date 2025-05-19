//
//  ContentView.swift
//  BuckBuddy
//
//  Created by Abdullah Omer Mohammed on 5/14/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "atom")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Welcome to React!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
