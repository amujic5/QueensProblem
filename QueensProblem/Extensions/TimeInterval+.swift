//
//  TimeInterval+.swift
//  QueensProblem
//
//  Created by Azzaro Mujic on 24.09.2025..
//

import Foundation

extension TimeInterval {
    var formattedTimeString: String {
        let m = Int(self) / 60
        let s = Int(self) % 60
        let ms = Int((self - floor(self)) * 100)
        return String(format: "%02d:%02d.%02d", m, s, ms)
    }
}
