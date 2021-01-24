//
//  Assignment.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/23/21.
//

import Foundation

class Assignment: Decodable, ObservableObject {
    static func == (lhs: Assignment, rhs: Assignment) -> Bool {
        return lhs.id == rhs.id
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
    @Published var htmlURL: URL?
    @Published var submissionDownloadURL: URL?
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
        case graderNamesVisibleToFinalGraders = "grader_names_visible_to_final_graders"
        case anonymousGrading = "anonymous_grading"
        case allowedAttempts = "allowed_attempts"
        case postManually = "post_manually"
        case scoreStatistics = "score_statistics"
        case canSubmit = "can_submit"
    }
    
    // wow I do not envy you lol
    // - malcolm, 23 jan 2021 at 9:58 pm
    required init(from decoder: Decoder) throws {
        let v = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try? v.decode(Int?.self, forKey: .id)
        name = try? v.decode(String?.self, forKey: .name)
        description = try? v.decode(String?.self, forKey: .description)
        createdAt = try? v.decode(Date?.self, forKey: .createdAt)
        updatedAt = try? v.decode(Date?.self, forKey: .updatedAt)
        dueAt = try? v.decode(Date?.self, forKey: .dueAt)
        lockAt = try? v.decode(Date?.self, forKey: .lockAt)
        unlockAt = try? v.decode(Date?.self, forKey: .unlockAt)
        hasOverrides = try? v.decode(Bool?.self, forKey: .hasOverrides)
        
        courseID = try? v.decode(Int?.self, forKey: .courseID)
        htmlURL = try? v.decode(URL?.self, forKey: .htmlURL)
        submissionDownloadURL = try? v.decode(URL?.self, forKey: .submissionDownloadURL)
        assignmentGroupID = try? v.decode(Int?.self, forKey: .assignmentGroupID)
        dueDateRequired = try? v.decode(Bool?.self, forKey: .dueDateRequired)
        allowedExtensions = try? v.decode([String]?.self, forKey: .allowedExtensions)
        maxNameLength = try? v.decode(Int?.self, forKey: .maxNameLength)
        turnitinEnabled = try? v.decode(Bool?.self, forKey: .turnitinEnabled)
        vericiteEnabled = try? v.decode(Bool?.self, forKey: .vericiteEnabled)
        
        gradeGroupStudentsIndividually = try? v.decode(Bool?.self, forKey: .gradeGroupStudentsIndividually)
        
        peerReviews = try? v.decode(Bool?.self, forKey: .peerReviews)
        automaticPeerReviews = try? v.decode(Bool?.self, forKey: .automaticPeerReviews)
        peerReviewCount = try? v.decode(Int?.self, forKey: .peerReviewCount)
        peerReviewsAssignAt = try? v.decode(Date?.self, forKey: .peerReviewsAssignAt)
        intraGroupPeerReviews = try? v.decode(Bool?.self, forKey: .intraGroupPeerReviews)
        groupCategoryID = try? v.decode(Int?.self, forKey: .groupCategoryID)
        needsGradingCount = try? v.decode(Int?.self, forKey: .needsGradingCount)
        
        position = try? v.decode(Int?.self, forKey: .position)
        postToSIS = try? v.decode(Bool?.self, forKey: .postToSIS)
        integrationID = try? v.decode(String?.self, forKey: .integrationID)
        
        pointsPossible = try? v.decode(Double?.self, forKey: .pointsPossible)
        submissionTypes = try? v.decode([SubmissionType]?.self, forKey: .submissionTypes)
        hasSubmittedSubmissions = try? v.decode(Bool?.self, forKey: .hasSubmittedSubmissions)
        gradingType = try? v.decode(GradingType?.self, forKey: .gradingType)
        
        published = try? v.decode(Bool?.self, forKey: .published)
        unpublishable = try? v.decode(Bool?.self, forKey: .unpublishable)
        onlyVisibleToOverrides = try? v.decode(Bool?.self, forKey: .onlyVisibleToOverrides)
        lockedForUser = try? v.decode(Bool?.self, forKey: .lockedForUser)
        
        lockExplanation = try? v.decode(String?.self, forKey: .lockExplanation)
        quizID = try? v.decode(Int?.self, forKey: .quizID)
        anonymousSubmissions = try? v.decode(Bool?.self, forKey: .anonymousSubmissions)
        discussionTopic = try? v.decode(DiscussionTopic?.self, forKey: .discussionTopic)
        freezeOnCopy = try? v.decode(Bool?.self, forKey: .freezeOnCopy)
        frozen = try? v.decode(Bool?.self, forKey: .frozen)
        
        submission = try? v.decode(Submission?.self, forKey: .submission)
        useRubricForGrading = try? v.decode(Bool?.self, forKey: .useRubricForGrading)
        
        
        assignmentVisibility = try? v.decode([Int]?.self, forKey: .assignmentVisibility)
        
        omitFromFinalGrade = try? v.decode(Bool?.self, forKey: .omitFromFinalGrade)
        moderatedGrading = try? v.decode(Bool?.self, forKey: .moderatedGrading)
        graderCount = try? v.decode(Int?.self, forKey: .graderCount)
        finalGraderID = try? v.decode(Int?.self, forKey: .finalGraderID)
        graderCommentsVisibleToGraders = try? v.decode(Bool?.self, forKey: .graderCommentsVisibleToGraders)
        gradersAnonymousToGraders = try? v.decode(Bool?.self, forKey: .gradersAnonymousToGarders)
        graderNamesVisibleToFinalGraders = try? v.decode(Bool?.self, forKey: .graderNamesVisibleToFinalGraders)
        anonymousGrading = try? v.decode(Bool?.self, forKey: .anonymousGrading)
        allowedAttempts = try? v.decode(Int?.self, forKey: .allowedAttempts)
        postManually = try? v.decode(Bool?.self, forKey: .postManually)
        scoreStatistics = try? v.decode(ScoreStatistic?.self, forKey: .scoreStatistics)
        canSubmit = try? v.decode(Bool?.self, forKey: .canSubmit)
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
    
    enum CodingKeys: String, CodingKey {
        case assignmentID = "assignment_id"
        
        case attempt
        case body
        case grade
        case gradeMatchesCurrentSubmission = "grade_matches_current_submission"
        case htmlURL = "html_url"
        case previewURL = "preview_url"
        case score
        case submissionComments = "submission_comments"
        case submissionType = "submission_type"
        case submittedAt = "submitted_at"
        case url
        case userID = "user_id"
        case graderID = "grader_id"
        case gradedAt = "graded_at"
        case late
        case assignmentVisible = "assignment_visible"
        case excused
        case missing
        case latePolicyStatus = "late_policy_status"
        case pointsDeducted = "points_deducted"
        case secondsLate = "seconds_late"
        case workflowState = "workflow_state"
        case extraAttempts = "extra_attempts"
        case anonymousID = "anonymous_id"
        case postedAt = "posted_at"
    }
    
    required init(from decoder: Decoder) throws {
        let v = try decoder.container(keyedBy: CodingKeys.self)
        
        assignmentID = try? v.decode(Int?.self, forKey: .assignmentID)
        attempt = try? v.decode(Int?.self, forKey: .attempt)
        body = try? v.decode(String?.self, forKey: .body)
        grade = try? v.decode(String?.self, forKey: .grade)
        gradeMatchesCurrentSubmission = try? v.decode(Bool?.self, forKey: .gradeMatchesCurrentSubmission)
        htmlURL = try? v.decode(URL?.self, forKey: .htmlURL)
        previewURL = try? v.decode(URL?.self, forKey: .previewURL)
        score = try? v.decode(Double?.self, forKey: .score)
        submissionComments = try? v.decode([SubmissionComment]?.self, forKey: .submissionComments)
        submissionType = try? v.decode(SubmissionType?.self, forKey: .submissionType)
        submittedAt = try? v.decode(Date?.self, forKey: .submittedAt)
        url = try? v.decode(URL?.self, forKey: .url)
        userID = try? v.decode(Int?.self, forKey: .userID)
        graderID = try? v.decode(Int?.self, forKey: .graderID)
        gradedAt = try? v.decode(Date?.self, forKey: .gradedAt)
        late = try? v.decode(Bool?.self, forKey: .late)
        assignmentVisible = try? v.decode(Bool?.self, forKey: .assignmentVisible)
        excused = try? v.decode(Bool?.self, forKey: .excused)
        missing = try? v.decode(Bool?.self, forKey: .missing)
        latePolicyStatus = try? v.decode(LatePolicyStatus?.self, forKey: .latePolicyStatus)
        pointsDeducted = try? v.decode(Double?.self, forKey: .pointsDeducted)
        secondsLate = try? v.decode(Double?.self, forKey: .secondsLate)
        workflowState = try? v.decode(String?.self, forKey: .workflowState)
        extraAttempts = try? v.decode(Int?.self, forKey: .extraAttempts)
        anonymousID = try? v.decode(String?.self, forKey: .anonymousID)
        postedAt = try? v.decode(Date?.self, forKey: .postedAt)
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
