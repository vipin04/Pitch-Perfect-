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
    
    var player:AVAudioPlayer = AVAudioPlayer();
    
    @IBOutlet weak var slowPlayButton: UIButton!
    @IBOutlet weak var fastPlayButton: UIButton!
    @IBOutlet weak var stopPlayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try preparePlayer()
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
        player.stop()
        
    }
    
    func playAudioWithSpeed(playBackSpeed: Float) {
        player.stop()
        player.rate = playBackSpeed
        player.currentTime = 0.0
        player.play()
    }
    
    func disableButtons () {
        slowPlayButton.enabled = false
        fastPlayButton.enabled = false
        stopPlayButton.enabled = false
    }
    
    func preparePlayer () throws {
        if let filePathURL = NSBundle.mainBundle().URLForResource("movie_quote", withExtension: "mp3") {
            try player = AVAudioPlayer(contentsOfURL: filePathURL)
            player.prepareToPlay()
            player.enableRate = true
            
        }
        else {
            print("Error getting audo file path")
            throw AudioPlayerError.FileNotFound
        }
    }
    
}


enum AudioPlayerError : ErrorType {
    case FileNotFound
}