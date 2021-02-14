//
//  Domain.swift
//  Canvas
//
//  Created by Malcolm Anderson on 2/13/21.
//

import Foundation

class Domain: Identifiable, Hashable, Decodable {
    static func == (lhs: Domain, rhs: Domain) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
    
    var id: Int? = nil
    var name: String = "It's a School"
    var domain: String = "school.edu"
    var distance: Double? = nil
    var authenticationProvider: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case domain
        case distance
        case authenticationProvider = "authentication_provider"
    }
}
