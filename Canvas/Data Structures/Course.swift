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
    var enrollments: [Enrollment] = []

    enum CodingKeys: String, CodingKey {
        case name
        case id
        case courseCode = "course_code"
        case accountID = "account_id"
        case enrollments
    }
    
    func updateModules() {
        CanvasAPI.instance?.getModules(forCourse: self) { data in
            self.modules = data.value!
            
            for module in self.modules {
                module.course = self
                module.updateModuleItems()
            }
//            self.objectWillChange.send()
            
            // its hacky but It Works
            CanvasAPI.instance?.objectWillChange.send()
        }
    }
    
    func getScoreAsString() -> String? {
        if enrollments.count <= 0 {
            return nil
        }
        
        let myEnrollment = enrollments[0]
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
