//
//  GameViewModelTests.swift
//  QueensProblemTests
//
//  Created by Azzaro Mujic on 24.09.2025..
//

import Testing
@testable import QueensProblem

@Suite struct GameViewModelTests {
    @Test func tapCell_places_then_removes_and_calls_audioService() async throws {
        let audioService = MockAudioService()
        let bestTimesService = MockBestTimeService()
        let viewModel = GameViewModel(boardSize: 4, bestTimesService: bestTimesService, audioService: audioService)

        // Place at (0,0)
        viewModel.tapCell(row: 0, column: 0)
        #expect(viewModel.board[0][0] == .queen)
        #expect(viewModel.placedCount == 1)
        #expect(viewModel.isRunning)
        #expect(audioService.placeCount == 1)
        #expect(audioService.removeCount == 0)

        // Remove at (0,0)
        viewModel.tapCell(row: 0, column: 0)
        #expect(viewModel.board[0][0] == .empty)
        #expect(viewModel.placedCount == 0)
        #expect(audioService.placeCount == 1)
        #expect(audioService.removeCount == 1)

        // cleanup timer
        viewModel.resetBoard()
        #expect(viewModel.isRunning == false)
        #expect(viewModel.elapsed == 0)
    }

    @Test func restartBoard_sets_showStartup_true_and_clears_state() async throws {
        let audioService = MockAudioService()
        let bestTimesService = MockBestTimeService()
        let viewModel = GameViewModel(boardSize: 4, bestTimesService: bestTimesService, audioService: audioService)

        viewModel.tapCell(row: 0, column: 0)
        #expect(viewModel.placedCount == 1)
        #expect(viewModel.isRunning)

        viewModel.restartBoard()
        #expect(viewModel.showStartup)
        #expect(viewModel.placedCount == 0)
        #expect(viewModel.isRunning == false)
        #expect(viewModel.elapsed == 0)
    }

    @Test func setBoardSize_updates_n_and_stops_timer() async throws {
        let audioService = MockAudioService()
        let bestTimesService = MockBestTimeService()
        let viewModel = GameViewModel(boardSize: 4, bestTimesService: bestTimesService, audioService: audioService)

        viewModel.tapCell(row: 0, column: 0) // start timer
        #expect(viewModel.isRunning)

        viewModel.setBoardSize(6)
        #expect(viewModel.boardSize == 6)
        #expect(viewModel.isRunning == false)
        #expect(viewModel.elapsed == 0)
        #expect(viewModel.showStartup == false)
        #expect(viewModel.placedCount == 0)
    }

    @Test func refreshBestTimes_reads_from_service() async throws {
        let audioService = MockAudioService()
        let bestTimesService = MockBestTimeService(initial: [4: 12.34, 8: 56.78])
        let viewModel = GameViewModel(boardSize: 4, bestTimesService: bestTimesService, audioService: audioService)

        viewModel.refreshBestTimes()
        #expect(viewModel.bestTimes[4] == 12.34)
        #expect(viewModel.bestTimes[8] == 56.78)
    }

    @Test func solving_triggers_victory_audioService_and_bestTimesService_time_update() async throws {
        let audioService = MockAudioService()
        let bestTimesService = MockBestTimeService()
        let viewModel = GameViewModel(boardSize: 4, bestTimesService: bestTimesService, audioService: audioService)

        let solution = [
            Position(row: 0, column: 1),
            Position(row: 1, column: 3),
            Position(row: 2, column: 0),
            Position(row: 3, column: 2),
        ]
        solution.forEach { viewModel.tapCell(row: $0.row, column: $0.column) }

        #expect(viewModel.didWin)
        #expect(viewModel.isRunning == false)         // timer stopped
        #expect(audioService.victoryCount == 1)       // played victory once
        #expect(bestTimesService.updateCalls.count == 1)   // bestTimesService-time attempted once
        #expect(bestTimesService.store[4] != nil)          // bestTimesService time stored for N=4
        #expect(viewModel.bestTimes[4] == bestTimesService.store[4]) // viewModel refreshed after updateIfBetter
    }
}
