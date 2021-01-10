//
//  Module.swift
//  Canvas
//
//  Created by Test Account on 9/26/20.
//

import Foundation

class Module: Decodable, Hashable, ObservableObject {
    static func == (lhs: Module, rhs: Module) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: Int? = 0
    var workflowState: String? = "active"
    var position: Int? = 1
    var name: String? = "This is a module"
    var unlockAt: String? = ""
    var requireSequentialProgress: Bool? = false
    var prerequisiteModuleIDs: [Int]? = []
    var itemsCount: Int? = 0
    var itemsURL: String? = ""
    var state: String? = "started"
    var completedAt: String? = ""
    var publishFinalGrade: Bool? = false
    var published: Bool? = true
    
    var course: Course?
    @Published var moduleItems: [ModuleItem]? = []
    
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
    
    func updateModuleItems() {
        CanvasAPI.instance?.getModuleItems(forModule: self) { data in
            self.moduleItems = data.value!
            
//            print("self.moduleItems count is \(self.moduleItems!.count)")
            
            for i in self.moduleItems! {
                i.module = self
//                print("Module item title: \(i.title!)")
            }
            self.objectWillChange.send()
            
            // its hacky but It Works
            print("Module items updated, new count is \(self.moduleItems!.count)")
            CanvasAPI.instance?.objectWillChange.send()
        }
    }
}

class ModuleItem: Decodable, Hashable, ObservableObject {
    static func == (lhs: ModuleItem, rhs: ModuleItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: Int? = 0
    var moduleID: Int? = 0
    var position: Int? = 1
    var title: String? = "Module Item Title"
    var indent: Int? = 0
    var type: ModuleItemType? = .Page
    var contentID: Int? = 0
    var htmlURL: String? = ""
    var apiURL: String? = ""
    var pageURL: String? = ""
    var externalURL: String? = ""
    var openInNewTab: Bool? = false
    var completionRequirement: CompletionRequirement? = CompletionRequirement()
    var contentDetails: ContentDetails? = ContentDetails()
    
    var module: Module? = nil
    
    enum CodingKeys: String, CodingKey {
        case id
        case moduleID = "module_id"
        case position
        case title
        case indent
        case type
        case contentID = "content_id"
        case htmlURL = "html_url"
        case apiURL = "url"
        case pageURL = "page_url"
        case externalURL = "external_url"
        case openInNewTab = "new_tab"
        case contentDetails = "content_details"
    }
}

class CompletionRequirement: Decodable, Hashable, ObservableObject {
    static func == (lhs: CompletionRequirement, rhs: CompletionRequirement) -> Bool {
        return lhs.type == rhs.type && lhs.minScore == rhs.minScore && lhs.completed == rhs.completed
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(minScore)
        hasher.combine(completed)
    }
    
    var type: CompletionRequirementType = .MustView
    var minScore: Double? = 0.0
    var completed: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case type
        case minScore = "min_score"
        case completed
    }
}

enum CompletionRequirementType: String, Decodable {
    case MustView = "must_view"
    case MustSubmit = "must_submit"
    case MustContribute = "must_contribute"
    case MinScore = "min_score"
}

class ContentDetails: Decodable, Hashable, ObservableObject {
    static func == (lhs: ContentDetails, rhs: ContentDetails) -> Bool {
        return lhs.pointsPossible == rhs.pointsPossible &&
            lhs.dueAt == rhs.dueAt &&
            lhs.unlockAt == rhs.unlockAt &&
            lhs.lockAt == rhs.lockAt &&
            lhs.lockedForUser == rhs.lockedForUser &&
            lhs.lockExplanation == rhs.lockExplanation
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(pointsPossible)
        hasher.combine(dueAt)
        hasher.combine(unlockAt)
        hasher.combine(lockAt)
        hasher.combine(lockedForUser)
        hasher.combine(lockExplanation)
    }
    
    var pointsPossible: Int? = 0
    var dueAt: String? = ""
    var unlockAt: String? = ""
    var lockAt: String? = ""
    var lockedForUser: Bool? = false
    var lockExplanation: String? = "lock explanation?"
    // TODO: lock info
    
    enum CodingKeys: String, CodingKey {
        case pointsPossible = "points_possible"
        case dueAt = "due_at"
        case unlockAt = "unlock_at"
        case lockAt = "lock_at"
        case lockedForUser = "locked_for_user"
        case lockExplanation = "lock_explanation"
    }
}


enum ModuleItemType: String, Decodable {
    case Assignment = "Assignment"
    case Quiz = "Quiz"
    case File = "File"
    case Page = "Page"
    case Discussion = "Discussion"
    case Header = "SubHeader"
    case ExternalURL = "ExternalUrl"
    case ExternalTool = "ExternalTool"
}
