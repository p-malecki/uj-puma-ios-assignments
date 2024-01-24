//
//  ContentView.swift
//  BetterRest
//
//  Created by Student1 on 20/12/2023.
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
    
    init() {
            calculateBedtime()
        }
    
    var body: some View {
        NavigationStack {
            Form {
                Section() { // project 4 challange #1
                    Text("When do you want to wake up?")
                        .font(.headline)
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .onChange(of: wakeUp) {
                            calculateBedtime()
                        }
                }
                Section() {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                        .onChange(of: sleepAmount) {
                            calculateBedtime()
                        }
                }
                
                Section() {
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    Picker("Number of cups", selection: $coffeeAmount) { // project 4 challange #2
                        ForEach(1 ..< 21) {
                            Text("^[\($0) cup](inflect: true)")
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .onChange(of: coffeeAmount) {
                        calculateBedtime()
                    }
                }
                
                Section() {
                    Text("Your ideal bedtime is:")
                        .font(.headline)
                    
                    Text("\(sleepTime.formatted(date: .omitted, time: .shortened))")
                        .foregroundStyle(.red)
                        .font(Font.headline.weight(.bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                
                
            }
            .navigationTitle("BetterRest")
            .alert(alertTitle, isPresented: $showingAlert) {  // project 4 challange #3
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

            let prediction = try model.prediction(wake: Int64(hour + minute), estimatedSleep: sleepAmount, coffee: Int64(coffeeAmount))

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
