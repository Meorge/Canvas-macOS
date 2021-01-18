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
    
    let jsonDecoder = JSONDecoder()
    
    @Published var courses: [Course] = []
    
    init(_ token: String) {
        // set up date decoding strategy
        self.jsonDecoder.dateDecodingStrategy = .iso8601
        
        self.token = token
        CanvasAPI.instance = self
        self.getCourses()
    }
    

    // TODO: Instead of using this to get the courses, use the enrollments:
    // https://canvas.instructure.com/api/v1/users/self/enrollments
    func getCourses() {
        let coursesRequest = AF.request("https://canvas.instructure.com/api/v1/courses", method: .get, parameters: ["access_token": self.token, "include": ["total_scores"]])
        coursesRequest.responseDecodable(of: [Course].self, decoder: jsonDecoder) { data in
            self.courses = data.value!
        }
    }
    
    func getModules(forCourse course: Course, handler: @escaping ((DataResponse<[Module], AFError>) -> Void)) {
        let url = "https://canvas.instructure.com/api/v1/courses/\(course.id!)/modules"
        let modulesRequest = AF.request(url, method: .get, parameters: ["access_token": self.token])
        modulesRequest.responseDecodable(of: [Module].self, decoder: jsonDecoder, completionHandler: handler)
    }
    
    func getModuleItems(forModule module: Module, handler: @escaping ((DataResponse<[ModuleItem], AFError>) -> Void)) {
        let url = "https://canvas.instructure.com/api/v1/courses/\(module.course!.id!)/modules/\(module.id!)/items"
        let moduleItemsRequest = AF.request(url, method: .get, parameters: ["access_token": self.token, "include": ["content_details"]])
        moduleItemsRequest.responseDecodable(of: [ModuleItem].self, decoder: jsonDecoder, completionHandler: handler)
    }
    
    func getCourseEnrollments(forCourse course: Course, handler: @escaping ((DataResponse<[Enrollment], AFError>) -> Void)) {
        let url = "https://canvas.instructure.com/api/v1/courses/\(course.id!)/enrollments"
        let enrollmentsRequest = AF.request(url, method: .get, parameters: ["access_token": self.token])
        enrollmentsRequest.responseDecodable(of: [Enrollment].self, decoder: jsonDecoder, completionHandler: handler)
    }
    
    func getAnnouncements(forCourse course: Course, handler: @escaping ((DataResponse<[Enrollment], AFError>) -> Void)) {
        let url = "https://canvas.instructure.com/api/v1/courses/\(course.id!)/discussion_topics"
        let enrollmentsRequest = AF.request(url, method: .get, parameters: ["access_token": self.token, "only_announcements": true])
        enrollmentsRequest.responseDecodable(of: [Enrollment].self, decoder: jsonDecoder, completionHandler: handler)
    }
}
