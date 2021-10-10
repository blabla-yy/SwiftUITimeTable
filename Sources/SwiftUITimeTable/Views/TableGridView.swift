//
//  SwiftUIView.swift
//
//
//  Created by 王跃洋 on 2021/10/9.
//

import SwiftUI

extension Date {
    func nextWeekDay(_ calendar: Calendar, direction: Calendar.SearchDirection) -> Date {
        return calendar.date(byAdding: .day, value: direction == .backward ? -7 : 7, to: self)!
    }
}

class TimeTableState: ObservableObject {
    @Published var selected: Int = 0
    @Published var current: Date
    @Published var pages: [Date]
    let calendar: Calendar
    let initDate: Date

    init(calendar: Calendar) {
        let date = Date()
        self.calendar = calendar
        initDate = date
        _current = .init(initialValue: date)
        _pages = .init(initialValue: [date.nextWeekDay(calendar, direction: .backward), date, date.nextWeekDay(calendar, direction: .forward)])
    }
}

extension TimeTableView where HeaderContent == DefaultHeaderView, WeekContent == DefaultWeekView, EventContent == DefaultEventView {
    public init() {
        self.init(
            headerView: { DefaultHeaderView(date: $0) },
            weekView: {
                DefaultWeekView(date: $0)
            },
            eventView: { DefaultEventView(info: $0)
            }
        )
    }
}

public struct TimeTableView<HeaderContent, WeekContent, EventContent>: View
    where HeaderContent: View, WeekContent: View, EventContent: View {
    public typealias HeaderGen = (Date) -> HeaderContent
    public typealias WeekGen = (Date) -> WeekContent
    public typealias EventGen = (EventInfo) -> EventContent

    @ObservedObject var timeTableState: TimeTableState
    @Environment(\.calendar) var calendar
    let headerView: HeaderGen
    let weekView: WeekGen
    let eventView: EventGen
    let eventCellHeight: CGFloat?
    let timeCellWidth: CGFloat?
    let timeRange: Range<Int>
    let weekRange: Range<Int>

    public init(
        headerView: @escaping HeaderGen,
        weekView: @escaping WeekGen,
        eventView: @escaping EventGen,
        eventCellHeight: CGFloat? = 80,
        timeCellWidth: CGFloat? = nil,
        timeRange: Range<Int> = 0 ..< 25,
        weekRange: Range<Int> = 1 ..< 8 // weekday 1: SUN, 7:SAT
    ) {
        let calendar: Environment<Calendar> = .init(\.calendar)
        _timeTableState = .init(initialValue: TimeTableState(calendar: calendar.wrappedValue))
        _calendar = calendar
        self.eventView = eventView
        self.weekView = weekView
        self.headerView = headerView
        self.eventCellHeight = eventCellHeight
        self.timeCellWidth = timeCellWidth
        self.timeRange = timeRange
        self.weekRange = weekRange
    }

    func getCellWidth(_ parentViewWidth: CGFloat) -> CGFloat {
        if let exists = timeCellWidth {
            return (parentViewWidth - exists) / CGFloat(weekRange.count - 1)
        }
        return parentViewWidth / CGFloat(weekRange.count + 1)
    }

    func getEventCellWidth(_ parentViewWidth: CGFloat) -> CGFloat {
        if let exists = timeCellWidth {
            return exists
        }
        return parentViewWidth / CGFloat(weekRange.count + 1)
    }

    public var body: some View {
        GeometryReader { reader in
            TabView(selection: $timeTableState.current) {
                ForEach(timeTableState.pages, id: \.self) { date in
                    WeekGridView(date: date,
                                 calendar: calendar,
                                 cellWidth: getCellWidth(reader.size.width),
                                 timeCellWidth: getEventCellWidth(reader.size.width),
                                 headerView: headerView,
                                 weekView: weekView,
                                 eventView: eventView,
                                 timeRange: timeRange,
                                 weekRange: weekRange
                    )
                    .id(date)
                    .tag(date)
                }
            }
            .onReceive(timeTableState.$current, perform: { date in
                if timeTableState.pages.last == date {
                    timeTableState.pages.append(date.nextWeekDay(calendar, direction: .forward))
                } else if timeTableState.pages.first == date {
                    timeTableState.pages.insert(date.nextWeekDay(calendar, direction: .backward), at: 0)
                }
            })
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            TimeTableView()
                .previewInterfaceOrientation(.landscapeRight)
        } else {
            TimeTableView()
            // Fallback on earlier versions
        }
    }
}
