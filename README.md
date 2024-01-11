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
```
![TimeTableH](https://github.com/blabla-yy/SwiftUITimeTable/blob/main/screenshot.png)
