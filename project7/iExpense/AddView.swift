//
//  AddView.swift
//  iExpense
//
//  Created by Paul Hudson on 16/10/2023.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var currency = ""
    
    let currencyCodes = [
        "PLN", "USD", "EUR", "JPY", "GBP",
        "CAD", "CHF", "CNY", "SEK", "NZD",
        "MXN", "SGD", "HKD", "NOK", "KRW",
        "TRY", "INR", "BRL", "ZAR", "RUB"
    ]

    
    var expenses: Expenses

    let types = ["Business", "Personal"]

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)

                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: currency != "" ? currency:"PLN"))
                    .keyboardType(.decimalPad)
                
                Picker("Currency", selection: $currency) {
                   ForEach(currencyCodes, id: \.self) {
                        Text($0)
                    }
                    .pickerStyle(WheelPickerStyle())
                }
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount, currency: currency)
                    expenses.items.append(item)
                    dismiss()
                }
            }
        }
        
    }
}

#Preview {
    AddView(expenses: Expenses())
}
