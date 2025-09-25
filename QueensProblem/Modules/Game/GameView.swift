import SwiftUI
import Observation

struct GameView: View {
    @State private var viewModel = GameViewModel(boardSize: 8)

    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            header
            board
            footer
            Spacer()
        }
        .padding(16)
        .background(Theme.screenGreen.ignoresSafeArea())
        .sheet(isPresented: $viewModel.showStartup) {
            StartupView(draftN: $viewModel.draftN, bestTimes: viewModel.bestTimes) { n in
                viewModel.setBoardSize(n);
            }
            .onAppear {
                viewModel.refreshBestTimes()
            }
        }
        .overlay {
            victoryOverlay
        }
    }

    // MARK: UI Sections
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Board: \(viewModel.boardSize)×\(viewModel.boardSize)")
                .font(.title.weight(.bold))
                .foregroundStyle(Theme.textOnGreen)

            HStack(spacing: 12) {
                Label("\(viewModel.placedCount)/\(viewModel.boardSize) queens", systemImage: "crown.fill")
                Label(viewModel.elapsed.formattedTimeString, systemImage: "timer")
            }
            .font(.subheadline)
            .foregroundStyle(Theme.textOnGreen)
        }
    }

    private var board: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let cell = size / CGFloat(viewModel.boardSize)
            VStack(spacing: 0) {
                ForEach(0..<viewModel.boardSize, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<viewModel.boardSize, id: \.self) { column in
                            CellView(
                                isDark: (row + column) % 2 == 1,
                                state: (row < viewModel.board.count && column < viewModel.board[row].count ? viewModel.board[row][column] : .empty),
                                conflicted: viewModel.conflicts.contains(.init(row: row, column: column))
                            )
                            .frame(width: cell, height: cell)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.tapCell(row: row, column: column)
                            }
                        }
                    }
                }
            }
            .frame(width: size, height: size)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(1, contentMode: .fit)
        .padding(.vertical, 8)
    }

    private var footer: some View {
        HStack(spacing: 12) {
            // Reset board with the current N
            Button {
                viewModel.resetBoard()
            } label: {
                Label("Reset", systemImage: "arrow.uturn.backward")
                    .font(.headline.weight(.bold))
            }
            .buttonStyle(.bordered)
            .foregroundStyle(Theme.textOnGreen)

            // Restart: open the N picker
            Button {
                viewModel.restartBoard()
            } label: {
                Label("Restart", systemImage: "arrow.clockwise")
                    .font(.headline.weight(.bold))
            }
            .buttonStyle(.bordered)
            .foregroundStyle(Theme.textOnGreen)

            Spacer()

            Text(viewModel.conflicts.isEmpty ? "Valid so far" : "Conflicts: \(viewModel.conflicts.count)")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(viewModel.conflicts.isEmpty ? Theme.textOnGreen : Theme.accentRed)
        }
    }

    private var victoryOverlay: some View {
        Group {
            if viewModel.didWin {
                VictoryView(
                    boardSize: viewModel.boardSize,
                    elapsedText: viewModel.elapsed.formattedTimeString,
                    onPlayAgain: { viewModel.resetBoard() },
                    onChangeSize: { viewModel.restartBoard() }
                )
                .animation(.spring(response: 0.45, dampingFraction: 0.85), value: viewModel.didWin)
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.85), value: viewModel.didWin)
    }
}

// MARK: - Preview
#Preview { GameView() }
