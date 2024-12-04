//
//  AudioPlayer.swift
//  FragmentedFour
//
//  Created by Brody on 12/4/24.
//

import Foundation
import AVFoundation
import SwiftUI

@Observable
class GlobalAudioSettings: ObservableObject {
    static let shared = GlobalAudioSettings()
    var audioOn: Bool = true
    var audioPlayerList: [AVAudioPlayer] = []
    
    func addPlayer(inputAudioPlayer: AVAudioPlayer) {
        audioPlayerList.append(inputAudioPlayer)
    }
    
    func playSound(for soundName: String, backgroundMusic: Bool) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "m4a") else {
            print("Error: Could not find the sound file named \(soundName).m4a in the bundle.")
            return
        }
        var audioPlayer = AVAudioPlayer()
        do { // Try to initialize the audio player
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            if backgroundMusic { audioPlayer.numberOfLoops = -1 } // Set your desired number of loops (-1 for infinite)
            audioPlayer.play()
            audioPlayerList.append(audioPlayer)
        } catch { // Print an error message in case of failure
            print("Error: Could not play the audio file. \(error.localizedDescription)")
        }
    }

    func setVolume(forAll volume: Float) {
        for player in audioPlayerList {
            player.volume = volume
        }
    }
    
}


