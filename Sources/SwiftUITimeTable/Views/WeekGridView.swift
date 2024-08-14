//
//  WeekGridView.swift
//

import SwiftUI

struct WeekGridView<HeaderView, WeekView, EventView>: View
    where WeekView: View, HeaderView: View, EventView: View
{
    let weekGridItems: [GridItem]
    let eventGridItems: [GridItem]

    let weekCellHeight: CGFloat?
    let height: CGFloat?
    let width: CGFloat?
    let date: Date
    let headerView: (Date) -> HeaderView
    let weekView: (Date) -> WeekView
    let eventView: (CellInfo) -> EventView

    let days: [Date]
    let timeRange: Range<Int>
    let weekRange: Range<Int>
    init(
        date: Date,
        calendar: Calendar,
        weekGridAlignment: Alignment = .center,
        timeGridAlignment: Alignment = .center,
        eventGridAlignment: Alignment = .leading,
        spacing: CGFloat = 0, // 间隔
        eventCellHeight: CGFloat? = 80, // 事件格子高度
        weekCellHeight: CGFloat? = nil, // 第一行周信息高度
        cellWidth: CGFloat? = nil, // 格子宽度（除时间线）
        timeCellWidth: CGFloat = 40, // 时间格子宽度
        headerView: @escaping (Date) -> HeaderView,
        weekView: @escaping (Date) -> WeekView,
        eventView: @escaping (CellInfo) -> EventView,
        timeRange: Range<Int> = 0 ..< 25,
        weekRange: Range<Int> = 1 ..< 8 // 1: SUN, 7:SAT
    ) {
        let baseGridItem: GridItem
        if let width = cellWidth {
            baseGridItem = GridItem(.fixed(width), spacing: 0, alignment: weekGridAlignment)
        } else {
            baseGridItem = GridItem(.flexible(), spacing: 0, alignment: weekGridAlignment)
        }

        let timeGridItem = GridItem(.fixed(timeCellWidth), spacing: 0, alignment: timeGridAlignment)
        var weekGridItem = baseGridItem
        weekGridItem.alignment = weekGridAlignment
        var eventGridItem = baseGridItem
        eventGridItem.alignment = eventGridAlignment

        let dayOfWeek = calendar.component(.weekday, from: date)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: date)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: date) }
            .filter { day in
                weekRange.contains(calendar.component(.weekday, from: day))
            }

        self.days = days
        self.headerView = headerView
        self.weekView = weekView
        self.eventView = eventView
        self.date = date
        weekGridItems = [timeGridItem] + .init(repeating: weekGridItem, count: weekRange.count)
        eventGridItems = [timeGridItem] + .init(repeating: eventGridItem, count: weekRange.count)
        height = eventCellHeight
        width = cellWidth
        self.weekCellHeight = weekCellHeight
        self.timeRange = timeRange
        self.weekRange = weekRange
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView(date)
            LazyVGrid(columns: weekGridItems,
                      spacing: 0,
                      content: {
                          Group {
                              Text("")
                              ForEach(self.days, id: \.self, content: {
                                  weekView($0)
                              })
                          }
                          .frame(width: width, height: weekCellHeight)
                      })

            ScrollView {
                LazyVGrid(columns: eventGridItems,
                          spacing: 0,
                          content: {
                              Group {
                                  ForEach(timeRange, content: { hour in
                                      VStack {
                                          Text("\(hour):00")
                                              .font(.footnote)
                                              .foreground(Color.secondary)
                                      }

                                      ForEach(days, id: \.self) { day in
                                          eventView(
                                              CellInfo(date: day, startHour: hour, endHour: hour + 1, cellWidth: width, cellHeight: height, firstColumn: day == days.first, lastColumn: day == days.last, firstRow: hour == timeRange.lowerBound, lastRow: hour + 1 == timeRange.upperBound)
                                          )
                                          .id(UUID())
                                      }
                                  })
                              }
                              .frame(width: width, height: height)
                              .clipped()
                          })
                          .frame(maxHeight: .infinity)
            }
        }
    }
}

public struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    public func path(in rect: CGRect) -> Path {
        edges.map { edge -> Path in
            switch edge {
            case .top: return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
            case .bottom: return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }.reduce(into: Path()) { $0.addPath($1) }
    }
}

public extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct WeekGridView_Previews: PreviewProvider {
    static var previews: some View {
        WeekGridView(date: Date(), calendar: Calendar.current, headerView: { _ in EmptyView() }, weekView: {
            date in
            Text(Calendar.current.shortWeekdaySymbols[Calendar.current.component(.weekday, from: date) - 1])
        }, eventView: { cell in
            Group {
                ZStack {
                    Color.clear
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .border(width: 1, edges: cell.borderEdge, color: .gray)
                    if cell.startHour == 8 {
                        Rectangle()
                            .offset(y: cell.eventHeight(eventStartTime: .now, eventEndTime: Calendar.current.date(byAdding: .day, value: 1, to: Date.now)!))
                    }
                }
            }
            
        },
        timeRange: 8 ..< 22)
    }
}
