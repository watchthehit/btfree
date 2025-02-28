//
//  ContentView.swift
//  BetFreeApp
//
//  Created by Bassem Hakim on 2/28/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        BetFreeRootView()
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
