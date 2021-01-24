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
    
    @Published var id: Int? = 0
    @Published var workflowState: String? = "active"
    @Published var position: Int? = 1
    @Published var name: String? = "This is a module"
    @Published var unlockAt: Date? = nil
    @Published var requireSequentialProgress: Bool? = false
    @Published var prerequisiteModuleIDs: [Int]? = []
    @Published var itemsCount: Int? = 0
    @Published var itemsURL: String? = ""
    @Published var state: String? = "started"
    @Published var completedAt: Date? = nil
    @Published var publishFinalGrade: Bool? = false
    @Published var published: Bool? = true
    
    @Published var course: Course?
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
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(Int?.self, forKey: .id)
        workflowState = try? values.decode(String?.self, forKey: .workflowState)
        position = try? values.decode(Int?.self, forKey: .position)
        name = try? values.decode(String?.self, forKey: .name)
        unlockAt = try? values.decode(Date?.self, forKey: .unlockAt)
        requireSequentialProgress = try? values.decode(Bool?.self, forKey: .requireSequentialProgress)
        prerequisiteModuleIDs = try? values.decode([Int]?.self, forKey: .prerequisiteModuleIDs)
        itemsCount = try? values.decode(Int?.self, forKey: .itemsCount)
        itemsURL = try? values.decode(String?.self, forKey: .itemsURL)
        state = try? values.decode(String?.self, forKey: .state)
        completedAt = try? values.decode(Date?.self, forKey: .completedAt)
        publishFinalGrade = try? values.decode(Bool?.self, forKey: .publishFinalGrade)
        published = try? values.decode(Bool?.self, forKey: .published)
    }
    
    func updateModuleItems() {
        Manager.instance?.canvasAPI.getModuleItems(forModule: self) { data in
            self.moduleItems = data.value ?? []
            
            for i in self.moduleItems! {
                i.module = self
            }
            self.objectWillChange.send()
            
            // its hacky but It Works
            Manager.instance?.canvasAPI.objectWillChange.send()
        }
    }
}

class ModuleItem: Decodable, Hashable, ObservableObject {
    static func == (lhs: ModuleItem, rhs: ModuleItem) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    @Published var id: Int? = 0
    @Published var moduleID: Int? = 0
    @Published var position: Int? = 1
    @Published var title: String? = "Module Item Title"
    @Published var indent: Int? = 0
    @Published var type: ModuleItemType? = .Page
    @Published var contentID: Int? = 0
    @Published var htmlURL: String? = ""
    @Published var apiURL: String? = ""
    @Published var pageURL: String? = ""
    @Published var externalURL: String? = ""
    @Published var openInNewTab: Bool? = false
//    var completionRequirement: CompletionRequirement? = nil
    @Published var contentDetails: ContentDetails? = nil
    
    @Published var module: Module? = nil
    
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
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try? values.decode(Int?.self, forKey: .id)
        moduleID = try? values.decode(Int?.self, forKey: .moduleID)
        position = try? values.decode(Int?.self, forKey: .position)
        title = try? values.decode(String?.self, forKey: .title)
        indent = try? values.decode(Int?.self, forKey: .indent)
        type = try? values.decode(ModuleItemType?.self, forKey: .type)
        contentID = try? values.decode(Int?.self, forKey: .contentID)
        htmlURL = try? values.decode(String?.self, forKey: .htmlURL)
        apiURL = try? values.decode(String?.self, forKey: .apiURL)
        pageURL = try? values.decode(String?.self, forKey: .pageURL)
        externalURL = try? values.decode(String?.self, forKey: .externalURL)
        openInNewTab = try? values.decode(Bool?.self, forKey: .openInNewTab)
        contentDetails = try? values.decode(ContentDetails?.self, forKey: .contentDetails)
    }
}

class ModulePageItem: Decodable, Hashable, ObservableObject {
    static func == (lhs: ModulePageItem, rhs: ModulePageItem) -> Bool {
        return lhs.pageID == rhs.pageID
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(pageID)
    }
    
    @Published var title: String? = "Module Page Item"
    @Published var createdAt: Date? = Date()
    @Published var url: String? = ""
    @Published var editingRoles: String? = ""
    @Published var pageID: Int? = 0
    @Published var published: Bool? = false
    @Published var hideFromStudents: Bool? = false
    @Published var frontPage: Bool? = false
    @Published var htmlURL: String? = ""
    @Published var todoDate: Date? = Date()
    @Published var updatedAt: Date? = Date()
    @Published var lockedForUser: Bool? = false
    @Published var body: String? = ""
    
    @Published var module: Module?
    
    enum CodingKeys: String, CodingKey {
        case title
        case createdAt = "created_at"
        case url
        case editingRoles = "editing_roles"
        case pageID = "page_id"
        case published
        case hideFromStudents = "hide_from_students"
        case frontPage = "front_page"
        case htmlURL = "html_url"
        case todoDate = "todo_date"
        case updatedAt = "updated_at"
        case lockedForUser = "locked_for_user"
        case body
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try? values.decode(String?.self, forKey: .title)
        createdAt = try? values.decode(Date?.self, forKey: .createdAt)
        url = try? values.decode(String?.self, forKey: .url)
        editingRoles = try? values.decode(String?.self, forKey: .editingRoles)
        pageID = try? values.decode(Int?.self, forKey: .pageID)
        published = try? values.decode(Bool?.self, forKey: .published)
        hideFromStudents = try? values.decode(Bool?.self, forKey: .hideFromStudents)
        frontPage = try? values.decode(Bool?.self, forKey: .frontPage)
        htmlURL = try? values.decode(String?.self, forKey: .htmlURL)
        todoDate = try? values.decode(Date?.self, forKey: .todoDate)
        updatedAt = try? values.decode(Date?.self, forKey: .updatedAt)
        lockedForUser = try? values.decode(Bool?.self, forKey: .lockedForUser)
        body = try? values.decode(String?.self, forKey: .body)
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
    
    @Published var type: CompletionRequirementType? = .MustView
    @Published var minScore: Double? = 0.0
    @Published var completed: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case type
        case minScore = "min_score"
        case completed
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try? values.decode(CompletionRequirementType?.self, forKey: .type)
        minScore = try? values.decode(Double?.self, forKey: .minScore)
        completed = try? values.decode(Bool?.self, forKey: .completed)
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
     
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        pointsPossible = try? values.decode(Double?.self, forKey: .pointsPossible)
        lockedForUser = try? values.decode(Bool?.self, forKey: .lockedForUser)
        lockExplanation = try? values.decode(String?.self, forKey: .lockExplanation)
        
        dueAt = try? values.decode(Date?.self, forKey: .dueAt)
        unlockAt = try? values.decode(Date?.self, forKey: .unlockAt)
        lockAt = try? values.decode(Date?.self, forKey: .lockAt)
    }
    
    @Published var pointsPossible: Double? = 0
    @Published var dueAt: Date?
    @Published var unlockAt: Date?
    @Published var lockAt: Date?
    @Published var lockedForUser: Bool? = false
    @Published var lockExplanation: String? = "lock explanation?"
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
