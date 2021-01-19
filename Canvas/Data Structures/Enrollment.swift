//
//  Enrollment.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/17/21.
//

import Foundation
import Combine

class Enrollment: Decodable, Hashable {
    static func == (lhs: Enrollment, rhs: Enrollment) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // TODO: SIS information
    
    var id: Int? = nil
    var courseID: Int? = nil
    var courseSectionID: Int? = nil
    var enrollmentState: EnrollmentState? = nil
    var limitPrivilegesToCourseSection: Bool? = nil
    var rootAccountID: Int? = nil
//    var type: StudentEnrollmentType? = nil
    var userID: Int? = nil
    var associatedUserID: Int? = nil
    var role: StudentEnrollmentType? = nil
    var roleID: Int? = nil
    var createdAt: Date? = nil
    var updatedAt: Date? = nil
    var startAt: Date? = nil
    var endAt: Date? = nil
    var lastActivityAt: Date? = nil
    var lastAttendedAt: Date? = nil
    var totalActivityTime: Int? = nil
    var htmlURL: String? = nil
    // TODO: grades
    // TODO: user
    var computedCurrentGrade: String? = nil
    var computedCurrentScore: Double? = nil
    var computedFinalGrade: String? = nil
    var computedFinalScore: Double? = nil
    var overrideGrade: String? = nil
    var overrideScore: Double? = nil
    // TODO: unpostedCurrentGrade
    // TODO: unpostedFinalGrade
    // TODO: unpostedCurrentScore
    // TODO: unpostedFinalScore
    var hasGradingPeriods: Bool? = nil
    var totalsForAllGradingPeriodsOption: Bool? = nil
    var currentGradingPeriodTitle: String? = nil
    var currentGradingPeriodID: Int? = nil
    var currentPeriodOverrideGrade: String? = nil
    var currentPeriodOverrideScore: Double? = nil
    // TODO: currentPeriodUnpostedCurrentScore
    // TODO: currentPeriodUnpostedFinalScore
    // TODO: currentPeriodUnpostedCurrentGrade
    // TODO: currentPeriodUnpostedFinalGrade
    
//    required init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        
//        id = try? values.decode(Int?.self, forKey: .id)
//        courseID = try? values.decode(Int?.self, forKey: .courseID)
//        courseSectionID = try? values.decode(Int?.self, forKey: .courseSectionID)
//        enrollmentState = try? values.decode(EnrollmentState?.self, forKey: .enrollmentState)
//        limitPrivilegesToCourseSection = try? values.decode(Bool?.self, forKey: .limitPrivilegesToCourseSection)
//        rootAccountID = try? values.decode(Int?.self, forKey: .rootAccountID)
//        type = try? values.decode(StudentEnrollmentType?.self, forKey: .type)
//        userID = try? values.decode(Int?.self, forKey: .userID)
//        associatedUserID = try? values.decode(Int?.self, forKey: .associatedUserID)
//        role = try? values.decode(StudentEnrollmentType?.self, forKey: .role)
//        roleID = try? values.decode(Int?.self, forKey: .roleID)
//        
//        // date stuff
//        let dateFormatter = ISO8601DateFormatter()
//        if let createdAtString = try? values.decode(String?.self, forKey: .createdAt) {
//            createdAt = dateFormatter.date(from: createdAtString)
//        }
//        if let updatedAtString = try? values.decode(String?.self, forKey: .updatedAt) {
//            updatedAt = dateFormatter.date(from: updatedAtString)
//        }
//        if let startAtString = try? values.decode(String?.self, forKey: .startAt) {
//            startAt = dateFormatter.date(from: startAtString)
//        }
//        if let endAtString = try? values.decode(String?.self, forKey: .endAt) {
//            endAt = dateFormatter.date(from: endAtString)
//        }
//        if let lastActivityAtString = try? values.decode(String?.self, forKey: .lastActivityAt) {
//            lastActivityAt = dateFormatter.date(from: lastActivityAtString)
//        }
//        if let lastAttendedAtString = try? values.decode(String?.self, forKey: .lastAttendedAt) {
//            lastAttendedAt = dateFormatter.date(from: lastAttendedAtString)
//        }
//        
//
//        
//        
//        totalActivityTime = try? values.decode(Int?.self, forKey: .totalActivityTime)
//        htmlURL = try? values.decode(String?.self, forKey: .htmlURL)
//        
//        computedCurrentGrade = try? values.decode(String?.self, forKey: .computedCurrentGrade)
//        computedCurrentScore = try? values.decode(Double?.self, forKey: .computedCurrentScore)
//        computedFinalGrade = try? values.decode(String?.self, forKey: .computedFinalGrade)
//        computedFinalScore = try? values.decode(Double?.self, forKey: .computedFinalScore)
//        
//        overrideGrade = try? values.decode(String?.self, forKey: .overrideGrade)
//        overrideScore = try? values.decode(Double?.self, forKey: .overrideScore)
//        
//        hasGradingPeriods = try? values.decode(Bool?.self, forKey: .hasGradingPeriods)
//        totalsForAllGradingPeriodsOption = try? values.decode(Bool?.self, forKey: .totalsForAllGradingPeriodsOption)
//        currentGradingPeriodTitle = try? values.decode(String?.self, forKey: .currentGradingPeriodTitle)
//        currentGradingPeriodID = try? values.decode(Int?.self, forKey: .currentGradingPeriodID)
//        currentPeriodOverrideGrade = try? values.decode(String?.self, forKey: .currentPeriodOverrideGrade)
//        currentPeriodOverrideScore = try? values.decode(Double?.self, forKey: .currentPeriodOverrideScore)
//    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case courseID = "course_id"
        case courseSectionID = "course_section_id"
        case enrollmentState = "enrollment_state"
        case limitPrivilegesToCourseSection = "limit_privileges_to_course_section"
        case rootAccountID = "root_account_id"
//        case type
        case userID = "user_id"
        case associatedUserID = "associated_user_id"
        case role
        case roleID = "role_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case startAt = "start_at"
        case endAt = "end_at"
        case lastActivityAt = "last_activity_at"
        case lastAttendedAt = "last_attended_at"
        case totalActivityTime = "total_activity_time"
        case htmlURL = "html_url"
        case computedCurrentGrade = "computed_current_grade"
        case computedCurrentScore = "computed_current_score"
        case computedFinalGrade = "computed_final_grade"
        case computedFinalScore = "computed_final_score"
        case overrideGrade = "override_grade"
        case overrideScore = "override_score"
        case hasGradingPeriods = "has_grading_periods"
        case totalsForAllGradingPeriodsOption = "totals_for_all_grading_periods_option"
        case currentGradingPeriodTitle = "current_grading_period_title"
        case currentGradingPeriodID = "current_grading_period_id"
        case currentPeriodOverrideGrade = "current_period_override_grade"
        case currentPeriodOverrideScore = "current_period_override_score"
    }
}

enum EnrollmentState: String, Decodable {
    case Inactive = "inactive"
    case Active = "active"
    case Invited = "invited"
}

enum StudentEnrollmentType: String, Decodable {
    case StudentEnrollment = "StudentEnrollment"
    case TeacherEnrollment = "TeacherEnrollment"
    case TaEnrollment = "TaEnrollment"
    case DesignerEnrollment = "DesignerEnrollment"
    case ObserverEnrollment = "ObserverEnrollment"
}
