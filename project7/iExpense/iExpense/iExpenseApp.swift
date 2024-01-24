//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Student1 on 23/01/2024.
//

import SwiftUI
import SwiftData

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)   // project 12 challange #1
    }
}
