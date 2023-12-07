//
//  PickerDetailView.swift
//  WeSplit
//
//  Modified by Pawel Malecki for UJ PUMAIOS course on 06/12/2023.

import SwiftUI

struct PickerDetailView: View {
    @Binding var tipPercentage: Int
  
    var body: some View {
        NavigationStack {
            Form {
                Section ("Select current Tip percentage") {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0 ..< 101, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                }
            }
            .navigationTitle("Tip percentage")
        }
    }
}

#Preview {
    ContentView()
}
