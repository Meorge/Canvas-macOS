//
//  User.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/18/21.
//

import Foundation

class User: Decodable, Hashable, ObservableObject {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(sortableName)
        hasher.combine(shortName)
        hasher.combine(loginID)
        hasher.combine(avatarURL)
        hasher.combine(email)
        hasher.combine(locale)
        hasher.combine(lastLogin)
        hasher.combine(timeZone)
        hasher.combine(bio)
    }
    
    @Published var id: Int?
    @Published var name: String?
    @Published var sortableName: String?
    @Published var shortName: String?
    @Published var sisUserID: String?
    @Published var sisImportID: Int?
    @Published var integrationID: String?
    @Published var loginID: String?
    @Published var avatarURL: URL?
    @Published var enrollments: [Enrollment]?
    @Published var email: String?
    @Published var locale: String?
    @Published var lastLogin: Date?
    @Published var timeZone: String?
    @Published var bio: String?
    
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
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try? values.decode(Int?.self, forKey: .id)
        name = try? values.decode(String?.self, forKey: .name)
        sortableName = try? values.decode(String?.self, forKey: .sortableName)
        shortName = try? values.decode(String?.self, forKey: .shortName)
        sisUserID = try? values.decode(String?.self, forKey: .sisUserID)
        sisImportID = try? values.decode(Int?.self, forKey: .sisImportID)
        integrationID = try? values.decode(String?.self, forKey: .integrationID)
        loginID = try? values.decode(String?.self, forKey: .loginID)
        avatarURL = try? values.decode(URL?.self, forKey: .avatarURL)
        enrollments = try? values.decode([Enrollment]?.self, forKey: .enrollments)
        email = try? values.decode(String?.self, forKey: .email)
        locale = try? values.decode(String?.self, forKey: .locale)
        lastLogin = try? values.decode(Date?.self, forKey: .lastLogin)
        timeZone = try? values.decode(String?.self, forKey: .timeZone)
        bio = try? values.decode(String?.self, forKey: .bio)
    }
    
    func getEnrollment(forCourse course: Course) -> Enrollment? {
        let courseID = course.id
        
        let enrollment = enrollments?.filter { $0.courseID == courseID }.first
        return enrollment
    }
}
