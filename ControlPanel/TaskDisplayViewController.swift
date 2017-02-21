//
//  TaskDisplayViewController.swift
//  ControlPanel
//
//  Created by Tony Tung on 2/19/17.
//  Copyright © 2017 Tony Tung. All rights reserved.
//

import Cocoa

class TaskDisplayViewController: NSViewController {

    let tasks = ["Tap", "Swipe Up"	, "Swipe Down", "Swipe Right", "Swipe left", "Pinch In", "Pinch Out"]
    let tasks_for_name = ["Tap", "SwipeUp"	, "SwipeDown", "SwipeRight", "SwipeLeft", "PinchIn", "PinchOut"]
    let instructions = ["Start", "Stop"]
    
    var userName : String = ""
    var recordType : Bool = 0 // 0 is for training set, 1 is for evaluation set
    var isRecording : Bool = false
    var trialNum : Int = 3
    var currentTask : Int = 0
    var currentTrialNum : Int = 1
    
    
    @IBOutlet weak var instructionLabel: NSTextField!
    @IBOutlet weak var displayTrialLabel: NSTextField!
    @IBOutlet weak var displayTaskLabel: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        initUI()
        updateUI()
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            (event) -> NSEvent! in
            self.keyDown(with: event)
            return event
        }
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
            case 0x31:
                print("space key")
                //toggle Trial
                toggleTrial()
                break
            case 0x24:
                print("enter")
                //next task
                break
            case 0x7B:
                //left arrow, back to last trial
                break
            case 0x7C:
                //right arrow
                break
            default:
                NSLog("nothing")
        }
    }
    
    func toggleTrial(){
        if self.isRecording == true {
            //send stop message
            finishTrial()
        } else {
            //send start message
            startTrial()
        }
        self.isRecording = !self.isRecording
        updateUI()
    }
    
    func finishTrial(){
        //send stop message
        //updateUI
        stopAction(content: "")
        updateStatus()
    }
    
    func startTrial(){
        startAction(content: self.getFileName())
    }
    
    func updateStatus(){
        if self.currentTrialNum < self.trialNum {
            self.currentTrialNum += 1
        } else {
            self.currentTrialNum = 1
            self.currentTask += 1
        }
        
        if self.currentTask == self.tasks.count {
            //finish program
            return
        }
        
//        updateUI()
    }
    
    func updateUI(){
        self.displayTaskLabel.stringValue = "" + self.tasks[self.currentTask]
        self.displayTrialLabel.stringValue = "" + String(self.currentTrialNum) + " / " + String(self.trialNum)
        self.instructionLabel.stringValue = self.instructions[Int(NSNumber(value: self.isRecording))]
    }
    
    func initUI(){
        self.displayTrialLabel.alignment = .center
        let tf : NSTextField = self.displayTrialLabel
        let stringHeight : CGFloat = self.displayTrialLabel.attributedStringValue.size().height
        let frame = self.displayTrialLabel.frame
        var titleRect: NSRect = self.displayTrialLabel.cell!.titleRect(forBounds: frame)
        
        titleRect.size.height = stringHeight + ( stringHeight - (tf.font!.ascender + tf.font!.descender ) )
        titleRect.origin.y = frame.size.height / 2  - tf.lastBaselineOffsetFromBottom - tf.font!.xHeight / 2
        tf.frame = titleRect
        
        ControlManager.shareInstance.sendChannelInfo(user: self.userName)
    }
    
    func startAction(content: String){
        ControlManager.shareInstance.sendStartMessage(file: content)
    }
    
    func stopAction(content: String){
        ControlManager.shareInstance.sendStopMessage()
    }
    
    func getFileName() -> String{
        var fileName = self.userName + "_"
        fileName += Int(NSNumber(value: self.recordType)) + "_"
        fileName += self.tasks_for_name[self.currentTask] + "_"
        fileName += String(self.currentTrialNum)
        return fileName
    }
    
    
}
