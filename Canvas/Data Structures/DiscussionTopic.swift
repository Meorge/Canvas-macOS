//
//  DiscussionTopic.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/17/21.
//

import Foundation

class DiscussionTopic: Decodable, Hashable, ObservableObject {
    static func == (lhs: DiscussionTopic, rhs: DiscussionTopic) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: Int? = nil
    var title: String? = nil
    var message: String? = nil
    var htmlURL: String? = nil
    var postedAt: Date? = nil
    var lastReplyAt: Date? = nil
    var requireInitialPost: Bool? = nil
    var userCanSeePosts: Bool? = nil
    var discussionSubentryCount: Int? = nil
    var readState: ReadState? = nil
    var unreadCount: Int? = nil
    var subscribed: Bool? = nil
    var subscriptionHold: SubscriptionHoldReason? = nil
    var assignmentID: Int? = nil
    var delayedPostAt: Date? = nil
    var published: Bool? = nil
    var lockAt: Date? = nil
    var locked: Bool? = nil
    var pinned: Bool? = nil
    var lockedForUser: Bool? = nil
    // TODO: lockInfo
    var lockExplanation: String? = nil
    var userName: String? = nil
    // TODO: groupTopicChildren
    // TODO: rootTopicID
    var podcastURL: String? = nil
    var discussionType: DiscussionType? = nil
    var groupCategoryID: Int? = nil
    // TODO: attachments
    // TODO: permissions
    var allowRating: Bool? = nil
    var onlyGradersCanRate: Bool? = nil
    var sortByRating: Bool? = nil
    
    
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
