//
//  GameTests.swift
//  QueensProblemTests
//
//  Created by Azzaro Mujic on 24.09.2025..
//

import Testing
@testable import QueensProblem

@Suite struct GameTests {

    @Test func init_clampsMinN() async throws {
        let game = Game(boardSize: 2)
        #expect(game.boardSize == 4)
        #expect(game.board.count == 4)
    }

    @Test func initial_state_is_empty() async throws {
        let game = Game(boardSize: 8)
        #expect(game.placedCount == 0)
        #expect(game.conflicts.isEmpty)
        #expect(game.isSolved == false)
    }

    @Test func toggle_place_and_remove() async throws {
        let game = Game(boardSize: 4)
        let position = Position(row: 0, column: 0)

        game.toggle(at: position)
        #expect(game.board[0][0] == .queen)
        #expect(game.placedCount == 1)

        game.toggle(at: position)
        #expect(game.board[0][0] == .empty)
        #expect(game.placedCount == 0)
    }

    @Test func detects_row_conflict() async throws {
        let game = Game(boardSize: 4)
        game.toggle(at: .init(row: 0, column: 0))
        game.toggle(at: .init(row: 0, column: 3))

        #expect(game.conflicts.contains(.init(row: 0, column: 0)))
        #expect(game.conflicts.contains(.init(row: 0, column: 3)))
        #expect(game.conflicts.count == 2)
        #expect(game.isSolved == false)
    }

    @Test func detects_diagonal_conflict() async throws {
        let game = Game(boardSize: 4)
        game.toggle(at: .init(row: 0, column: 1))
        game.toggle(at: .init(row: 1, column: 2))

        #expect(game.conflicts.contains(.init(row: 0, column: 1)))
        #expect(game.conflicts.contains(.init(row: 1, column: 2)))
    }

    @Test func known_solution_N4_marks_solved() async throws {
        let game = Game(boardSize: 4)
        let solution = [
            Position(row: 0, column: 1),
            Position(row: 1, column: 3),
            Position(row: 2, column: 0),
            Position(row: 3, column: 2),
        ]
        solution.forEach { game.toggle(at: $0) }

        #expect(game.placedCount == 4)
        #expect(game.conflicts.isEmpty)
        #expect(game.isSolved)
    }

    @Test func reset_clears_board_and_conflicts() async throws {
        let game = Game(boardSize: 4)
        game.toggle(at: .init(row: 0, column: 1))
        game.toggle(at: .init(row: 1, column: 3))
        #expect(game.placedCount == 2)

        game.reset()

        #expect(game.placedCount == 0)
        #expect(game.conflicts.isEmpty)
        #expect(game.board.count == 4 && game.board.allSatisfy { $0.count == 4 })
    }

    @Test func resizing_rebuilds_board_and_clears_state() async throws {
        let game = Game(boardSize: 4)
        game.toggle(at: .init(row: 0, column: 1))
        game.setBoardSize(6)

        #expect(game.boardSize == 6)
        #expect(game.board.count == 6 && game.board.allSatisfy { $0.count == 6 })
        #expect(game.placedCount == 0)
        #expect(game.conflicts.isEmpty)
    }

    @Test func ray_blocking_behavior_on_row() async throws {
        let game = Game(boardSize: 8)
        // Place three queens on the same row; the middle should block rays from the leftmost to the rightmost.
        game.toggle(at: .init(row: 0, column: 0))
        game.toggle(at: .init(row: 0, column: 3))
        game.toggle(at: .init(row: 0, column: 5))

        // All three are in conflict (middle attacks both ends; ends attack the middle).
        #expect(game.conflicts.contains(.init(row: 0, column: 0)))
        #expect(game.conflicts.contains(.init(row: 0, column: 3)))
        #expect(game.conflicts.contains(.init(row: 0, column: 5)))
    }
}
