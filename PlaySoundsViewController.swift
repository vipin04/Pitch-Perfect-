//
//  PlaySoundsViewController.swift
//  Pitch-Perfect
//
//  Created by Vipin Aggarwal on 03/10/15.
//  Copyright © 2015 Vipin Aggarwal. All rights reserved.
//

import UIKit
import AVFoundation


enum AudioPlayerError : ErrorType {
    case FileNotFound
}

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
        stopAudio()
    }
    
    
    /**
    Play high pitch sound
    */
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        do {
            try playAudioWithVariablePitch(1000)
        }
        catch let unknownError {
            print(" Unknown error occured: \(unknownError).")
        }

    }
    
    /**
    Play low pitch sound
    */
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        do {
            try playAudioWithVariablePitch(-1000)
        }
        catch let unknownError {
            print(" Unknown error occured: \(unknownError).")
        }
    }
    
    
    @IBAction func playWithReverbEffect(sender: AnyObject) {
        do {
            try playAudioWithReverbEffect()
        }
        catch let unknownError {
            print(" Unknown error occured: \(unknownError).")
        }
    }
    
    
    /**
    Helper function to play variable pitch sound
    
    - parameter pitch: value of pitch variying from -2400 to 2400
    - throws: throws error in case fails to start playing audio
    */
    func playAudioWithVariablePitch(pitch:Float) throws {
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch

        try playAudioWithEffect(changePitchEffect)
    }
    
    
    func playAudioWithReverbEffect(preset:AVAudioUnitReverbPreset = .LargeHall) throws{
        
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(preset)
        reverbEffect.wetDryMix = 50
        
        try playAudioWithEffect(reverbEffect)
        
    }
    
    
    /**
    Generic function with uses AVAudioEngine to help play a sound after adding the sound effect
    
    - parameter audioEffect: sound effect
    - parameter audioFormat: default is nil.
    
    */
    func playAudioWithEffect(audioEffect:AVAudioNode, audioFormat:AVAudioFormat! = nil) throws {
        stopAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(audioEffect)
        
        audioEngine.connect(audioPlayerNode, to: audioEffect, format: audioFormat)
        audioEngine.connect(audioEffect, to: audioEngine.outputNode, format: audioFormat)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    

    func playAudioWithSpeed(playBackSpeed: Float) {
        stopAudio()
        audioPlayer.rate = playBackSpeed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func disableButtons () {
        slowPlayButton.enabled = false
        fastPlayButton.enabled = false
        stopPlayButton.enabled = false
    }
    
    
    func stopAudio () {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    /**
    Helper method to check if audio player can play the file and enable its default settings
    
    - throws: throws exception if audio file could not be read
    */
    func prepareaudioPlayer () throws {
        guard let filePathURL = receivedAudio.filePathURL
            else {
                print("Error getting audio file path")
                throw AudioPlayerError.FileNotFound
        }

        try audioPlayer = AVAudioPlayer(contentsOfURL: filePathURL)
        try audioFile =  AVAudioFile(forReading: filePathURL)
        audioPlayer.prepareToPlay()
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
    }
    
}
