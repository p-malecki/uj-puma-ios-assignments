//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Student1 on 09/01/2024.
//

import SwiftUI
import SwiftData


@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self) 
    }
}
