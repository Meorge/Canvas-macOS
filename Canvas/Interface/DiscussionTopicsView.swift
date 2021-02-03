//
//  DiscussionTopicsView.swift
//  Canvas
//
//  Created by Malcolm Anderson on 2/3/21.
//

import SwiftUI

struct DiscussionTopicsView: View {
    @ObservedObject var course: Course = Course()
    
    var pinnedTopics: [DiscussionTopic] {
        course.discussionTopics.filter { topic in
            topic.pinned ?? false
        }
    }
    
    var normalTopics: [DiscussionTopic] {
        course.discussionTopics.filter { topic in
            !(topic.pinned ?? false) && !(topic.locked ?? false)
        }
    }
   
    var closedTopics: [DiscussionTopic] {
        course.discussionTopics.filter { topic in
            !(topic.pinned ?? false) && topic.locked ?? false
        }
    }
    
    var body: some View {
        List {
            Section(header: Text("Pinned")) {
                ForEach(pinnedTopics, id: \.id) { topic in
                    DiscussionTopicRowView(topic: topic)
                }
            }
            
            Section(header: Text("Discussions")) {
                ForEach(normalTopics, id: \.id) { topic in
                    DiscussionTopicRowView(topic: topic)
                }
            }
            
            Section(header: Text("Closed for Comments")) {
                ForEach(closedTopics, id: \.id) { topic in
                    DiscussionTopicRowView(topic: topic)
                }
            }
        }
        .navigationTitle("Discussions")
        .navigationSubtitle(course.name ?? "Course")
    }
}

struct DiscussionTopicRowView: View {
    @Environment(\.openURL) var openURL
    @ObservedObject var topic: DiscussionTopic
    
    var body: some View {
        Button(action: self.open) {
            Label {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(topic.title ?? "Topic")
                                .font(.title3)
                                .bold()
                            
                            if (topic.unreadCount ?? 0) > 0 { Badge(text: "\(topic.unreadCount!)", color: .red, minWidth: 25) }
                            if (topic.discussionSubentryCount ?? 0) > 0 { Badge(text: "\(topic.discussionSubentryCount!)", color: .gray, minWidth: 25) }
                        }
                        Text("Last reply at \(topic.lastReplyAt?.formatted(dateStyle: .medium, timeStyle: .short) ?? "Unknown")")
                            .font(.subheadline)
                    }
                }
            } icon: {
                VStack {
                    Image(systemName: "\(topic.assignmentID == nil ? "bubble.left" : "exclamationmark.bubble")\(topic.unreadCount ?? 0 > 0 ? ".fill" : "")")

                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    func open() {
        if topic.htmlURL != nil {
            openURL(topic.htmlURL!)
        }
    }
}

struct DiscussionTopicsView_Previews: PreviewProvider {
    static var previews: some View {
        DiscussionTopicsView()
    }
}
