//
//  GameView+CellView.swift
//  QueensProblem
//
//  Created by Azzaro Mujic on 24.09.2025..
//

import Foundation
import SwiftUI

struct CellView: View {
    typealias Theme = GameView.Theme

    var isDark: Bool
    var state: CellState
    var conflicted: Bool

    var body: some View {
        ZStack {
            Rectangle().fill(isDark ? Theme.boardDark : Theme.boardLight)
            if let name = state.name {
                Text(name)
                    .font(.system(size: 100).weight(.heavy))
                    .minimumScaleFactor(0.1)
                    .foregroundStyle(Theme.lightPiece)
                    .scaleEffect(conflicted ? 1.05 : 1.0)
                    .shadow(color: .black.opacity(0.15), radius: 3, y: 2)
                    .transition(.scale)
            }
        }
        .overlay(
            Rectangle()
                .inset(by: 1.5)
                .stroke(conflicted ? Theme.accentRed : Color.black.opacity(0.08),
                        lineWidth: conflicted ? 3 : 0.5)
        )
        .animation(.easeInOut(duration: 0.15), value: state)
        .animation(.easeInOut(duration: 0.1), value: conflicted)
    }
}
