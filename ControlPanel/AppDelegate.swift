//
//  AppDelegate.swift
//  ControlPanel
//
//  Created by Tony Tung on 2/16/17.
//  Copyright © 2017 Tony Tung. All rights reserved.
//

import Cocoa
import PubNub
import SwiftyJSON

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, PNObjectEventListener {

    let pKey : String = "pub-c-55c3fb61-3624-40ba-ab52-f595b4c17cc3"
    let sKey : String = "sub-c-b7ec68fa-b68b-11e6-b0d5-0619f8945a4f"
    var client : PubNub!
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let configuration = PNConfiguration(publishKey: self.pKey,subscribeKey: self.sKey)
        self.client = PubNub.clientWithConfiguration(configuration)
        self.client.addListener(self)
        self.client.subscribeToChannels(["device"], withPresence: false)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    //handle message
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        switch message.data.channel {
            case "device":
                //do something?
                break
            default:
                let obj = message.data.message as! Dictionary<String, String>
                ControlManager.shareInstance.parseResponse(content: obj)
                break
        }
        if message.data.channel != message.data.subscription {
            
            // Message has been received on channel group stored in message.data.subscription.
        }
        else {
            
            // Message has been received on channel stored in message.data.channel.
        }
        
        print("Received message: \(message.data.message) on channel \(message.data.channel) " +
            "at \(message.data.timetoken)")
    }
    
    func client(_ client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        
    }
    
    func client(_ client: PubNub, didReceive status: PNStatus) {
        if status.operation == .subscribeOperation {
            
            // Check whether received information about successful subscription or restore.
            if status.category == .PNConnectedCategory || status.category == .PNReconnectedCategory {
                
                let subscribeStatus: PNSubscribeStatus = status as! PNSubscribeStatus
                if subscribeStatus.category == .PNConnectedCategory {
                    
                    // This is expected for a subscribe, this means there is no error or issue whatsoever.
                    
                    // Select last object from list of channels and send message to it.
                    let targetChannel = client.channels().last!
//                    client.publish("Hello from the PubNub Swift SDK", toChannel: targetChannel,
//                                   compressed: false, withCompletion: { (publishStatus) -> Void in
//                                    
//                                    if !publishStatus.isError {
//                                        
//                                        // Message successfully published to specified channel.
//                                    }
//                                    else {
//                                        
//                                        /**
//                                         Handle message publish error. Check 'category' property to find out
//                                         possible reason because of which request did fail.
//                                         Review 'errorData' property (which has PNErrorData data type) of status
//                                         object to get additional information about issue.
//                                         
//                                         Request can be resent using: publishStatus.retry()
//                                         */
//                                    }
//                    })
                }
                else {
                    
                    /**
                     This usually occurs if subscribe temporarily fails but reconnects. This means there was
                     an error but there is no longer any issue.
                     */
                }
            }
            else if status.category == .PNUnexpectedDisconnectCategory {
                
                /**
                 This is usually an issue with the internet connection, this is an error, handle
                 appropriately retry will be called automatically.
                 */
            }
                // Looks like some kind of issues happened while client tried to subscribe or disconnected from
                // network.
            else {
                
                let errorStatus: PNErrorStatus = status as! PNErrorStatus
                if errorStatus.category == .PNAccessDeniedCategory {
                    
                    /**
                     This means that PAM does allow this client to subscribe to this channel and channel group
                     configuration. This is another explicit error.
                     */
                }
                else {
                    
                    /**
                     More errors can be directly specified by creating explicit cases for other error categories 
                     of `PNStatusCategory` such as: `PNDecryptionErrorCategory`,  
                     `PNMalformedFilterExpressionCategory`, `PNMalformedResponseCategory`, `PNTimeoutCategory`
                     or `PNNetworkIssuesCategory`
                     */
                }
            }
        }
    }
    
    


}

