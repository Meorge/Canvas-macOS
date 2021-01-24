//
//  Assignment.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/23/21.
//

import Foundation

class Assignment: Decodable, Hashable, ObservableObject {
    static func == (lhs: Assignment, rhs: Assignment) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    @Published var id: Int?
    @Published var name: String?
    @Published var description: String?
    @Published var createdAt: Date?
    @Published var updatedAt: Date?
    @Published var dueAt: Date?
    @Published var lockAt: Date?
    @Published var unlockAt: Date?
    @Published var hasOverrides: Bool?
    // todo: allDates (type unknown)
    @Published var courseID: Int?
    @Published var htmlURL: String?
    @Published var submissionDownloadURL: String?
    @Published var assignmentGroupID: Int?
    @Published var dueDateRequired: Bool?
    @Published var allowedExtensions: [String]?
    @Published var maxNameLength: Int?
    @Published var turnitinEnabled: Bool? = false
    @Published var vericiteEnabled: Bool? = false
    // todo: turnitinSettings
    @Published var gradeGroupStudentsIndividually: Bool? = false
    // todo: externalToolTagAttributes
    @Published var peerReviews: Bool?
    @Published var automaticPeerReviews: Bool?
    @Published var peerReviewCount: Int? = 0
    @Published var peerReviewsAssignAt: Date? = nil
    @Published var intraGroupPeerReviews: Bool?
    @Published var groupCategoryID: Int?
    @Published var needsGradingCount: Int?
    // todo: needsGradingCountBySection
    @Published var position: Int? = 0
    @Published var postToSIS: Bool?
    @Published var integrationID: String?
    // todo: integrationData
    @Published var pointsPossible: Double?
    @Published var submissionTypes: [SubmissionType]?
    @Published var hasSubmittedSubmissions: Bool?
    @Published var gradingType: GradingType?
    // todo: gradingStandardID
    @Published var published: Bool?
    @Published var unpublishable: Bool?
    @Published var onlyVisibleToOverrides: Bool?
    @Published var lockedForUser: Bool?
    // todo: lockInfo
    @Published var lockExplanation: String?
    @Published var quizID: Int?
    @Published var anonymousSubmissions: Bool?
    @Published var discussionTopic: DiscussionTopic?
    @Published var freezeOnCopy: Bool?
    @Published var frozen: Bool?
    // todo: frozenAttributes
    @Published var submission: Submission?
    @Published var useRubricForGrading: Bool?
    // todo: rubricSettings
    // todo: rubric
    @Published var assignmentVisibility: [Int]?
    // todo: overrides
    @Published var omitFromFinalGrade: Bool?
    @Published var moderatedGrading: Bool?
    @Published var graderCount: Int?
    @Published var finalGraderID: Int?
    @Published var graderCommentsVisibleToGraders: Bool?
    @Published var gradersAnonymousToGraders: Bool?
    @Published var graderNamesVisibleToFinalGraders: Bool?
    @Published var anonymousGrading: Bool?
    @Published var allowedAttempts: Int?
    @Published var postManually: Bool?
    @Published var scoreStatistics: ScoreStatistic?
    @Published var canSubmit: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case dueAt = "due_at"
        case lockAt = "lock_at"
        case unlockAt = "unlock_at"
        case hasOverrides = "has_overrides"
        case courseID = "course_id"
        case htmlURL = "html_url"
        case submissionDownloadURL = "submission_download_url"
        case assignmentGroupID = "assignment_group_id"
        case dueDateRequired = "due_date_required"
        case allowedExtensions = "allowed_extensions"
        case maxNameLength = "max_name_length"
        case turnitinEnabled = "turnitin_enabled"
        case vericiteEnabled = "vericite_enabled"
        
        case gradeGroupStudentsIndividually = "grade_group_students_individually"
        case peerReviews = "peer_reviews"
        case automaticPeerReviews = "automatic_peer_reviews"
        case peerReviewCount = "peer_review_count"
        case peerReviewsAssignAt = "peer_reviews_assign_at"
        case intraGroupPeerReviews = "intra_group_peer_reviews"
        case groupCategoryID = "group_category_id"
        case needsGradingCount = "needs_grading_count"
        case position
        case postToSIS = "post_to_sis"
        case integrationID = "integration_id"
        
        case pointsPossible = "points_possible"
        case submissionTypes = "submission_types"
        case hasSubmittedSubmissions = "has_submitted_submissions"
        case gradingType = "grading_type"
        
        case published
        case unpublishable
        case onlyVisibleToOverrides = "only_visible_to_overrides"
        case lockedForUser = "locked_for_user"
        
        case lockExplanation = "lock_explanation"
        case quizID = "quiz_id"
        case anonymousSubmissions = "anonymous_submissions"
        case discussionTopic = "discussion_topic"
        case freezeOnCopy = "freeze_on_copy"
        case frozen
        
        case submission
        case useRubricForGrading = "use_rubric_for_grading"
        
        
        case assignmentVisibility = "assignment_visibility"
        
