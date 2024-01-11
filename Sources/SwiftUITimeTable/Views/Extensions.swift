//
//  Extensions.swift
//

import SwiftUI

extension View {
    func foreground(_ color: Color) -> some View {
        Group {
            if #available(iOS 15.0, macOS 12.0, *) {
                self.foregroundStyle(color)
            } else {
                self.foregroundColor(color)
            }
        }
    }
}
