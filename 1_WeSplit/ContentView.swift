import SwiftUI

struct ContentView: View {
	@FocusState private var amountIsFocused: Bool
    @State private var checkAmount = 0.0
	@State private var numberOfPeople = 2
	@State private var tipPercentage = 20

	let tipPercentages = [10, 15, 20, 25, 0]
	
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
				}

				Picker("Number of people", selection: $numberOfPeople) {
					ForEach(2 ..< 100) {
						Text("\($0) people")
					}
				}
				.pickerStyle(.navigationLink)
				
				Section("How much tip do you want to leave?") {
					Picker("Tip percentage", selection: $tipPercentage) {
						ForEach(tipPercentages, id: \.self) {
							Text($0, format: .percent)
						}
					}
					.pickerStyle(.segmented)
				}

				Section("Amount per person") {
					Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
				}

				Section("The total amount for the check") {
					Text(totalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
				}
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

#Preview {
    ContentView()
}
