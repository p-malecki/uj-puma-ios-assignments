//
//  ContentView.swift
//  BetterRest
//
//  Created by Paul Hudson on 15/10/2023.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1

    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

    @State private var sleepTime = defaultWakeTime


    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }

    var body: some View {
        NavigationStack {
            Form {
                //VStack(alignment: .leading, spacing: 0) {  #1
                Section(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up?")
                        .font(.headline)

                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .onChange(of: wakeUp) { _ in
                        calculateBedtime()
                    }
                    // .onDisappear {  // ?
                    //     calculateBedtime()
                    // }
                }

                Section(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)

                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    .pickerStyle(SegmentedPickerStyle()) // ?
                    .onChange(of: sleepAmount) { _ in
                        calculateBedtime()
                    }
                }

                Section(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake")
                        .font(.headline)

                    //Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20) #2
                    Picker("Number of cups", selection: $coffeeAmount) {
                        ForEach(1 ..<= 20) {
                            Text("^[\($0) cup](inflect: true)")
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .onChange(of: coffeeAmount) { _ in
                        calculateBedtime()
                    }
                }

                Section(alignment: .leading, spacing: 0) {
                    Text("Your ideal bedtime is:")
                        .font(.headline)

                    Text("\(sleepTime.formatted(date: .omitted, time: .shortened))")
                    .foregroundStyle(.red)
                    .font(.subheadline)
                    .font(.bold)
                }

            }
            .navigationTitle("BetterRest")
            // #3
            // .toolbar { 
            //     Button("Calculate", action: calculateBedtime)
            // }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") {
                    showingAlert = false
                }
            } message: {
                Text(alertMessage)
            }
        }
    }

    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)

            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60

            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            sleepTime = wakeUp - prediction.actualSleep

            // alertTitle = "Your ideal bedtime is…"
            // alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
            showingAlert = true
        }
    }
}

#Preview {
    ContentView()
}
