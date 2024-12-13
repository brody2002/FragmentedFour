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
    var audioOn: Bool = true
    var audioPlayerList: [AVAudioPlayer] = []
    var playingBackgroundMusic: Bool = false
    
    func addPlayer(inputAudioPlayer: AVAudioPlayer) {
        audioPlayerList.append(inputAudioPlayer)
    }
    
    func playSoundEffect(for inputString: String, audioPlayer: inout AVAudioPlayer?) {
        guard audioOn == true else { return }
        let extensionType = "m4a"
        if let url = Bundle.main.url(forResource: inputString, withExtension: extensionType){
            
                audioPlayer = try? AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
        }
        else {
            print("couldn't locate file: \(inputString).\(extensionType)")
            return
        }
    }
    
    func stopAudio(_ audioPlayer: inout AVAudioPlayer?) {
        audioPlayer?.stop()
        audioPlayer = nil // Release the audio player to free resources
    }
    
    func playMusic(for soundName: String, backgroundMusic: Bool) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "m4a") else {
            print("Error: Could not find the sound file named \(soundName).m4a in the bundle.")
            return
        }
        var audioPlayer = AVAudioPlayer()
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            if backgroundMusic { audioPlayer.numberOfLoops = -1 }
            audioPlayer.play()
            audioPlayerList.append(audioPlayer)
        } catch {
            print("Error: Could not play the audio file. \(error.localizedDescription)")
        }
    }

    func setVolume(forAll volume: Float) {
        for player in audioPlayerList {
            player.volume = volume
        }
    }
    
}


