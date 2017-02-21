//
//  ControlManager.swift
//  ControlPanel
//
//  Created by Tony Tung on 2/19/17.
//  Copyright © 2017 Tony Tung. All rights reserved.
//

import Cocoa
import SwiftyJSON

class ControlManager: NSObject {
    
    static let shareInstance = ControlManager()
    let appDelegate = NSApplication.shared().delegate as! AppDelegate
    var currentChannel : String = "device"
    
    func sendMessage(message : Dictionary<String, String>) {
        appDelegate.client.publish(message, toChannel: currentChannel, withCompletion: {
            (status) in
            print(status)
        })
    }
    
    func sendStartMessage(file: String) {
        // file_name
        let message = ["from": "mac", "action": "start", "fileName": file]
        self.sendMessage(message: message)
    }
    
    func sendStopMessage() {
        let message = ["from": "mac", "action": "stop", "fileName": ""]
        self.sendMessage(message: message)
    }
    
    func sendChannelInfo(user: String){
        let obj = ["from": "mac", "control_channel":user]
//        print(obj.rawString()!)
        self.sendMessage(message: obj)
        self.subsribeToControlChannel(channel: user)
        //subscribe to control channel
        //all actions to control channel
    }
    
    func subsribeToControlChannel(channel : String){
        appDelegate.client.subscribeToChannels([channel], withPresence: false)
        self.currentChannel = channel
    }
    
    func parseResponse(content: Dictionary<String, String>){
        let from = content["from"]
        
        if from == "mac" {
            return
        }
        
        let response = content["response"]
        if response == "ok"{
            NotificationCenter.default.post(name: Notification.Name(rawValue: response!), object: self)
        }
    }
    
    
}
