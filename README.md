# SwiftUITimeTable

完全基于SwiftUI标准API的时间表，支持iOS/MacOS（WatchOS和TvOS没有测试过效果）

## 特点
- 纯SwiftUI框架
- 支持左滑右滑切换周视图（基于TabView）
- 支持定制各种参数，包括展示一周的天数，时间段等。


## 预览
![TimeTableV](https://github.com/blabla-yy/SwiftUITimeTable/blob/main/TimeTableV.gif)
![TimeTableH](https://github.com/blabla-yy/SwiftUITimeTable/blob/main/TimeTableH.gif)

## 示例
```swift
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
```
![TimeTableH](https://github.com/blabla-yy/SwiftUITimeTable/blob/main/screenshot.png)
