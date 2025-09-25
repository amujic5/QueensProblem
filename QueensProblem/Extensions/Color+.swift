//
//  Color+.swift
//  QueensProblem
//
//  Created by Azzaro Mujic on 24.09.2025..
//

import Foundation
import SwiftUI

extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xff) / 255
        let g = Double((hex >> 8) & 0xff) / 255
        let b = Double(hex & 0xff) / 255
        self = Color(red: r, green: g, blue: b, opacity: alpha)
    }
}
