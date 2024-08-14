//
//  Course.swift
//  TimeTableDemo
//

import Foundation
import SwiftUI


struct CourseInfo {
    let title: String
    let startTime: Date
    let endTime: Date
    let color: Color
}


class CourseGenerator: ObservableObject {
    @Published private var courses: [String: [CourseInfo]] = [:] // 使用字典存储课程
    private let colors: [Color] = [.red, .green, .blue, .orange, .purple, .yellow, .pink, .gray]
    
    func generateRandomCourses() {
        let calendar = Calendar.current
        let now = Date()
        guard let sevenDaysAgo = calendar.date(byAdding: .day, value: -4, to: now),
        let sevenDaysNext = calendar.date(byAdding: .day, value: 4, to: now) else { return }
        
        // 随机生成课程的个数
        let numberOfCourses = Int.random(in: 20...30)
        
        for i in 0..<numberOfCourses {
            // 随机选择课程标题
//            let titleIndex = Int.random(in: 0..<courseTitles.count)
            let title = "事项\(i)"
            
            // 随机选择颜色
            let colorIndex = Int.random(in: 0..<colors.count)
            let color = colors[colorIndex]
            
            var randomStart: Date
            var randomEnd: Date = .now
            var courseDayKey: String = ""
            repeat {
                // 随机生成开始时间和结束时间
                randomStart = Date.random(in: sevenDaysAgo...sevenDaysNext)
                guard let randomEndTemp = calendar.date(byAdding: .hour, value: 1, to: randomStart) else { continue }
                randomEnd = randomEndTemp
                
                // 创建字典键
                let dayComponent = calendar.dateComponents([.year, .month, .day], from: randomStart)
                let hourComponent = calendar.component(.hour, from: randomStart)
                courseDayKey = "\(dayComponent.year!)-\(dayComponent.month!)-\(dayComponent.day!)-\(hourComponent)"
            } while (courses[courseDayKey] != nil) // 检查时间冲突
            
            // 创建课程信息并添加到字典中
            let course = CourseInfo(title: title, startTime: randomStart, endTime: randomEnd, color: color)
            courses[courseDayKey, default: []].append(course)
        }
    }
    
    func findCourses(on date: Date, startingAt startHour: Int) -> [CourseInfo] {
        let calendar = Calendar.current
        let dayComponent = calendar.dateComponents([.year, .month, .day], from: date)
        let courseDayKey = "\(dayComponent.year!)-\(dayComponent.month!)-\(dayComponent.day!)-\(startHour)"
        
        return courses[courseDayKey] ?? []
    }
}

extension Date {
    static func random(in range: ClosedRange<Date>) -> Date {
        let start = range.lowerBound.timeIntervalSinceReferenceDate
        let end = range.upperBound.timeIntervalSinceReferenceDate
        return Date(timeIntervalSinceReferenceDate: .random(in: start...end))
    }
}
