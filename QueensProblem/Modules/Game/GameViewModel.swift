//
//  GameViewModel.swift
//  QueensProblem
//
//  Created by Azzaro Mujic on 23.09.2025..
//

import Foundation
import SwiftUI
import Observation

@Observable
final class GameViewModel {
    private var game: Game
    private let bestTimesService: BestTimeServicing
    private let audioService: AudioServicing
    private(set) var isRunning: Bool = false
    private var startDate: Date?
    private var timer: Timer?

    var elapsed: TimeInterval = 0
    var showStartup = true
    var draftN: Double = 8
    var didWin: Bool = false

    init(boardSize: Int = 8, bestTimesService: BestTimeServicing = BestTimeService(), audioService: AudioServicing = AudioService()) {
        self.game = Game(boardSize: boardSize)
        self.bestTimesService = bestTimesService
        self.audioService = audioService
    }

    // MARK: - Intents
    func tapCell(row: Int, column: Int) {
        guard !didWin else { return }
        startTimerIfNeeded()
        let beforeState = game.board[row][column]
        game.toggle(at: Position(row: row, column: column))
        if beforeState == .empty {
            audioService.playPlace()
        } else {
            audioService.playRemove()
        }
        finishGameIfSolved()
    }

    func resetBoard() {
        game.reset();
        didWin = false;
        stopTimer(resetElapsed: true)
    }

    func restartBoard() {
        resetBoard()
        showStartup = true
    }

    func setBoardSize(_ newN: Int) {
        game.setBoardSize(newN);
        didWin = false;
        stopTimer(resetElapsed: true)
        showStartup = false
    }

    // MARK: - Derived
    var boardSize: Int { game.boardSize }
    var board: [[CellState]] { game.board }
    var conflicts: Set<Position> { game.conflicts }
    var placedCount: Int { game.placedCount }
    var bestTimes: [Int: TimeInterval] { bestTimesDict }
    private(set) var bestTimesDict: [Int: TimeInterval] = [:]

    func refreshBestTimes() {
        bestTimesDict = bestTimesService.getBestTimes()
    }

    // MARK: - Win handling
    private func finishGameIfSolved() {
        if game.isSolved {
            didWin = true
            stopTimer()
            if bestTimesService.updateIfBetter(boardSize: boardSize, time: elapsed) {
                refreshBestTimes()
            }
            audioService.playVictory()
        }
    }

    // MARK: - Timer
    private func startTimerIfNeeded() {
        guard !isRunning else { return }
        isRunning = true
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self, let start = self.startDate else { return }
            self.elapsed = Date().timeIntervalSince(start)
        }
    }

    private func stopTimer(resetElapsed: Bool = false) {
        timer?.invalidate(); timer = nil
        isRunning = false
        if resetElapsed { elapsed = 0; startDate = nil }
    }
}
