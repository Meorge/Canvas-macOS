//
//  CourseLike.swift
//  Canvas
//
//  Created by Malcolm Anderson on 2/13/21.
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
        return discussionTopicsNotifications + announcementNotifications
    }
    
    var discussionTopicsNotifications: Int {
        var total = 0
        
        // Unread count from discussion topics
        for topic in discussionTopics {
            if topic.subscribed ?? false {
                total += topic.unreadCount ?? 0
            }
        }
        
        return total
    }
    
    var announcementNotifications: Int {
        var total = 0
        
        // Unread count from announcements
        for announcement in announcements {
            total += announcement.unreadCount ?? 0
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
