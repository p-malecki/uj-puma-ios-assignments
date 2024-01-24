//
//  ContentView.swift
//  Moonshot
//
//  Created by Student1 on 05/01/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var missionsAsGrid = true // project 8 challange #3

    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")

    var body: some View {
        
        NavigationStack {
            VStack {
                // project 8 challange #3
                Group {
                    if missionsAsGrid {
                        GridLayoutView(astronauts: astronauts, missions: missions)
                    } else {
                        ListLayoutView(astronauts: astronauts, missions: missions)
                    }
                }
                
            }
            .navigationTitle("Moonshot")
            .toolbar {   // project 8 challange #3
                Button(missionsAsGrid ? "List view":"Grid view") {
                    missionsAsGrid.toggle()
                }
            }
            .background(.darkBackground)
        }
        
        .preferredColorScheme(.dark)
        //.edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    ContentView()
}
