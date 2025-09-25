//
//  GameView+StartupView.swift
//  QueensProblem
//
//  Created by Azzaro Mujic on 24.09.2025..
//

import Foundation
import SwiftUI

extension GameView {
    struct StartupView: View {
        @Binding var draftN: Double
        var bestTimes: [Int: TimeInterval]
        var onStart: (_ boardSize: Int) -> Void

        var body: some View {
            NavigationStack {
                Form {
                    Section("Choose Board Size") {
                        Slider(value: $draftN, in: 4...16, step: 1) {
                            Text("N")
                        } minimumValueLabel: {
                            Text("4")
                        } maximumValueLabel: {
                            Text("16")
                        }
                        Text("N = \(Int(draftN))")
                    }
                    if !bestTimes.isEmpty {
                        Section("Best Times") {
                            ForEach(bestTimes.keys.sorted(), id: \.self) { k in
                                HStack {
                                    Text("N=\(k)")
                                    Spacer()
                                    Text(bestTimes[k]?.formattedTimeString ?? "-")
                                        .monospacedDigit().foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Setup")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Start") {
                            onStart(Int(draftN))
                        }
                    }
                }
            }
        }
    }
}
