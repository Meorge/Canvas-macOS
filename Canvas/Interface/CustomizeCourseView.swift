//
//  CustomizeCourseView.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/19/21.
//

import SwiftUI

struct CustomizeCourseView: View {
    @EnvironmentObject var manager: Manager
    @Binding var isVisible: Bool
    
    @ObservedObject var course: Course
    
    @State var defaultClassName: String = ""
    @State var className: String = ""
    @State var iconID: String = ""
    @State var courseColor: Color = Color.accentColor
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Edit Course")
                .fontWeight(.bold)
            Text("here you can change your course's nickname and color and icon that's pretty cool huh")
                
            Form {
                TextField(self.defaultClassName, text: $className)
                TextField("Icon ID", text: $iconID)
                ColorPicker("Course Color", selection: $courseColor)
            }
            
            HStack {
                Spacer()
                Button(action: self.cancel) {
                    Text("Cancel")
                }
                Button(action: self.submit) {
                    Text("Submit")
                }
            }
        }
        .padding()
        .onAppear(perform: self.getCurrentCourseNickname)
    }
    
    func getCurrentCourseNickname() {
        CanvasAPI.instance!.getCourseNickname(forCourse: self.course) { result in
            self.className = result.value!.nickname ?? ""
            self.defaultClassName = result.value!.name ?? "Course"
        }
        
        self.courseColor = self.course.courseColor!
        
        self.iconID = self.course.courseIcon ?? ""
    }
    
    func cancel() {
        self.isVisible = false
    }
    
    func submit() {
        self.isVisible = false
        
        self.course.courseColor = self.courseColor
        
        CanvasAPI.instance!.setCourseNickname(forCourse: self.course, to: self.className) { result in
            self.manager.refresh()
        }
        
        CanvasAPI.instance!.setCourseIcon(forCourse: self.course, to: self.iconID) { result in
            self.manager.refresh()
        }
        
        CanvasAPI.instance!.setCourseColor(forCourse: self.course, to: self.courseColor) { result in
            self.manager.refresh()
        }
    }
}

//struct CustomizeCourseView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomizeCourseView(isVisible: true)
//    }
//}
