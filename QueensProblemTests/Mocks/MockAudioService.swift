//
//  MockAudioService.swift
//  QueensProblemTests
//
//  Created by Azzaro Mujic on 24.09.2025..
//

import Foundation
@testable import QueensProblem

final class MockAudioService: AudioServicing {
    private(set) var placeCount = 0
    private(set) var removeCount = 0
    private(set) var victoryCount = 0

    func playPlace() { placeCount += 1 }
    func playRemove() { removeCount += 1 }
    func playVictory() { victoryCount += 1 }
}
