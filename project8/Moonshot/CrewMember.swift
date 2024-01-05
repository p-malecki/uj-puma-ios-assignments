//
//  Astronaut.swift
//  Moonshot
//
//  Created by Pawel Malecki for UJ PUMAIOS course on 05/01/2024.
//

import Foundation

struct CrewMember: Codable, Identifiable {
    let role: String
    let astronaut: Astronaut
}
