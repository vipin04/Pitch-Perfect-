//
//  RecordSoundsViewController.swift
//  Pitch-Perfect
//
//  Created by Vipin Aggarwal on 30/09/15.
//  Copyright © 2015 Vipin Aggarwal. All rights reserved.
//

import UIKit
import AVFoundation

enum RecordingState {
    case Stopped
    case Recording
    case Paused
}


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButon: UIButton!
    @IBOutlet weak var pausePlayButton: UIButton!
    @IBOutlet weak var finishRecordingLabel: UILabel!
    
    //Declared Globally
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var recordingState = RecordingState.Stopped
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        visualSetupBeforeRecordStart()
    }
    
    
    @IBAction func recordAudio(sender: UIButton) {
        print("in recordAutdio")
        visualSetupAfterRecordStart()
        recordingState = .Recording
        
        //Inside func recordAudio(sender: UIButton)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.delegate = self
        audioRecorder.record()
    }
    
    
    
    @IBAction func pausePlayButtonTapped(sender: AnyObject) {
        switch recordingState {
        case .Paused:
            recordingLabel.text = "Recording"
            audioRecorder.record()
            recordingState = .Recording
            if let playButtonImage = UIImage(named: "pauseButton") {
                pausePlayButton.setImage(playButtonImage, forState: .Normal)
            }

        case .Recording:
            recordingLabel.text = "Paused"
            audioRecorder.pause()
            recordingState = .Paused
            if let playButtonImage = UIImage(named: "playButton") {
                pausePlayButton.setImage(playButtonImage, forState: .Normal)
            }
            
        default:
            stopButtonTapped(self)
        }
    }
    
    
    @IBAction func stopButtonTapped(sender: AnyObject) {
        recordingState = .Stopped
        recordingLabel.hidden = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if (flag) {
            recordedAudio = RecordedAudio();
            recordedAudio.filePathURL = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        
    }
    
    
    func visualSetupBeforeRecordStart () {
        recordButton.enabled = true
        recordingLabel.text = "Tap on Mic to start recording voice"
        pausePlayButton.hidden = true
        stopButon.hidden = true
        finishRecordingLabel.hidden = true
        
        if let playButtonImage = UIImage(named: "pauseButton") {
            pausePlayButton.setImage(playButtonImage, forState: .Normal)
        }
        
    }
    
    func visualSetupAfterRecordStart () {
        recordButton.enabled = false
        recordingLabel.text = "Recording"
        pausePlayButton.hidden = false
        stopButon.hidden = false
        finishRecordingLabel.hidden = false
    }
    
}

 