//
//  ContentView.swift
//  TimeTableDemo
//

import SwiftUI
import SwiftUITimeTable

struct EventView: View {
    let course: CourseInfo?
    var existedCourse: CourseInfo {
        course!
    }

    var body: some View {
        Group {
            if course == nil {
                Color.clear
            } else {
                VStack {
                    VStack {
                        Text(existedCourse.title)
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding(.top, 4)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(existedCourse.color.opacity(0.5))
                            .stroke(existedCourse.color)
                    )
                    .padding(2)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .border(.gray, width: 0.2)
    }
}

struct ContentView: View {
    @StateObject var course = {
        let generator = CourseGenerator()
        generator.generateRandomCourses()
        return generator
    }()

    var body: some View {
        VStack {
            TimeTableView(
                eventView: { event in
                    EventView(course: course.findCourses(on: event.date, startingAt: event.startHour).first)
                },
                timeRange: 8 ..< 22)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
