//
//  Group.swift
//  Canvas
//
//  Created by Malcolm Anderson on 2/12/21.
//

import Foundation

class CanvasGroup: CourseLike {
    @Published var description: String? = nil
    @Published var isPublic: Bool? = nil
    @Published var followedByUser: Bool? = nil
    @Published var joinLevel: GroupJoinLevel? = nil
    @Published var membersCount: Int? = nil
    @Published var avatarURL: URL? = nil
    @Published var contextType: GroupContext? = nil
    @Published var courseID: Int? = nil
    @Published var accountID: Int? = nil
    @Published var role: GroupRole? = nil
    @Published var groupCategoryID: Int? = nil
    @Published var sisGroupID: String? = nil
    @Published var sisImportID: Int? = nil
    @Published var storageQuotaMB: Int? = nil
    @Published var permissions: GroupPermissions? = nil
    
    enum CodingKeys: String, CodingKey {
        case description
        case isPublic = "is_public"
        case followedByUser = "followed_by_user"
        case joinLevel = "join_level"
        case membersCount = "members_count"
        case avatarURL = "avatar_url"
        case contextType = "context_type"
        case courseID = "course_id"
        case accountID = "account_id"
        case role
        case groupCategoryID = "group_category_id"
        case sisGroupID = "sis_group_id"
        case sisImportID = "sis_import_id"
        case storageQuotaMB = "storage_quota_mb"
        case permissions
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let c = try decoder.container(keyedBy: CodingKeys.self)
        
        description = try? c.decode(String?.self, forKey: .description)
        isPublic = try? c.decode(Bool?.self, forKey: .isPublic)
        followedByUser = try? c.decode(Bool?.self, forKey: .followedByUser)
        joinLevel = try? c.decode(GroupJoinLevel?.self, forKey: .joinLevel)
        membersCount = try? c.decode(Int?.self, forKey: .membersCount)
        avatarURL = try? c.decode(URL?.self, forKey: .avatarURL)
        contextType = try? c.decode(GroupContext?.self, forKey: .contextType)
        courseID = try? c.decode(Int?.self, forKey: .courseID)
        accountID = try? c.decode(Int?.self, forKey: .accountID)
        role = try? c.decode(GroupRole?.self, forKey: .role)
        groupCategoryID = try? c.decode(Int?.self, forKey: .groupCategoryID)
        sisGroupID = try? c.decode(String?.self, forKey: .sisGroupID)
        sisImportID = try? c.decode(Int?.self, forKey: .sisImportID)
        storageQuotaMB = try? c.decode(Int?.self, forKey: .storageQuotaMB)
        permissions = try? c.decode(GroupPermissions?.self, forKey: .permissions)
        
        print(permissions)
    }
    
    override func updateTopLevel() {
        updateTabs()
        updateStreamSummary()
        updateAnnouncements()
        updateDiscussionTopics()
    }
    
    override func updateTabs() {
        Manager.instance?.canvasAPI.getGroupTabs(forGroup: self) { result in
            self.tabs = result.value ?? []
        }
    }
    
    override func updateDiscussionTopics() {
        Manager.instance?.canvasAPI.getDiscussionTopics(forGroup: self) { data in
            self.discussionTopics = data.value ?? []
        }
    }
    
    override func updatePeople() {
        Manager.instance?.canvasAPI.getUsers(forGroup: self) { data in
            self.people = data.value ?? []
        }
    }
    
    override func updateStreamSummary() {
        Manager.instance?.canvasAPI.getGroupStreamSummary(forGroup: self) { result in
            self.streamSummary = result.value ?? []
        }
    }
}

class GroupPermissions: Decodable {
    var createDiscussionTopic: Bool? = nil
    var createAnnouncement: Bool? = nil
    
    enum CodingKeys: String, CodingKey {
        case createDiscussionTopic = "create_discussion_topic"
        case createAnnouncement = "create_announcement"
    }
}

enum GroupJoinLevel: String, Decodable {
    case ParentContextAutoJoin = "parent_context_auto_join"
    case ParentContextRequest = "parent_context_request"
    case InvitationOnly = "invitation_only"
}

enum GroupContext: String, Decodable {
    case Account
    case Course
}

enum GroupRole: String, Decodable {
    case Communities = "communities"
    case StudentOrganized = "student_organized"
    case Imported = "imported"
}
