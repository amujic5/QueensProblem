//
//  Game.swift
//  QueensProblem
//
//  Created by Azzaro Mujic on 24.09.2025..
//

import Foundation
import SwiftUI
import Observation


enum CellState: Equatable {
    case empty
    case queen

    var name: String? {
        switch self {
        case .empty:
            return nil
        case .queen:
            return "♛"
        }
    }
}

struct Position: Hashable {
    public let row: Int
    public let column: Int
    public init(row: Int, column: Int) { self.row = row; self.column = column }
}

@Observable
final class Game {
    private(set) var boardSize: Int
    private(set) var board: [[CellState]]
    private(set) var conflicts: Set<Position> = []

    init(boardSize: Int) {
        let size = max(4, boardSize)
        self.boardSize = size
        self.board = Array(repeating: Array(repeating: .empty, count: size), count: size)
    }

    func setBoardSize(_ boardSize: Int) {
        let size = max(4, boardSize)
        self.boardSize = size
        self.board = Array(repeating: Array(repeating: .empty, count: size), count: size)
        self.conflicts.removeAll()
    }

    func reset() {
        board = Array(repeating: Array(repeating: .empty, count: boardSize), count: boardSize)
        conflicts.removeAll()
    }

    var placedCount: Int {
        board.flatMap { $0 }.filter { $0 != .empty }.count
    }

    var isSolved: Bool { placedCount == boardSize && conflicts.isEmpty }

    func toggle(at pos: Position) {
        switch board[pos.row][pos.column] {
        case .empty: board[pos.row][pos.column] = .queen
        case .queen: board[pos.row][pos.column] = .empty
        }
        recalculateConflicts()
    }

    private func recalculateConflicts() {
        conflicts.removeAll()

        var pieces: [Position] = []
        for row in 0..<boardSize {
            for column in 0..<boardSize where board[row][column] != .empty {
                pieces.append(Position(row: row, column: column))
            }
        }
        let pieceSet = Set(pieces)

        // For each piece, compute attacked squares and see if any contain a piece
        for origin in pieces {
            let state = board[origin.row][origin.column]
            let attacks = attackedSquares(from: origin, for: state)

            // Intersect with occupied squares to find conflicts
            let hits = attacks.intersection(pieceSet)
            if !hits.isEmpty {
                conflicts.insert(origin)
                for hit in hits {
                    conflicts.insert(hit)
                }
            }
        }
    }

    private func attackedSquares(from pos: Position, for state: CellState) -> Set<Position> {
        var result: Set<Position> = []

        switch state {
        case .empty:
            break

        case .queen:
            let directions: [(rowStep: Int, columnStep: Int)] = [
                (-1,  0), ( 1,  0), // up, down
                ( 0, -1), ( 0,  1), // left, right
                (-1, -1), (-1,  1), // up-left, up-right
                ( 1, -1), ( 1,  1)  // down-left, down-right
            ]

            for direction in directions {
                var nextRow = pos.row + direction.rowStep
                var nextCol = pos.column + direction.columnStep

                while inBounds(nextRow, nextCol) {
                    let target = Position(row: nextRow, column: nextCol)

                    if board[nextRow][nextCol] == .empty {
                        result.insert(target)
                        nextRow += direction.rowStep
                        nextCol += direction.columnStep
                    } else {
                        result.insert(target)
                        break
                    }
                }
            }
        }
        return result
    }

    private func inBounds(_ r: Int, _ c: Int) -> Bool {
        r >= 0 && r < boardSize && c >= 0 && c < boardSize
    }
}
