# Readme

### Overview

An iOS N-Queens puzzle game where you place queens on an n×n board so none attack each other. Built in SwiftUI with Apple’s Observation (@Observable) and a clean MVVM architecture.

### Build & Run

1. Open the project in Xcode.
1. Select the QueensProblem app scheme.
1. Choose an iOS 18.5+ simulator
1. Run the app -> Run (⌘R).

### How to test/play:

- On first launch you choose N (4–16).
- Tap squares to place/remove queens.
- Conflicts highlight; when all N queens are conflict-free, you win.
- Reset keeps the same N; Restart reopens the N picker.
- Best time per N is stored locally and displayed in setup screen (first screen)

### Architecture decisions

- MVVM Architecture

##### Components:

- Game -> pure game logic
- GameViewModel -> screen logic (game + presentation logic) that will be consumed by view
- GameView (and helper Views) -> display logic
- Services - protocol - so that we can inject mocks in unit testing
  - AudioService - used to play audio
  - BestTimeService - to store best times, for simplicity I have used UserDefaults with one key, (biggest downside is when saving, you need to save everything)... better solution would be key per boardSize or CoreData/Realm
- Extensions


## AI assistance disclosure

Some parts were AI was used:

- Victory / SimpleConfettiView
- StartupView
- to play audio sounds
- to write MockServices
- to write UnitTests (I have made clean separation of logic, with Protocolized Services so it was easy to create UnitTests using AI - ChatGpt)
