//
//  PickerDetailView.swift
//  WeSplit
//
//  Modified by Pawel Malecki for UJ PUMAIOS course on 06/12/2023.

import SwiftUI

struct PickerDetailView: View {
    @State private var numberOfPeople = 2
  
    var body: some View {
        NavigationStack {
            Form {
                Picker("Tip percentage", selection: $tipPercentage) {
                    ForEach(0 ..< 101, id: \.self) {
                        Text($0, format: .percent)
                    }
                }
            }
            .navigationTitle("Select current Tip percentage")
        }
    }
}

#Preview {
    ContentView()
}
