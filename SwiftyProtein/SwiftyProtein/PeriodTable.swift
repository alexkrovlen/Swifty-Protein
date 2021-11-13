//
//  PeriodTable.swift
//  SwiftyProtein
//
//  Created by Flash Jessi on 11/12/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import Foundation

struct PeriodTableResponse: Decodable {
    let elements: [PeriodTable]
}

struct PeriodTable: Decodable {
    let name: String
    let atomicMass: Double
    let boil: Double?
    let density: Double?
    let melt: Double?
    let desc: String
    let symbol: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case atomicMass = "atomic_mass"
        case boil = "boil"
        case density = "density"
        case melt = "melt"
        case desc = "summary"
        case symbol = "symbol"
    }
}
