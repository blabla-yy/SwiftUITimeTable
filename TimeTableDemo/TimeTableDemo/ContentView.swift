//
//  ContentView.swift
//  TimeTableDemo
//

import SwiftUI
import SwiftUITimeTable

struct EventView: View {
    let cell: CellInfo
    let courses: [CourseInfo]

    var body: some View {
        ZStack {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .border(width: 1, edges: cell.borderEdge, color: .gray)

            ForEach(courses) {course in
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(course.color)
                    .frame(height: cell.eventHeight(eventStartTime: course.startTime, eventEndTime: course.endTime))
                    .frame(maxWidth: .infinity)
                    .overlay {
                        VStack {
                            Text(course.title)
                                .font(.caption)
                                .foregroundStyle(.white)
                                .padding(.top, 4)
                            Spacer()
                        }
                    }
                    .offset(y: cell.eventOffset(eventStartTime: course.startTime))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            WeekGridView(date: .now) { cell in
                EventView(cell: cell, courses: course.findCourses(on: cell.date, startingAt: cell.startHour))
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
