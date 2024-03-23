//
//  ExpensesView.swift
//  iExpense
//
//  Created by Student1 on 23/01/2024.
//

import SwiftUI
import SwiftData

struct ExpensesView: View { // project 12 challange #2, #3
    @Environment(\.modelContext) var modelContext 
    @Environment(\.dismiss) var dismiss
    @Query var expenseItems: [ExpenseItem]
    
    @State private var showingAddExpense = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(expenseItems) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)

                            Text(item.type)
                        }

                        Spacer()

                        Text(item.amount, format: .currency(code: item.currency))
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView()
            }
        }
    }

    init(type: String, sortOrder: [SortDescriptor<ExpenseItem>]) {   // project 12 challange #2, #3
        if (type == "All") {
            _expenseItems = Query(filter: nil, sort: sortOrder)
        }
        else {
            _expenseItems = Query(filter: #Predicate<ExpenseItem> { item in
                item.type == type
            }, sort: sortOrder)
        }
        
    }

    func removeItems(at offsets: IndexSet) {  // project 12 challange #1
        for offset in offsets {
            let item = expenseItems[offset]
            modelContext.delete(item)
        }
    }
}

#Preview {
    ExpensesView(type: "Personal", sortOrder: [SortDescriptor(\ExpenseItem.name)])
}
