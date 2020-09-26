//
//  CanvasAPI.swift
//  Canvas
//
//  Created by Test Account on 9/26/20.
//

import Foundation
import Alamofire

class CanvasAPI: ObservableObject {
    static var instance: CanvasAPI? = nil
    
    let token: String
    
    @Published var courses: [Course] = []
    
    init(_ token: String) {
        self.token = token
        print("Initialized Canvas API with token \"\(self.token)\"")
        CanvasAPI.instance = self
        self.getCourses()
    }
    
    func getCourses() {
        let coursesRequest = AF.request("https://canvas.instructure.com/api/v1/courses", method: .get, parameters: ["access_token": self.token])
        coursesRequest.responseDecodable(of: [Course].self) { data in
            print(data)
            self.courses = data.value!
        }
    }
    
    func getModules(forCourse course: Course) -> [Module]? {
        var modules: [Module]? = nil
        let modulesRequest = AF.request("https://canvas.instructure.com/api/v1/courses/\(course.id)/modules", method: .get, parameters: ["access_token": self.token])
        modulesRequest.responseDecodable(of: [Module].self) { data in
            print(data)
            modules = data.value!
        }
        
        return modules
    }
}
