//
//  Tab.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/20/21.
//

import Foundation

class CourseLike: Identifiable, Decodable, Hashable, ObservableObject {
    @Published var name: String? = nil
    @Published var tabs: [Tab] = []
    @Published var id: Int?
    @Published var streamSummary: [ActivityStreamSummaryItem]?
    @Published var discussionTopics: [DiscussionTopic] = []
    @Published var announcements: [DiscussionTopic] = []
    @Published var defaultView: String? = nil
    @Published var people: [User] = []
    
    static func == (lhs: CourseLike, rhs: CourseLike) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var totalNotifications: Int {
        var total = 0
        for item in streamSummary ?? [] {
            // TODO: figure out how these work so I can incorporate the rest of them!
            if ![.Announcement, .DiscussionTopic].contains(item.type) { continue }
            total += item.unreadCount ?? 0
        }
        return total
    }
    func totalNotificationsOfType(_ type: ActivityStreamItemType) -> Int {
        var total = 0
        for item in streamSummary ?? [] {
            if item.type != type { continue }
            total += item.unreadCount ?? 0
        }
        return total
    }
    
    func updateTopLevel() {}
    func updateTabs() {}
    func updateAnnouncements() {}
    func updateStreamSummary() {}
    func updateDiscussionTopics() {}
    func updatePeople() {}
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try? c.decode(Int?.self, forKey: .id)
        name = try? c.decode(String?.self, forKey: .name)
    }
}

class Tab: Decodable, Hashable, ObservableObject {
    static func == (lhs: Tab, rhs: Tab) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    @Published var htmlURL: String?
    @Published var fullURL: String?
    @Published var id: String?
    @Published var label: String?
    @Published var type: TabType?
    @Published var hidden: Bool? = false
    @Published var visibility: TabVisibility?
    @Published var position: Int?
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        htmlURL = try? container.decode(String.self, forKey: .htmlURL)
        id = try? container.decode(String.self, forKey: .id)
        label = try? container.decode(String.self, forKey: .label)
        type = try? container.decode(TabType.self, forKey: .type)
        
        do {
            hidden = try container.decode(Bool.self, forKey: .hidden)
        } catch {}
        
        do {
            fullURL = try container.decode(String?.self, forKey: .fullURL)
        } catch {}
        
        
        visibility = try? container.decode(TabVisibility.self, forKey: .visibility)
        position = try? container.decode(Int.self, forKey: .position)
    }
    
    enum CodingKeys: String, CodingKey {
        case htmlURL = "html_url"
        case fullURL = "full_url"
        case id
        case label
        case type
        case hidden
        case visibility
        case position
    }
}

enum TabType: String, Decodable {
    case External = "external"
    case Internal = "internal"
}

enum TabVisibility: String, Decodable {
    case Public = "public"
    case Members = "members"
    case Admins = "admins"
    case None = "none"
}

//enum TabID: String, Decodable {
//    case Home = "home"
//    case Announcements = "announcements"
//    case Modules = "modules"
//    case Syllabus = "syllabus"
//    case People = "people"
//    case Rubrics = "rubrics"
//    case Assignments = "assignments"
//    case Discussions = "discussions"
//    case Grades = "grades"
//    case Quizzes = "quizzes"
//    case Pages = "pages"
//    case Files = "files"
//    case Outcomes = "outcomes"
//    case Conferences = "conferences"
//    case Collaborations = "collaborations"
//    case Other
//}
