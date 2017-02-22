//
//  TaskDisplayViewController.swift
//  ControlPanel
//
//  Created by Tony Tung on 2/19/17.
//  Copyright © 2017 Tony Tung. All rights reserved.
//

import Cocoa
import ProgressKit
import AVKit
import AVFoundation

class TaskDisplayViewController: NSViewController {

    let tasks = ["Tap", "Swipe Up"	, "Swipe Down", "Swipe Right", "Swipe left", "Pinch In", "Pinch Out"]
    let tasks_for_name = ["Tap", "SwipeUp"	, "SwipeDown", "SwipeRight", "SwipeLeft", "PinchIn", "PinchOut"]
    let instructions = [Constants.START_HINT, Constants.STOP_HINT]
    
    var userName : String = ""
    var recordType : Bool = false // 0 is for training set, 1 is for evaluation set
    var isRecording : Bool = false
    var trialNum : Int = 3
    var currentTask : Int = 0
    var currentTrialNum : Int = 1
    var avPlayer = AVPlayer()
    var avPlayerLayer : AVPlayerLayer!
    
    
    @IBOutlet weak var videoDisplayView: NSView!
    @IBOutlet weak var waitingProgress: NSView!
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(progressBarStatus), name: Notification.Name(rawValue: "ok"), object: nil)
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.avPlayer.currentItem, queue: nil, using: {_ in 
            let seekTime = CMTimeMake(0, 1)
            self.avPlayer.seek(to: seekTime)
            self.avPlayer.play()
        })
    }
    
    func progressBarStatus() {
        self.waitingProgress.isHidden = !self.waitingProgress.isHidden
        self.updateStatus()
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
        progressWaiting()
//        updateUI()
    }
    
    func progressWaiting(){
        print("waiting")
        self.waitingProgress.isHidden = false
        if !self.waitingProgress.isHidden {
            let view = self.waitingProgress.subviews[0] as! MaterialProgress
            view.animate = true
        }
    }
    
    func finishTrial(){
        //send stop message
        //updateUI
        stopAction(content: "")
//        updateStatus()
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
        
        updateUI()
    }
    
    func updateUI(){
        self.displayTaskLabel.stringValue = "" + self.tasks[self.currentTask]
        self.displayTrialLabel.stringValue = "" + String(self.currentTrialNum) + " / " + String(self.trialNum)
        self.instructionLabel.stringValue = self.instructions[Int(NSNumber(value: self.isRecording))]
        self.loadVideoToView()
    }
    
    func initUI(){
        
        ControlManager.shareInstance.sendChannelInfo(user: self.userName)
        self.waitingProgress.isHidden = true
        self.loadVideoToView()
    }
    
    func startAction(content: String){
        ControlManager.shareInstance.sendStartMessage(file: content)
    }
    
    func stopAction(content: String){
        ControlManager.shareInstance.sendStopMessage()
    }
    
    func getFileName() -> String{
        var fileName = self.userName + "_"
        fileName += String(Int(NSNumber(value: self.recordType))) + "_"
        fileName += self.tasks_for_name[self.currentTask] + "_"
        fileName += String(self.currentTrialNum)
        return fileName
    }
    
    func loadVideoToView(){
//        Bundle.main.resourcePath + "/" + 
        if let filePath = Bundle.main.path(forResource: "Task_" + String(self.currentTask + 1), ofType: "m4v") {
            
            let fileURL = URL(fileURLWithPath: filePath)
            
            self.avPlayer = AVPlayer(url: fileURL)
            self.avPlayerLayer = AVPlayerLayer(player: self.avPlayer)
            self.videoDisplayView.wantsLayer = true
            self.avPlayerLayer.frame = self.videoDisplayView.bounds
//            self.videoDisplayView.layer?.insertSublayer(videoLayer, at: 0)
            self.videoDisplayView.layer?.addSublayer(self.avPlayerLayer)
            self.avPlayer.play()
        }
        
    }
    
    
}
