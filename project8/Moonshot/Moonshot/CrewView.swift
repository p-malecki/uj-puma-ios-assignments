//
//  CrewView.swift
//  Moonshot
//
//  Created by Student1 on 05/01/2024.
//


import SwiftUI


// project 8 challange #2
struct CrewView: View {
    let crew: [CrewMember]

    var body: some View {
        NavigationStack {
            //Spacer()
            
            ScrollView() {
                VStack(alignment: .leading) {
                    ForEach(crew, id: \.role) { crewMember in
                        NavigationLink {
                            AstronautView(astronaut: crewMember.astronaut)
                        } label: {
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 104, height: 72)
                                    .clipShape(.capsule)
                                    .overlay(
                                        Capsule()
                                            .strokeBorder(.white, lineWidth: 1)
                                    )
                                
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .foregroundStyle(.white)
                                        .font(.headline)
                                    
                                    Text(crewMember.role)
                                        .foregroundStyle(.white.opacity(0.5))
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle("Crew")
            .navigationBarTitleDisplayMode(.inline)
            .background(.darkBackground)
        }
    }
    

    init(crewMembers: [CrewMember]) {
        self.crew = crewMembers
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let crew = missions[4].crew.map { member in
        if let astronaut = astronauts[member.name] {
            return CrewMember(role: member.role, astronaut: astronaut)
        } else {
            fatalError("Missing \(member.name)")
        }
    }

    return CrewView(crewMembers: crew)
        .preferredColorScheme(.dark)
}
