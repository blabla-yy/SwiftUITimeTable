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
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(existedCourse.color)
                    .frame(height: cell.eventHeight(eventStartTime: course!.startTime, eventEndTime: course!.endTime))
                    .frame(maxWidth: .infinity)
                    .overlay {
                        VStack {
                            Text(existedCourse.title)
                                .font(.caption)
                                .foregroundStyle(.white)
                                .padding(.top, 4)
                            Spacer()
                        }
                    }
                    .offset(y: cell.eventOffset(eventStartTime: course!.startTime))
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
