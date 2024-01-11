//
//  SwiftUIView.swift
//

import SwiftUI

public struct DefaultHeaderView: View {
    var date: Date

    @Environment(\.calendar) var calendar

    var year: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: date)
    }
    public init(date: Date) {
        self.date = date
    }
    public var body: some View {
        HStack {
            Spacer()
            Text("\(year)")
            Spacer()
        }
    }
}

public struct DefaultWeekView: View {
    var date: Date
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }()
    public init(date: Date) {
        self.date = date
    }
    public var body: some View {
        VStack {
            Text(Calendar.current.shortWeekdaySymbols[Calendar.current.component(.weekday, from: date) - 1])
            Text(DefaultWeekView.formatter.string(from: date))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .font(.footnote)
                .foreground(.secondary)
        }
    }
}

public struct DefaultEventView: View {
    public init() {}
    public var body: some View {
        Color.clear
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .border(.gray, width: 0.3)
    }
}