        case omitFromFinalGrade = "omit_from_final_grade"
        case moderatedGrading = "moderated_grading"
        case graderCount = "grader_count"
        case finalGraderID = "final_grader_id"
        case graderCommentsVisibleToGraders = "grader_comments_visible_to_graders"
        case gradersAnonymousToGarders = "graders_anonymous_to_graders"
        case anonymousGrading = "anonymous_grading"
        case allowedAttempts = "allowed_attempts"
        case postManually = "post_manually"
        case scoreStatistics = "score_statistics"
        case canSubmit = "can_submit"
    }
    
    // wow I do not envy you lol
    // - malcolm, 23 jan 2021 at 9:58 pm
    required init(from decoder: Decoder) throws {
        <#code#>
    }
}

class Submission: Decodable, ObservableObject {
    @Published var assignmentID: Int?
    // todo: assignment
    // todo: course
    @Published var attempt: Int?
    @Published var body: String?
    @Published var grade: String?
    @Published var gradeMatchesCurrentSubmission: Bool?
    @Published var htmlURL: URL?
    @Published var previewURL: URL?
    @Published var score: Double?
    @Published var submissionComments: [SubmissionComment]?
    @Published var submissionType: SubmissionType?
    @Published var submittedAt: Date?
    @Published var url: URL?
    @Published var userID: Int?
    @Published var graderID: Int?
    @Published var gradedAt: Date?
    @Published var late: Bool?
    @Published var assignmentVisible: Bool?
    @Published var excused: Bool?
    @Published var missing: Bool?
    @Published var latePolicyStatus: LatePolicyStatus?
    @Published var pointsDeducted: Double?
    @Published var secondsLate: Double?
    @Published var workflowState: String?
    @Published var extraAttempts: Int?
    @Published var anonymousID: String?
    @Published var postedAt: Date?
    
    // TODO: Finish this! and the init!
    enum CodingKeys: String, CodingKey {
        case assignmentID = "assignment_id"
    }
    
}

class SubmissionComment: Decodable, ObservableObject {
    @Published var id: Int?
    @Published var authorID: Int?
    @Published var authorName: String?
    // todo: author (UserDisplay)
    @Published var comment: String?
    @Published var createdAt: Date?
    @Published var editedAt: Date?
    @Published var mediaComment: MediaComment?
    
    enum CodingKeys: String, CodingKey {
        case id
        case authorID = "author_id"
        case authorName = "author_name"
        case comment
        case createdAt = "created_at"
        case editedAt = "edited_at"
        case mediaComment = "media_comment"
    }
    
    required init(from decoder: Decoder) throws {
        let v = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try? v.decode(Int?.self, forKey: .id)
        authorID = try? v.decode(Int?.self, forKey: .authorID)
        authorName = try? v.decode(String?.self, forKey: .authorName)
        comment = try? v.decode(String?.self, forKey: .comment)
        createdAt = try? v.decode(Date?.self, forKey: .createdAt)
        editedAt = try? v.decode(Date?.self, forKey: .editedAt)
        mediaComment = try? v.decode(MediaComment?.self, forKey: .mediaComment)
    }
}

class MediaComment: Decodable, ObservableObject {
    @Published var contentType: String?
    @Published var displayName: String?
    @Published var mediaID: String?
    @Published var mediaType: String?
    @Published var url: URL?
    
    enum CodingKeys: String, CodingKey {
        case contentType = "content_type"
        case displayName = "display_name"
        case mediaID = "media_id"
        case mediaType = "media_type"
        case url
    }
    
    required init(from decoder: Decoder) throws {
        let v = try decoder.container(keyedBy: CodingKeys.self)
        
        contentType = try? v.decode(String?.self, forKey: .contentType)
        displayName = try? v.decode(String?.self, forKey: .displayName)
        mediaID = try? v.decode(String?.self, forKey: .mediaID)
        mediaType = try? v.decode(String?.self, forKey: .mediaType)
        url = try? v.decode(URL?.self, forKey: .url)
    }
}

class ScoreStatistic: Decodable, ObservableObject {
    @Published var min: Double?
    @Published var max: Double?
    @Published var mean: Double?
    
    enum CodingKeys: String, CodingKey {
        case min
        case max
        case mean
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        min = try? values.decode(Double?.self, forKey: .min)
        max = try? values.decode(Double?.self, forKey: .max)
        mean = try? values.decode(Double?.self, forKey: .mean)
    }
}

enum LatePolicyStatus: String, Decodable {
    case Late = "late"
    case Missing = "missing"
    case None = "none"
}

enum SubmissionType: String, Decodable {
    case DiscussionTopic = "discussion_topic"
    case OnlineQuiz = "online_quiz"
    case OnPaper = "on_paper"
    case None = "none"
    case ExternalTool = "external_tool"
    case OnlineTextEntry = "online_text_entry"
    case OnlineURL = "online_url"
    case OnlineUpload = "online_upload"
    case MediaRecording = "media_recording"
}

enum GradingType: String, Decodable {
    case PassFail = "pass_fail"
    case Percent = "percent"
    case LetterGrade = "letter_grade"
    case GPAScale = "gpa_scale"
    case Points = "points"
}
