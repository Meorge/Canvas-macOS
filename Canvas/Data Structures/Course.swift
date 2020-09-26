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

    enum CodingKeys: String, CodingKey {
        case name
        case id
        case courseCode = "course_code"
        case accountID = "account_id"
    }
    
    func updateModules() {
        print("update modules for \(name)")
        CanvasAPI.instance?.getModules(forCourse: self) { data in
            self.modules = data.value!
            print("course.modules = \(self.modules)")
            print("The modules were updated successfully!")
            self.objectWillChange.send()
            
            // its hacky but It Works
            CanvasAPI.instance?.objectWillChange.send()
        }
    }
}