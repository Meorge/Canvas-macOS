//
//  Course.swift
//  Canvas
//
//  Created by Test Account on 9/26/20.
//

import Foundation

struct Course: Decodable, Hashable {
    let name: String
    let id: Int
    let courseCode: String
    let accountID: Int
    
    var modules: [Module]?

    enum CodingKeys: String, CodingKey {
        case name
        case id
        case courseCode = "course_code"
        case accountID = "account_id"
    }
    
    mutating func updateModules() {
        print("update modules for \(name)")
        self.modules = CanvasAPI.instance?.getModules(forCourse: self)
    }
}
