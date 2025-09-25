//
//  BestTimeService.swift
//  QueensProblem
//
//  Created by Azzaro Mujic on 24.09.2025..
//

import Foundation

protocol BestTimeServicing {
    func getBestTimes() -> [Int: TimeInterval]
    @discardableResult
    func updateIfBetter(boardSize: Int, time: TimeInterval) -> Bool
}

struct BestTimeService: BestTimeServicing {
    private let key = "nqueens.bestTimes.codable.v1"
    private struct Store: Codable {
        var times: [Int: TimeInterval]
    }

    private func bestTime(for n: Int) -> TimeInterval? {
        load()[n]
    }

    func getBestTimes() -> [Int: TimeInterval] {
        load()
    }

    @discardableResult
    func updateIfBetter(boardSize: Int, time: TimeInterval) -> Bool {
        var dict = load()
        let wasBetter: Bool
        if let best = dict[boardSize] { wasBetter = time < best } else { wasBetter = true }
        if wasBetter { dict[boardSize] = time; save(dict) }
        return wasBetter
    }

    private func load() -> [Int: TimeInterval] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [:] }
        if let decoded = try? JSONDecoder().decode(Store.self, from: data) { return decoded.times }
        return [:]
    }

    private func save(_ dict: [Int: TimeInterval]) {
        let data = try? JSONEncoder().encode(Store(times: dict))
        UserDefaults.standard.set(data, forKey: key)
    }
}
