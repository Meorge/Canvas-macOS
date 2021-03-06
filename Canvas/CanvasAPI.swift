//
//  CanvasAPI.swift
//  Canvas
//
//  Created by Test Account on 9/26/20.
//

import Foundation
import Alamofire
import SwiftUI
import SwiftyJSON

class CanvasAPI: ObservableObject {
    var domain = "wsu.instructure.com"
    var baseURL: String {
        "https://\(domain)/api/v1"
    }

    var token: String = ""
    
    let jsonDecoder = JSONDecoder()
    
    @Published var currentUser: User?
    @Published var courses: [Course] = []
    @Published var groups: [CanvasGroup] = []
    @Published var numberOfActiveRequests: Int = 0
    @Published var courseIconData: CourseIconData = CourseIconData()
    
    init() {
        self.jsonDecoder.dateDecodingStrategy = .iso8601
    }
    
    init(_ token: String, _ domain: String) {
        // set up date decoding strategy
        self.jsonDecoder.dateDecodingStrategy = .iso8601
        
        self.token = token
        self.domain = domain
    }

    // TODO: Instead of using this to get the courses, use the enrollments:
    // https://canvas.instructure.com/api/v1/users/self/enrollments
    func getCourses() {
        let url = "/courses"
        makeRequest(url, custom_parameters: ["include": ["total_scores"]], handler: self.updateAllCoursesTopLevel)
    }
    
    func getGroups() {
        let url = "/users/self/groups"
        makeRequest(url, custom_parameters: ["include": ["users"]], handler: self.updateGroups)
    }
    
    func updateGroups(data: DataResponse<[CanvasGroup], AFError>) {
        self.groups = data.value ?? []
        
        for group in self.groups {
            group.updateTopLevel()
        }
    }
    
    func updateAllCoursesTopLevel(data: DataResponse<[Course], AFError>) {
        self.courses = data.value ?? []
        
        for course in self.courses {
            course.updateTopLevel()
        }
    }
    
    func updateAllCourses(data: DataResponse<[Course], AFError>) {
        self.courses = data.value ?? []

        for course in self.courses {
            course.update()
        }
    }
    
    func getCourseTabs(forCourse course: Course, handler: @escaping ((DataResponse<[Tab], AFError>) -> Void)) {
        let url = "/courses/\(course.id!)/tabs"
        makeRequest(url, handler: handler)
    }
    
    func getGroupTabs(forGroup group: CanvasGroup, handler: @escaping ((DataResponse<[Tab], AFError>) -> Void)) {
        let url = "/groups/\(group.id!)/tabs"
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
    
    func getDiscussionTopics(forCourse course: Course, handler: @escaping ((DataResponse<[DiscussionTopic], AFError>) -> Void)) {
        let url = "/courses/\(course.id!)/discussion_topics"
        makeRequest(url, handler: handler)
    }
    
    func getDiscussionTopics(forGroup group: CanvasGroup, handler: @escaping ((DataResponse<[DiscussionTopic], AFError>) -> Void)) {
        let url = "/groups/\(group.id!)/discussion_topics"
        makeRequest(url, handler: handler)
    }
    
    func getUsers(forCourse course: Course, handler: @escaping ((DataResponse<[User], AFError>) -> Void)) {
        let url = "/courses/\(course.id!)/users"
        makeRequest(url, custom_parameters: ["per_page": 200, "include": ["enrollments", "bio", "avatar_url"]], handler: handler)
    }
    
    func getUsers(forGroup group: CanvasGroup, handler: @escaping ((DataResponse<[User], AFError>) -> Void)) {
        let url = "/groups/\(group.id!)/users"
        print(url)
        makeRequest(url, custom_parameters: ["per_page": 200, "include": ["enrollments", "bio", "avatar_url"]], handler: handler)
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
        makeRequest(url, custom_parameters: ["include": ["submission", "score_statistics"], "per_page": 100], handler: handler)
    }
    
    func getAssignmentGroups(forCourse course: Course, handler: @escaping ((DataResponse<[AssignmentGroup], AFError>) -> Void)) {
        let url = "/courses/\(course.id!)/assignment_groups"
        makeRequest(url, custom_parameters: ["include": ["submission", "score_statistics", "assignments"]], handler: handler)
    }
    
    func getCourseStreamSummary(forCourse course: Course, handler: @escaping ((DataResponse<[ActivityStreamSummaryItem], AFError>) -> Void)) {
        let url = "/courses/\(course.id!)/activity_stream/summary"
        makeRequest(url, handler: handler)
    }
    
    func getGroupStreamSummary(forGroup group: CanvasGroup, handler: @escaping ((DataResponse<[ActivityStreamSummaryItem], AFError>) -> Void)) {
        let url = "/groups/\(group.id!)/activity_stream/summary"
        makeRequest(url, handler: handler)
    }
    
    func getCurrentUser() {
        let url = "/users/self"
        makeRequest(url, handler: self.updateCurrentUser)
    }
    
    func updateCurrentUser(data: DataResponse<User, AFError>) {
        self.currentUser = data.value!
    }
    
    func getAccountDomains(forQuery query: String, handler: @escaping ((DataResponse<[Domain], AFError>) -> Void)) {
        let request = AF.request("https://canvas.instructure.com/api/v1/accounts/search", method: .get, parameters: ["name": query])
        
        request.responseDecodable(of: [Domain].self, decoder: jsonDecoder) { response in
            handler(response)
        }
    }
    
    
    func makeRequest<T>(
        _ url: String,
        custom_parameters: [String: Any] = [:],
        method: HTTPMethod = .get,
        handler: @escaping ((DataResponse<T, AFError>) -> Void) = {_ in }
    ) where T: Decodable {
        var parameters: [String: Any] = ["access_token": self.token]
        parameters.merge(custom_parameters) { (_, new) in new }
        
        let fullURL = baseURL + url
        
        print(fullURL)
        let request = AF.request(fullURL, method: method, parameters: parameters)
        
        self.numberOfActiveRequests += 1
        request.responseDecodable(of: T.self, decoder: jsonDecoder) { response in
            self.numberOfActiveRequests -= 1
            handler(response)
        }
    }
    
    
    func attemptToConnect(_ token: String, _ domain: String, handler: @escaping ((ConnectionAttemptResult) -> Void)) {
        let url = "https://\(domain)/api/v1/users/self"
        let request = AF.request(url, method: .get, parameters: ["access_token": token])

        request.responseData { data in
            // Failed - there was some other kind of error
            if data.error != nil {
                handler(ConnectionAttemptResult.Failure(message: data.error!.localizedDescription))
                return
            }
            
            if let json = try? JSON(data: data.value!) {
                // Failed
                // Invalid access token, probably?
                if data.response!.statusCode != 200 {
                    handler(ConnectionAttemptResult.Failure(message: "Error code \(data.response!.statusCode) - \(json["errors"][0]["message"].stringValue)"))
                }
                
                // Succeeded
                else {
                    handler(ConnectionAttemptResult.Success)
                }
            } else {
                handler(ConnectionAttemptResult.Failure(message: "Error code \(data.response!.statusCode) - \"\(String(decoding: data.value!, as: UTF8.self))\""))
            }
        }
    }
}

enum ConnectionAttemptResult {
    case Failure(message: String)
    case Success
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
