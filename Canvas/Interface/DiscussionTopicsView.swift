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
    }
}

struct DiscussionTopicRowView: View {
    @ObservedObject var topic: DiscussionTopic
    
    var body: some View {
        Label {
            HStack {
                VStack(alignment: .leading) {
                    Text(topic.title ?? "Topic")
                        .font(.title3)
                        .bold()
                    Text("2 unread, 3 replies")
                        .font(.subheadline)
                    Text("Last reply at \(topic.lastReplyAt?.formatted(dateStyle: .medium, timeStyle: .short) ?? "Unknown")")
                        .font(.subheadline)
                }
                Spacer()
//                Image(systemName: "bookmark")
            }
        } icon: {
            Image(systemName: "bubble.left.and.bubble.right")
        }
    }
}

struct DiscussionTopicsView_Previews: PreviewProvider {
    static var previews: some View {
        DiscussionTopicsView()
    }
}
