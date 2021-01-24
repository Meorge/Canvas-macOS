//
//  Course.swift
//  Canvas
//
//  Created by Test Account on 9/26/20.
//

import Foundation
import Combine
import SwiftUI

class Course: Decodable, Hashable, ObservableObject {
    static func == (lhs: Course, rhs: Course) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
//        hasher.combine(unreadAnnouncements)
//        hasher.combine(announcements.hashValue)
//        hasher.combine(modules)
//        hasher.combine(announcements)
//        hasher.combine(people)
    }
    
    @Published var name: String?
    @Published var id: Int?
    @Published var courseCode: String?
    @Published var accountID: Int?
    @Published var defaultView: String?
    
    @Published var courseColor: Color? = Color.accentColor
    @Published var courseIcon: String? = ""
    
    @Published var tabs: [Tab] = []
    @Published var modules: [Module] = []
    @Published var announcements: [DiscussionTopic] = [] {
        didSet {
            self.unreadAnnouncements = self.announcements.filter { $0.readState! == .Unread }.count
            self.objectWillChange.send()
        }
    }
    
    @Published var unreadAnnouncements: Int = 0
    
    @Published var people: [User] = []
    var enrollments: [Enrollment]? = []
    
    @Published var assignmentGroups: [AssignmentGroup]? = []
    @Published var assignments: [Assignment]? = []

    enum CodingKeys: String, CodingKey {
        case name
        case id
        case courseCode = "course_code"
        case accountID = "account_id"
        case enrollments
        case defaultView = "default_view"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        name = try? values.decode(String?.self, forKey: .name)
        id = try? values.decode(Int?.self, forKey: .id)
        courseCode = try? values.decode(String?.self, forKey: .courseCode)
        accountID = try? values.decode(Int?.self, forKey: .accountID)
        enrollments = try? values.decode([Enrollment]?.self, forKey: .enrollments)
        defaultView = try? values.decode(String?.self, forKey: .defaultView)

    }
    
    func update() {
        updateCourseIcon()
        updateCourseColor()
        updateTabs()
        updateModules()
        updatePeople()
        updateAnnouncements()
        
        updateAssignments()
        updateAssignmentGroups()
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
    
    func updateTabs() {
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
            
            // its hacky but It Works
//            CanvasAPI.instance?.objectWillChange.send()
        }
    }
    
    func updateAnnouncements() {
        Manager.instance?.canvasAPI.getAnnouncements(forCourse: self) { data in
            let newAnnouncements = data.value ?? []
            
            self.announcements = newAnnouncements
            
            self.objectWillChange.send()
        }
    }
    
    func updatePeople() {
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
