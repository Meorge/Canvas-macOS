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
        CanvasAPI.instance = self
        self.getCourses()
    }
    
    func getCourses() {
        let coursesRequest = AF.request("https://canvas.instructure.com/api/v1/courses", method: .get, parameters: ["access_token": self.token])
        coursesRequest.responseDecodable(of: [Course].self) { data in
            self.courses = data.value!
        }
    }
    
    func getModules(forCourse course: Course, handler: @escaping ((DataResponse<[Module], AFError>) -> Void)) {
        let url = "https://canvas.instructure.com/api/v1/courses/\(course.id!)/modules"
        let modulesRequest = AF.request(url, method: .get, parameters: ["access_token": self.token])
        modulesRequest.responseDecodable(of: [Module].self, completionHandler: handler)
    }
    
    func getModuleItems(forModule module: Module, handler: @escaping ((DataResponse<[ModuleItem], AFError>) -> Void)) {
        let url = "https://canvas.instructure.com/api/v1/courses/\(module.course!.id!)/modules/\(module.id!)/items"
        let moduleItemsRequest = AF.request(url, method: .get, parameters: ["access_token": self.token])
        moduleItemsRequest.responseDecodable(of: [ModuleItem].self, completionHandler: handler)
    }
}
