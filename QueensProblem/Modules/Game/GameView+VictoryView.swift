//
//  GameView+VictoryView.swift
//  QueensProblem
//
//  Created by Azzaro Mujic on 24.09.2025..
//

import Foundation
import SwiftUI

extension GameView {
    struct VictoryView: View {
        let boardSize: Int
        let elapsedText: String
        let onPlayAgain: () -> Void
        let onChangeSize: () -> Void

        var confettiCount: Int = 200
        var confettiColors: [Color] = [
            Theme.textOnGreen,
            Theme.boardDark,
            Theme.accentRed,
            Theme.lightPiece,
            .yellow,
            .blue
        ]

        var body: some View {
            ZStack {
                Color.black.opacity(0.3).ignoresSafeArea()

                SimpleConfettiView(colors: confettiColors, count: confettiCount)

                VStack(spacing: 14) {
                    Text("Victory!!!")
                        .foregroundStyle(Theme.textOnGreen)
                        .font(.largeTitle.bold())

                    Text("\(boardSize) queens placed in \(elapsedText)")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Theme.textOnGreen)

                    HStack(spacing: 10) {
                        Button("Play Again", action: onPlayAgain)
                            .buttonStyle(.bordered)
                            .foregroundStyle(Theme.textOnGreen)

                        Button("Change Size", action: onChangeSize)
                            .buttonStyle(.bordered)
                            .foregroundStyle(Theme.textOnGreen)
                    }
                }
                .padding(24)
                .background(Theme.boardDark, in: RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 20)
                .transition(.scale)
            }
        }
    }

}

private struct SimpleConfettiView: View {
    let colors: [Color]
    let count: Int

    @State private var pieces: [Piece] = []
    @State private var launch = false

    struct Piece: Identifiable {
        let id = UUID()
        let x: CGFloat
        let size: CGSize
        let color: Color
        let duration: Double
        let delay: Double
        let rotation: Double
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(pieces) { p in
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .fill(p.color)
                        .frame(width: p.size.width, height: p.size.height)
                        .position(x: p.x, y: launch ? geo.size.height + 60 : -60)
                        .rotationEffect(.degrees(launch ? p.rotation : 0))
                        .opacity(launch ? 1 : 0)
                        .animation(.linear(duration: p.duration).delay(p.delay), value: launch)
                }
            }
            .onAppear {
                pieces = (0..<count).map { _ in
                    Piece(
                        x: CGFloat.random(in: 0...max(geo.size.width, 1)),
                        size: CGSize(width: .random(in: 6...12), height: .random(in: 10...18)),
                        color: colors.randomElement() ?? .white,
                        duration: Double.random(in: 2.0...3.5),
                        delay: Double.random(in: 0.0...0.6),
                        rotation: Double.random(in: 180...900)
                    )
                }

                Task { @MainActor in
                    launch = true
                }
            }
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
    }
}
