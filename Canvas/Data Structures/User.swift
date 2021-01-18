//
//  User.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/18/21.
//

import Foundation

class User: Decodable, Hashable, ObservableObject {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: Int?
    var name: String?
    var sortableName: String?
    var shortName: String?
    var sisUserID: String?
    var sisImportID: Int?
    var integrationID: String?
    var loginID: String?
    var avatarURL: URL?
    var enrollments: [Enrollment]?
    var email: String?
    var locale: String?
    var lastLogin: Date?
    var timeZone: String?
    var bio: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sortableName = "sortable_name"
        case shortName = "short_name"
        case sisUserID = "sis_user_id"
        case sisImportID = "sis_import_id"
        case integrationID = "integration_id"
        case loginID = "login_id"
        case avatarURL = "avatar_url"
        case enrollments
        case email
        case locale
        case lastLogin = "last_login"
        case timeZone = "time_zone"
        case bio
    }
    
    func getEnrollment(forCourse course: Course) -> Enrollment? {
        let courseID = course.id
        
        let enrollment = enrollments?.filter { $0.courseID == courseID }.first
        return enrollment
    }
}
