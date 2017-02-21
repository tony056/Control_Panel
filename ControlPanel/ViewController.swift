//
//  ViewController.swift
//  ControlPanel
//
//  Created by Tony Tung on 2/16/17.
//  Copyright © 2017 Tony Tung. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    
    @IBAction func typePopUpBtn(_ sender: NSPopUpButton) {
        
    }
    @IBOutlet weak var recordTypeChoice: NSPopUpButton!
    @IBOutlet weak var numOfTrials: NSTextField!
    @IBOutlet weak var userNameTextField: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "infoToTaskSelection" {
            //pass info to next view
            
//             : TaskDisplayViewController  = segue.destinationController as! TaskDisplayViewController
//            
//            vc.userName = userNameTextField.stringValue
            let vc : TaskDisplayViewController = segue.destinationController as! TaskDisplayViewController
            let user = self.userNameTextField.stringValue
            vc.userName = user
            vc.trialNum = Int(self.numOfTrials.stringValue)!
            vc.recordType = Bool(self.recordTypeChoice.indexOfSelectedItem as NSNumber)
        }
    }
    

    
}

