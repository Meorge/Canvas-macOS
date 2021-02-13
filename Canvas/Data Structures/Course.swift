//
//  Course.swift
//  Canvas
//
//  Created by Test Account on 9/26/20.
//

import Foundation
import Combine
import SwiftUI

class Course: CourseLike {
    @Published var courseCode: String?
    @Published var accountID: Int?
    
    
    @Published var courseColor: Color? = Color.accentColor
    @Published var courseIcon: String? = "book"

    @Published var modules: [Module] = []
    
    
    var enrollments: [Enrollment]? = []
    
    @Published var assignmentGroups: [AssignmentGroup]? = []
    @Published var assignments: [Assignment]? = []

    enum CodingKeys: String, CodingKey {
        case courseCode = "course_code"
        case accountID = "account_id"
        case enrollments
        case defaultView = "default_view"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)

        courseCode = try? values.decode(String?.self, forKey: .courseCode)
        accountID = try? values.decode(Int?.self, forKey: .accountID)
        enrollments = try? values.decode([Enrollment]?.self, forKey: .enrollments)
        defaultView = try? values.decode(String?.self, forKey: .defaultView)

    }
    
    override func updateTopLevel() {
        updateTabs()
        updateCourseColor()
        updateCourseIcon()
        updateStreamSummary()
//        updateAnnouncements()
    }
    
    func update() {
        updateTopLevel()
        updateTabs()
        updateModules()
        updatePeople()
        updateAnnouncements()
        updateDiscussionTopics()
        
        updateAssignments()
        updateAssignmentGroups()
    }
    
    override func updateStreamSummary() {
        Manager.instance?.canvasAPI.getCourseStreamSummary(forCourse: self) { result in
            self.streamSummary = result.value ?? []
        }
    }
    
    func updateCourseIcon() {
        Manager.instance?.canvasAPI.getCourseIcon(forCourse: self) { result in
            let ico = Manager.instance?.canvasAPI.courseIconData.data["\(self.id!)"]
            self.courseIcon = ico
        }
    }
    
    func updateCourseColor() {
        Manager.instance?.canvasAPI.getCourseColor(forCourse: self) { result in
            self.courseColor = (result.value ?? CustomColor()).asColor
        }
    }
    
    override func updateTabs() {
        Manager.instance?.canvasAPI.getCourseTabs(forCourse: self) { result in
            self.tabs = result.value ?? []
        }
    }
    func updateModules() {
        Manager.instance?.canvasAPI.getModules(forCourse: self) { data in
            self.modules = data.value ?? []
            
            for module in self.modules {
                module.course = self
                module.updateModuleItems()
            }
        }
    }
    
    override func updateAnnouncements() {
        Manager.instance?.canvasAPI.getAnnouncements(forCourse: self) { data in
            let newAnnouncements = data.value ?? []
            
            self.announcements = newAnnouncements
            
            self.objectWillChange.send()
        }
    }
    
    override func updateDiscussionTopics() {
        Manager.instance?.canvasAPI.getDiscussionTopics(forCourse: self) { data in
            self.discussionTopics = data.value ?? []
        }
    }
    
    override func updatePeople() {
        Manager.instance?.canvasAPI.getUsers(forCourse: self) { data in
            self.people = data.value ?? []
        }
    }
    
    func updateAssignments() {
        Manager.instance?.canvasAPI.getAssignments(forCourse: self) { data in
            self.assignments = data.value ?? []
        }
    }
    
    func updateAssignmentGroups() {
        Manager.instance?.canvasAPI.getAssignmentGroups(forCourse: self) { data in
            self.assignmentGroups = data.value ?? []
        }
    }
    
    func getScoreAsString() -> String? {
        if enrollments == nil { return "" }
        
        if enrollments!.count <= 0 {
            return ""
        }
        
        let myEnrollment = enrollments![0]
        let percent = myEnrollment.computedCurrentScore
        let grade = myEnrollment.computedCurrentGrade
        
        if percent == nil && grade == nil {
            return "N/A"
        }
        
        if grade == nil {
            return "\(percent!)%"
        }
        
        if percent == nil {
            return "\(grade!)"
        }
        
        return "\(percent!)% - \(grade!)"
    }
}

class CourseNickname: Decodable, Hashable {
    static func == (lhs: CourseNickname, rhs: CourseNickname) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(courseID)
    }
    
    var courseID: Int? = nil
    var name: String? = nil
    var nickname: String? = nil
}

class ActivityStreamSummaryItem: Decodable, Identifiable, ObservableObject {
    
    @Published var type: ActivityStreamItemType?
    @Published var unreadCount: Int?
    @Published var count: Int?
    
    enum CodingKeys: String, CodingKey {
        case type
        case notificationCategory = "notification_category"
        case unreadCount = "unread_count"
        case count
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try? values.decode(ActivityStreamItemType.self, forKey: .type)
        unreadCount = try? values.decode(Int.self, forKey: .unreadCount)
        count = try? values.decode(Int.self, forKey: .count)
    }
}

enum ActivityStreamItemType: String, Decodable {
    case DiscussionTopic
    case Announcement
    case Conversation
    case Message
    case Submission
    case Conference
    case Collaboration
    case AssessmentRequest
}
