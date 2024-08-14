import SwiftUI

public struct CellInfo {
    public let date: Date
    public let startHour: Int
    public let endHour: Int

    public let cellWidth: CGFloat?
    public let cellHeight: CGFloat?
    
    public let firstColumn: Bool
    public let lastColumn: Bool
    public let firstRow: Bool
    public let lastRow: Bool
    
    
    public var borderEdge: [Edge] {
        var edge = [Edge.leading, Edge.bottom]
        if self.firstRow {
            edge += [Edge.top]
        }
        if self.lastColumn {
            edge += [Edge.trailing]
        }
        return edge
    }
    
    public func eventOffset(eventStartTime: Date) -> CGFloat {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: eventStartTime)
        let hour = CGFloat(components.hour ?? 0)
        let minute = CGFloat(components.minute ?? 0)

        let startPercent = minute / 60
        let height = self.cellHeight ?? 0
        return startPercent * height
    }
    
    public func eventHeight(eventStartTime: Date, eventEndTime: Date) -> CGFloat {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: eventStartTime)
        let hour = CGFloat(components.hour ?? 0)
        let minute = CGFloat(components.minute ?? 0)
        let height = self.cellHeight ?? 0
        
        var eventHeight = height
        if Calendar.current.isDate(self.date, equalTo: eventEndTime, toGranularity: .day) && height != 0{
            let components = calendar.dateComponents([.minute], from: eventStartTime, to: eventEndTime)
            eventHeight = (CGFloat(components.minute ?? 0) / 60) * height
        }
        return eventHeight
    }
}
