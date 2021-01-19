//
//  CanvasAPI.swift
//  Canvas
//
//  Created by Test Account on 9/26/20.
//

import Foundation
import Alamofire

class CanvasAPI: ObservableObject {
    static var baseURL = "https://canvas.instructure.com/api/v1"
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
        let url = "/courses"
        makeRequest(url, custom_parameters: ["include": ["total_scores"]], handler: self.updateAllCourses)
    }
    
    func updateAllCourses(data: DataResponse<[Course], AFError>) {
        self.courses = data.value!
        
        for course in self.courses {
            course.update()
        }
    }
    
    func getModules(forCourse course: Course, handler: @escaping ((DataResponse<[Module], AFError>) -> Void)) {
//        course.updatingModules = true
        let url = "/courses/\(course.id!)/modules"
        makeRequest(url, handler: handler)
    }
    
    func getModuleItems(forModule module: Module, handler: @escaping ((DataResponse<[ModuleItem], AFError>) -> Void)) {
//        module.course?.updatingModules = true
        let url = "/courses/\(module.course!.id!)/modules/\(module.id!)/items"
        makeRequest(url, custom_parameters: ["include": ["content_details"]], handler: handler)
    }
    
    func getCourseEnrollments(forCourse course: Course, handler: @escaping ((DataResponse<[Enrollment], AFError>) -> Void)) {
        
        let url = "/courses/\(course.id!)/enrollments"
        makeRequest(url, handler: handler)
    }
    
    func getAnnouncements(forCourse course: Course, handler: @escaping ((DataResponse<[DiscussionTopic], AFError>) -> Void)) {
//        course.updatingAnnouncements = true
        let url = "/courses/\(course.id!)/discussion_topics"
        makeRequest(url, custom_parameters: ["only_announcements": true], handler: handler)
    }
    
    func getUsers(forCourse course: Course, handler: @escaping ((DataResponse<[User], AFError>) -> Void)) {
//        course.updatingPeople = true
//        print("Updating people for course \(course.name!) is true")
        let url = "/courses/\(course.id!)/users"
        makeRequest(url, custom_parameters: ["per_page": 100, "include": ["enrollments", "bio", "avatar_url"]], handler: handler)
    }
    
    func makeRequest<T>(_ url: String, custom_parameters: [String: Any] = [:], handler: @escaping ((DataResponse<T, AFError>) -> Void) = {_ in }) where T: Decodable {
        var parameters: [String: Any] = ["access_token": self.token]
        parameters.merge(custom_parameters) { (_, new) in new }
        let request = AF.request(CanvasAPI.baseURL + url, method: .get, parameters: parameters)
        request.responseDecodable(of: T.self, decoder: jsonDecoder, completionHandler: handler)
    }
}
