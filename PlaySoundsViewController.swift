//
//  PlaySoundsViewController.swift
//  Pitch-Perfect
//
//  Created by Vipin Aggarwal on 03/10/15.
//  Copyright © 2015 Vipin Aggarwal. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer = AVAudioPlayer();
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    @IBOutlet weak var slowPlayButton: UIButton!
    @IBOutlet weak var fastPlayButton: UIButton!
    @IBOutlet weak var stopPlayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try prepareaudioPlayer()
        }
        catch {
            print("Error occured", error)
            disableButtons()
        }
    }
    
    
    @IBAction func playSlowAudioTapped(sender: UIButton) {
        playAudioWithSpeed(0.5)
    }
    
    
    @IBAction func playFastAudioTapped(sender: UIButton) {
        playAudioWithSpeed(2.0)
    }
    
    @IBAction func stopPressed(sender: UIButton) {
        audioPlayer.stop()
        
    }
    
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        do {
            try playAudioWithVariablePitch(1000)
        }
        catch let unknownError {
            print(" Unknown error occured: \(unknownError).")
        }

    }
    
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        do {
            try playAudioWithVariablePitch(-1000)
        }
        catch let unknownError {
            print(" Unknown error occured: \(unknownError).")
        }
    }
    
    func playAudioWithVariablePitch(pitch:Float) throws {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try audioEngine.start()
        
        audioPlayerNode.play()
        
    }
    
    func playAudioWithSpeed(playBackSpeed: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.rate = playBackSpeed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func disableButtons () {
        slowPlayButton.enabled = false
        fastPlayButton.enabled = false
        stopPlayButton.enabled = false
    }
    
    func prepareaudioPlayer () throws {
        guard let filePathURL = receivedAudio.filePathURL
            else {
                print("Error getting audo file path")
                throw AudioPlayerError.FileNotFound
        }

        try audioPlayer = AVAudioPlayer(contentsOfURL: filePathURL)
        try audioFile =  AVAudioFile(forReading: filePathURL)
        audioPlayer.prepareToPlay()
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
    }
    
}


enum AudioPlayerError : ErrorType {
    case FileNotFound
}