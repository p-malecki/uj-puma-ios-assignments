//
//  ContentView.swift
//  WeSplit
//
//  Created by Paul Hudson on 07/10/2023.
//
//  Modified by Pawel Malecki for UJ PUMAIOS course on 06/12/2023.

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool

    var totalAmount: Double {
		let tipSelection = Double(tipPercentage)
		let tipValue = checkAmount / 100 * tipSelection
		let grandTotal = checkAmount + tipValue
		return grandTotal
	}

	var totalPerPerson: Double {
		let peopleCount = Double(numberOfPeople + 2)
		let amountPerPerson = totalAmount / peopleCount
		return amountPerPerson
	}

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)

                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }

                Section("How much do you want to tip?") {
                    Text("Current Tip percentage: \(tipPercentage)%")
                    NavigationLink(destination: PickerDetailView(tipPercentage: $tipPercentage)) { // project 1 challange #3
                        Text("Change")
                    }
                }

                
                Section("Amount per person") { // project 1 challange #1
					Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .foregroundColor(tipPercentage == 0 ? .red : .black)  // project 3 challange #1
				}

				Section("The total amount for the check") {  // project 1 challange #2
					Text(totalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
				}
            }
            .navigationTitle("WeSplit")
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
