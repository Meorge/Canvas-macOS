//
//  Course.swift
//  Canvas
//
//  Created by Test Account on 9/26/20.
//

import Foundation
import Combine

class Course: Decodable, Hashable, ObservableObject {
    static func == (lhs: Course, rhs: Course) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
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
    
    @Published var modules: [Module] = []
    
    // Not updating to show read status...
    // Maybe it's because the same elements (same ID, etc) are here
    // even though they have different properties?
    // If I switch to another view first, though, it updates correctly...
    @Published var announcements: [DiscussionTopic] = [] {
        didSet {
            self.unreadAnnouncements = self.announcements.filter { $0.readState! == .Unread }.count
            print("\(self.name!) has \(self.unreadAnnouncements) unread announcements")
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
    }
    
    func update() {
        updateModules()
        updatePeople()
        updateAnnouncements()
    }
    
    func updateModules() {
        CanvasAPI.instance?.getModules(forCourse: self) { data in
            self.modules = data.value!
            
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
            let newAnnouncements = data.value!
            
            self.announcements = newAnnouncements
            
            self.objectWillChange.send()
        }
    }
    
    func updatePeople() {
        CanvasAPI.instance?.getUsers(forCourse: self) { data in
            self.people = data.value!
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
