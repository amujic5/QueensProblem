//
//  AudioService.swift
//  QueensProblem
//
//  Created by Azzaro Mujic on 24.09.2025..
//

import Foundation
import AVFoundation
import SwiftUI

protocol AudioServicing {
    func playPlace()
    func playRemove()
    func playVictory()

}

class AudioService: AudioServicing {
    func playPlace() {
        AudioServicesPlaySystemSound(1104)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    func playRemove() { UIImpactFeedbackGenerator(style: .soft).impactOccurred() }

    func playVictory() {
        AudioServicesPlaySystemSound(1025)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
