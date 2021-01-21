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
    
    let name: String?
    let id: Int?
    let courseCode: String?
    let accountID: Int?
    let defaultView: String?
    
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

    enum CodingKeys: String, CodingKey {
        case name
        case id
        case courseCode = "course_code"
        case accountID = "account_id"
        case enrollments
        case defaultView = "default_view"
    }
    
    func update() {
        updateCourseIcon()
        updateCourseColor()
        updateTabs()
        updateModules()
        updatePeople()
        updateAnnouncements()
    }
    
    func updateCourseIcon() {
        CanvasAPI.instance!.getCourseIcon(forCourse: self) { result in
            let ico = CanvasAPI.instance!.courseIconData.data["\(self.id!)"]
            self.courseIcon = ico
        }
    }
    
    func updateCourseColor() {
        CanvasAPI.instance!.getCourseColor(forCourse: self) { result in
            self.courseColor = (result.value ?? CustomColor()).asColor
        }
    }
    
    func updateTabs() {
        CanvasAPI.instance!.getCourseTabs(forCourse: self) { result in
            self.tabs = result.value ?? []
        }
    }
    func updateModules() {
        CanvasAPI.instance?.getModules(forCourse: self) { data in
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
        CanvasAPI.instance?.getAnnouncements(forCourse: self) { data in
            let newAnnouncements = data.value ?? []
            
            self.announcements = newAnnouncements
            
            self.objectWillChange.send()
        }
    }
    
    func updatePeople() {
        CanvasAPI.instance?.getUsers(forCourse: self) { data in
            self.people = data.value ?? []
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
