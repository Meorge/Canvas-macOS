//
//  AssignmentGroup.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/24/21.
//

import Foundation

// TODO: This creates duplicate copies of the assignments...
// maybe I should avoid getting the assignments through here and instead just use the IDs to link them?
class AssignmentGroup: Decodable, Identifiable, ObservableObject {
    @Published var id: Int?
    @Published var name: String?
    @Published var position: Int?
    @Published var groupWeight: Double?
    @Published var sisSourceID: String?
    @Published var integrationData: [String: String]?
    @Published var assignments: [Assignment]?
    @Published var rules: GradingRules?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case position
        case groupWeight = "group_weight"
        case sisSourceID = "sis_source_id"
        case integrationData = "integration_data"
        case assignments
        case rules
    }
    
    required init(from decoder: Decoder) throws {
        let v = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try? v.decode(Int?.self, forKey: .id)
        name = try? v.decode(String?.self, forKey: .name)
        position = try? v.decode(Int?.self, forKey: .position)
        groupWeight = try? v.decode(Double?.self, forKey: .groupWeight)
        sisSourceID = try? v.decode(String?.self, forKey: .sisSourceID)
        integrationData = try? v.decode([String: String]?.self, forKey: .integrationData)
        assignments = try? v.decode([Assignment]?.self, forKey: .assignments)
        rules = try? v.decode(GradingRules?.self, forKey: .rules)
    }
}

class GradingRules: Decodable, ObservableObject {
    @Published var dropLowest: Int?
    @Published var dropHighest: Int?
    @Published var neverDrop: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case dropLowest = "drop_lowest"
        case dropHighest = "drop_highest"
        case neverDrop = "never_drop"
    }
    
    required init(from decoder: Decoder) throws {
        let v = try decoder.container(keyedBy: CodingKeys.self)
        
        dropLowest = try? v.decode(Int?.self, forKey: .dropLowest)
        dropHighest = try? v.decode(Int?.self, forKey: .dropHighest)
        neverDrop = try? v.decode([Int]?.self, forKey: .neverDrop)
    }
}
