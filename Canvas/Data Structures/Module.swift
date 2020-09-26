//
//  Module.swift
//  Canvas
//
//  Created by Test Account on 9/26/20.
//

import Foundation

struct Module: Decodable, Hashable {
    let id: Int?
    let workflowState: String?
    let position: Int?
    let name: String?
    let unlockAt: String?
    let requireSequentialProgress: Bool?
    let prerequisiteModuleIDs: [Int]?
    let itemsCount: Int?
    let itemsURL: String?
    let state: String?
    let completedAt: String?
    let publishFinalGrade: Bool?
    let published: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case workflowState = "workflow_state"
        case position
        case name
        case unlockAt = "unlock_at"
        case requireSequentialProgress = "require_sequential_progress"
        case prerequisiteModuleIDs = "prerequisite_module_ids"
        case itemsCount = "items_count"
        case itemsURL = "items_url"
        case state
        case completedAt = "completed_at"
        case publishFinalGrade = "publish_final_grade"
        case published
    }
}
