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
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let name: String?
    let id: Int?
    let courseCode: String?
    let accountID: Int?
    
    @Published var modules: [Module] = []
    @Published var announcements: [DiscussionTopic] = []
    @Published var people: [User] = []
    var enrollments: [Enrollment]? = []
    
    
    // Updating statuses
    @Published var updatingModules: Bool = false
    @Published var updatingAnnouncements: Bool = false
    @Published var updatingPeople: Bool = false

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
        self.updatingModules = true
        CanvasAPI.instance?.getModules(forCourse: self) { data in
            self.modules = data.value!
            
            for module in self.modules {
                module.course = self
                module.updateModuleItems()
            }
            
            self.updatingModules = false
            
            // its hacky but It Works
//            CanvasAPI.instance?.objectWillChange.send()
            
            
        }
    }
    
    func updateAnnouncements() {
        self.updatingAnnouncements = true
        CanvasAPI.instance?.getAnnouncements(forCourse: self) { data in
            self.announcements = data.value!
            self.updatingAnnouncements = false
//            CanvasAPI.instance?.objectWillChange.send()
        }
    }
    
    func updatePeople() {
        self.updatingPeople = true
//        print("self.updatingPeople for \(self.name!) = \(self.updatingPeople)")
        CanvasAPI.instance?.getUsers(forCourse: self) { data in
            self.people = data.value!
            self.updatingPeople = false
//            CanvasAPI.instance?.objectWillChange.send()
//            print("self.updatingPeople for \(self.name!) = \(self.updatingPeople)")
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
