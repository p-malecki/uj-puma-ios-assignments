//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Paul Hudson on 10/11/2023.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order: Order

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }
            // project 10 challange #3
            .onAppear {
                loadFromUserDefaults()
            }
            .onChange(of: order.name, perform: { saveToUserDefaults(value: order.name, key: "name") })
            .onChange(of: order.streetAddress, perform: { saveToUserDefaults(value: order.streetAddress, key: "streetAddress") })
            .onChange(of: order.city, perform: { saveToUserDefaults(value: order.city, key: "city") })
            .onChange(of: order.zip, perform: { saveToUserDefaults(value: order.zip, key: "zip") })

            Section {
                NavigationLink("Check out") {
                    CheckoutView(order: order)
                }
            }
            .disabled(order.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }

    // project 10 challange #3
    private func loadFromUserDefaults() {
        order.name = UserDefaults.standard.string(forKey: "name") ?? ""
        order.streetAddress = UserDefaults.standard.string(forKey: "streetAddress") ?? ""
        order.city = UserDefaults.standard.string(forKey: "city") ?? ""
        order.zip = UserDefaults.standard.string(forKey: "zip") ?? ""
    }

    private func saveToUserDefaults(value: String, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
}

#Preview {
    AddressView(order: Order())
}
