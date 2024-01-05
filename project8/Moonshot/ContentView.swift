//
//  ContentView.swift
//  Moonshot
//
//  Created by Paul Hudson on 29/10/2023.
//
//  Modified by Pawel Malecki for UJ PUMAIOS course on 05/01/2024.


import SwiftUI

struct ContentView: View {
    @State private var missionsAsGrid = true // project 8 challange #3

    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")

    var body: some View {

        NavigationStack {
            // project 8 challange #3
            if missionsAsGrid {
                GridLayoutView(astronauts: astronauts, missions: missions)
            } else {
                ListLayoutView(astronauts: astronauts, missions: missions)
            }
        }
            .navigationTitle("Moonshot")
            .toolbar {   // project 8 challange #3
                Button("Grid view") {
                    //$missionsAsGrid.toggle()
                    $missionsAsGrid = !missionsAsGrid
                }
            }
            .background(.darkBackground)
            .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}