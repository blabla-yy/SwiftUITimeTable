//
//  ContentView.swift
//  TimeTableDemo
//

import SwiftUI
import SwiftUITimeTable

struct EventView: View {
    let cell: CellInfo
    let course: CourseInfo?
    var existedCourse: CourseInfo {
        course!
    }

    var body: some View {
        ZStack {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .border(width: 1, edges: cell.borderEdge, color: .gray)

            if course != nil {
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
                .offset(y: cell.eventOffset(eventStartTime: course!.startTime))
                .padding(2)
            }
        }
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
                eventView: { cell in
                    EventView(cell: cell, course: course.findCourses(on: cell.date, startingAt: cell.startHour).first)
                },
                timeRange: 8 ..< 22
            )
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
