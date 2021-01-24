//
//  CanvasAPI.swift
//  Canvas
//
//  Created by Test Account on 9/26/20.
//

import Foundation
import Alamofire
import SwiftUI

class CanvasAPI: ObservableObject {
    static var subdomain = "wsu"
    static var baseURL = "https://\(subdomain).instructure.com/api/v1"
    static var instance: CanvasAPI? = nil
    
    let token: String
    
    let jsonDecoder = JSONDecoder()
    
    @Published var courses: [Course] = []
    @Published var numberOfActiveRequests: Int = 0
    @Published var courseIconData: CourseIconData = CourseIconData()
    
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
//        self.courses.removeAll()
        makeRequest(url, custom_parameters: ["include": ["total_scores"]], handler: self.updateAllCourses)
    }
    
    func updateAllCourses(data: DataResponse<[Course], AFError>) {
        let newCourses = data.value ?? []
        
        // If a course has been added, add it!
        for course in newCourses {
            if !self.courses.contains(course) {
                self.courses.append(course)
            }
        }
        
        // If a course has been removed, remove it!
        for course in self.courses {
            if !newCourses.contains(course) {
                self.courses.remove(at: self.courses.firstIndex(of: course)!)
            }
        }
        
        for course in self.courses {
            course.update()
        }
    }
    
    func getCourseTabs(forCourse course: Course, handler: @escaping ((DataResponse<[Tab], AFError>) -> Void)) {
        let url = "/courses/\(course.id!)/tabs"
        makeRequest(url, handler: handler)
    }
    
    func getModules(forCourse course: Course, handler: @escaping ((DataResponse<[Module], AFError>) -> Void)) {
        let url = "/courses/\(course.id!)/modules"
        makeRequest(url, handler: handler)
    }
    
    func getModuleItems(forModule module: Module, handler: @escaping ((DataResponse<[ModuleItem], AFError>) -> Void)) {
        let url = "/courses/\(module.course!.id!)/modules/\(module.id!)/items"
        makeRequest(url, custom_parameters: ["include": ["content_details"]], handler: handler)
    }
    
    func getCourseEnrollments(forCourse course: Course, handler: @escaping ((DataResponse<[Enrollment], AFError>) -> Void)) {
        let url = "/courses/\(course.id!)/enrollments"
        makeRequest(url, handler: handler)
    }
    
    func getAnnouncements(forCourse course: Course, handler: @escaping ((DataResponse<[DiscussionTopic], AFError>) -> Void)) {
        let url = "/courses/\(course.id!)/discussion_topics"
        makeRequest(url, custom_parameters: ["only_announcements": true], handler: handler)
    }
    
    func getUsers(forCourse course: Course, handler: @escaping ((DataResponse<[User], AFError>) -> Void)) {
        let url = "/courses/\(course.id!)/users"
        makeRequest(url, custom_parameters: ["per_page": 100, "include": ["enrollments", "bio", "avatar_url"]], handler: handler)
    }
    
    func getCourseNickname(forCourse course: Course, handler: @escaping ((DataResponse<CourseNickname, AFError>) -> Void)) {
        let url = "/users/self/course_nicknames/\(course.id!)"
        makeRequest(url, handler: handler)
    }
    
    func setCourseNickname(forCourse course: Course, to newNickname: String, handler: @escaping ((DataResponse<CourseNickname, AFError>) -> Void)) {
        let url = "/users/self/course_nicknames/\(course.id!)"
        makeRequest(url, custom_parameters: ["nickname": newNickname], method: .put, handler: handler)
    }
    
    func getCourseColor(forCourse course: Course, handler: @escaping ((DataResponse<CustomColor, AFError>) -> Void)) {
        let url = "/users/self/colors/course_\(course.id!)"
        makeRequest(url, handler: handler)
    }
    
    func setCourseColor(forCourse course: Course, to newColor: Color, handler: @escaping ((DataResponse<CustomColor, AFError>) -> Void)) {
        let url = "/users/self/colors/course_\(course.id!)"
        makeRequest(url, custom_parameters: ["hexcode": newColor.toHex()], method: .put, handler: handler)
    }
    
    func setCourseIcon(forCourse course: Course, to newIcon: String, handler: @escaping ((DataResponse<CourseIconData, AFError>) -> Void)) {
        let url = "/users/self/custom_data/course_icons"
        
        // Set up course icon data
        self.courseIconData.data["\(course.id!)"] = newIcon
        
        makeRequest(url, custom_parameters: ["ns": "com.malcolminyo.canvas-macos", "data": courseIconData.data], method: .put, handler: handler)
    }
    
    func getCourseIcon(forCourse course: Course, handler: @escaping ((DataResponse<CourseIconData, AFError>) -> Void)) {
        let url = "/users/self/custom_data/course_icons"
        
        let responder: ((DataResponse<CourseIconData, AFError>) -> Void) = { response in
            self.courseIconData = response.value ?? CourseIconData()
            handler(response)
        }
        
        makeRequest(url, custom_parameters: ["ns": "com.malcolminyo.canvas-macos"], handler: responder)
    }
    
    func getAssignments(forCourse course: Course, handler: @escaping ((DataResponse<[Assignment], AFError>) -> Void)) {
        let url = "/courses/\(course.id!)/assignments"
        makeRequest(url, custom_parameters: ["include": ["submission", "score_statistics"]], handler: handler)
    }
    
    func getAssignmentGroups(forCourse course: Course, handler: @escaping ((DataResponse<[AssignmentGroup], AFError>) -> Void)) {
        let url = "/courses/\(course.id!)/assignment_groups"
        makeRequest(url, custom_parameters: ["include": ["submission", "score_statistics", "assignments"]], handler: handler)
    }
    
    func makeRequest<T>(_ url: String, custom_parameters: [String: Any] = [:], method: HTTPMethod = .get, handler: @escaping ((DataResponse<T, AFError>) -> Void) = {_ in }) where T: Decodable {
        var parameters: [String: Any] = ["access_token": self.token]
        parameters.merge(custom_parameters) { (_, new) in new }
        
        
        let request = AF.request(CanvasAPI.baseURL + url, method: method, parameters: parameters)
        
        self.numberOfActiveRequests += 1
        request.responseDecodable(of: T.self, decoder: jsonDecoder) { response in
            self.numberOfActiveRequests -= 1
            handler(response)
        }
    }
    
}

extension Color {
    func toHex() -> String {
        let components = self.cgColor?.components
        
        var r, g, b: Int
        
        r = Int(components![0] * 255)
        g = Int(components![1] * 255)
        b = Int(components![2] * 255)
        
        return String(format: "%02x%02x%02x", r, g, b)
    }
}

class CourseIconData: Decodable {
    var data: [String : String] = [:]
}

class CustomColor: Decodable {
    var hexcode: String = "#000000"
    
    var asColor: Color {
        // from https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor
        
        let r, g, b: Double
        let start = hexcode.index(hexcode.startIndex, offsetBy: 1)
        let hexColor = String(hexcode[start...])

        if hexColor.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0

            if scanner.scanHexInt64(&hexNumber) {
                r = Double((hexNumber & 0xff0000) >> 16) / 255
                g = Double((hexNumber & 0x00ff00) >> 8) / 255
                b = Double(hexNumber & 0x0000ff) / 255

                return Color(red: r, green: g, blue: b)
            }
        }
        
        return Color.red
    }
}
