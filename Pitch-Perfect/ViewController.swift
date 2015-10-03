//
//  ViewController.swift
//  Pitch-Perfect
//
//  Created by Vipin Aggarwal on 30/09/15.
//  Copyright © 2015 Vipin Aggarwal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButon: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButon.hidden = true
    }


    @IBAction func recordAudio(sender: UIButton) {
        print("in recordAutdio")
        recordingLabel.hidden = false
        stopButon.hidden = false
    }
    
    
    @IBAction func stopButtonTapped(sender: AnyObject) {
        print("Stop button pressed")
        recordingLabel.hidden = true
        
    }
    

}

 