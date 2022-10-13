//
//  PlaySound.swift
//  Demo
//
//  Created by Katrina Orevillo on 10/12/22.
//  Copyright © 2022 NPE INC. All rights reserved.
//

import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("error: couldn't find and play sound file")
        }
    }
}
