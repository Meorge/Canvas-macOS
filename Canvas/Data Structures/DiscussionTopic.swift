//
//  DiscussionTopic.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/17/21.
//

import Foundation

class DiscussionTopic: Identifiable, Decodable, Hashable, ObservableObject {
    static func == (lhs: DiscussionTopic, rhs: DiscussionTopic) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(readState?.rawValue)
    }
    
    @Published var id: Int? = nil
    @Published var title: String? = nil
    @Published var message: String? = nil
    @Published var htmlURL: String? = nil
    @Published var postedAt: Date? = nil
    @Published var lastReplyAt: Date? = nil
    @Published var requireInitialPost: Bool? = nil
    @Published var userCanSeePosts: Bool? = nil
    @Published var discussionSubentryCount: Int? = nil
    @Published var readState: ReadState? = nil
    @Published var unreadCount: Int? = nil
    @Published var subscribed: Bool? = nil
    @Published var subscriptionHold: SubscriptionHoldReason? = nil
    @Published var assignmentID: Int? = nil
    @Published var delayedPostAt: Date? = nil
    @Published var published: Bool? = nil
    @Published var lockAt: Date? = nil
    @Published var locked: Bool? = nil
    @Published var pinned: Bool? = nil
    @Published var lockedForUser: Bool? = nil
    // TODO: lockInfo
    @Published var lockExplanation: String? = nil
    @Published var userName: String? = nil
    // TODO: groupTopicChildren
    // TODO: rootTopicID
    @Published var podcastURL: String? = nil
    @Published var discussionType: DiscussionType? = nil
    @Published var groupCategoryID: Int? = nil
    // TODO: attachments
    // TODO: permissions
    @Published var allowRating: Bool? = nil
    @Published var onlyGradersCanRate: Bool? = nil
    @Published var sortByRating: Bool? = nil
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try? container.decode(Int?.self, forKey: .id)
        title = try? container.decode(String?.self, forKey: .title)
        message = try? container.decode(String?.self, forKey: .message)
        htmlURL = try? container.decode(String?.self, forKey: .htmlURL)
        postedAt = try? container.decode(Date?.self, forKey: .postedAt)
        lastReplyAt = try? container.decode(Date?.self, forKey: .lastReplyAt)
        requireInitialPost = try? container.decode(Bool?.self, forKey: .requireInitialPost)
        userCanSeePosts = try? container.decode(Bool?.self, forKey: .userCanSeePosts)
        discussionSubentryCount = try? container.decode(Int?.self, forKey: .discussionSubentryCount)
        readState = try? container.decode(ReadState?.self, forKey: .readState)
        unreadCount = try? container.decode(Int?.self, forKey: .unreadCount)
        subscribed = try? container.decode(Bool?.self, forKey: .subscribed)
        subscriptionHold = try? container.decode(SubscriptionHoldReason?.self, forKey: .subscriptionHold)
        assignmentID = try? container.decode(Int?.self, forKey: .assignmentID)
        delayedPostAt = try? container.decode(Date?.self, forKey: .delayedPostAt)
        published = try? container.decode(Bool?.self, forKey: .published)
        lockAt = try? container.decode(Date?.self, forKey: .lockAt)
        locked = try? container.decode(Bool?.self, forKey: .locked)
        pinned = try? container.decode(Bool?.self, forKey: .pinned)
        lockedForUser = try? container.decode(Bool?.self, forKey: .lockedForUser)
        lockExplanation = try? container.decode(String?.self, forKey: .lockExplanation)
        userName = try? container.decode(String?.self, forKey: .userName)
        podcastURL = try? container.decode(String?.self, forKey: .podcastURL)
        discussionType = try? container.decode(DiscussionType?.self, forKey: .discussionType)
        groupCategoryID = try? container.decode(Int?.self, forKey: .groupCategoryID)
        allowRating = try? container.decode(Bool?.self, forKey: .allowRating)
        onlyGradersCanRate = try? container.decode(Bool?.self, forKey: .onlyGradersCanRate)
        sortByRating = try? container.decode(Bool?.self, forKey: .sortByRating)
        
        print("\(title!) - \(readState?.rawValue ?? "nil")")
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case message
        case htmlURL = "html_url"
        case postedAt = "posted_at"
        case lastReplyAt = "last_reply_at"
        case requireInitialPost = "require_initial_post"
        case userCanSeePosts = "user_can_see_posts"
        case discussionSubentryCount = "discussion_subentry_count"
        case readState = "read_state"
        case unreadCount = "unread_count"
        case subscribed
        case subscriptionHold = "subscription_hold"
        case assignmentID = "assignment_id"
        case delayedPostAt = "delayed_post_at"
        case published
        case lockAt = "lock_at"
        case locked
        case pinned
        case lockedForUser = "locked_for_user"
        case lockExplanation = "lock_explanation"
        case userName = "user_name"
        case podcastURL = "podcast_url"
        case discussionType = "discussion_type"
        case groupCategoryID = "group_category_id"
        case allowRating = "allow_rating"
        case onlyGradersCanRate = "only_graders_can_rate"
        case sortByRating = "sort_by_rating"
    }
    
}

enum DiscussionType: String, Decodable {
    case SideComment = "side_comment"
    case Threaded = "threaded"
}

enum ReadState: String, Decodable {
    case Read = "read"
    case Unread = "unread"
}

enum SubscriptionHoldReason: String, Decodable {
    case InitialPostRequired = "initial_post_required"
    case NotInGroupSet = "not_in_group_set"
    case NotInGroup = "not_in_group"
    case TopicIsAnnouncement = "topic_is_announcement"
}
