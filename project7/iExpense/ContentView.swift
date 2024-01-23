//
//  ContentView.swift
//  iExpense
//
//  Created by Paul Hudson on 15/10/2023.
//
//  Modified by Pawel Malecki for UJ PUMAIOS course on 23/01/2024.


import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) var modelContext  // project 12 challange #1
    @Query var expenseItems: [ExpenseItem]

    @State private var showingAddExpense = false
    @State private var sortOrder = [SortDescriptor(\ExpenseItem.name)]   // project 12 challange #2
    @State private var filterType = "personal"  // project 12 challange #3

    var body: some View {

        Menu("Sort and Filter", systemImage: "arrow.up.arrow.down") {  // project 12 challange #2
            Picker("Sort", selection: $sortOrder) {
                Text("Sort by Name")
                    .tag([SortDescriptor(\ExpenseItem.name)])

                Text("Sort by Amount")
                    .tag([SortDescriptor(\ExpenseItem.amount)])
            }

            Picker("Filter", selection: $sortOrder) {
                Text("Personal expenses only")
                    .tag( filterType = "Personal" )

                Text("Business expenses only")
                    .tag([ filterType = "Business" ])
            }
        }

        ExpensesView(type: filterType, sortOrder: sortOrder)
    }
}

#Preview {
    ContentView()
}
