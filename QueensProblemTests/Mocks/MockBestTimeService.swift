//
//  MockBestTimeService.swift
//  QueensProblemTests
//
//  Created by Azzaro Mujic on 24.09.2025..
//

import Foundation
@testable import QueensProblem

final class MockBestTimeService: BestTimeServicing {
    private(set) var store: [Int: TimeInterval] = [:]
    private(set) var updateCalls: [(boardSize: Int, time: TimeInterval)] = []

    init(initial: [Int: TimeInterval] = [:]) {
        self.store = initial
    }

    func getBestTimes() -> [Int : TimeInterval] {
        store
    }

    @discardableResult
    func updateIfBetter(boardSize: Int, time: TimeInterval) -> Bool {
        updateCalls.append((boardSize, time))
        if let best = store[boardSize] {
            if time < best { store[boardSize] = time; return true }
            return false
        } else {
            store[boardSize] = time
            return true
        }
    }
}
