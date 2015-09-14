//
//  WebSocketClient.swift
//  Syncopate
//
//  Created by Gary Chang on 9/4/15.
//  Copyright (c) 2015 Gary Chang. All rights reserved.
//

import Foundation
import Starscream

class WebSocketClient: WebSocketDelegate {
    
    // MARK: Properties
    typealias WebSocketOnMessageCallback = (data: NSDictionary) -> Void
    var host: String
    var path: String
    var socket: WebSocket?
    var received: Int64
    var onMessageCallback: WebSocketOnMessageCallback?
    
    init(host: String) {
        self.received = 0
        self.host = host
        self.path = ""
        self.socket = nil
        self.onMessageCallback = nil
    }
    
    func connect(path: String, onMessageCallback: WebSocketOnMessageCallback) {
        // Disconnect previous connection
        disconnect()
        
        self.received = 0
        self.path = path
        self.socket = WebSocket(url: NSURL(scheme: "ws",
            host: self.host,
            path: self.path)!);
        self.socket?.delegate = self;
        self.socket?.connect();
        self.onMessageCallback = onMessageCallback
        
        println("Connecting to websocket: \(self.host)\(self.path)")
    }
    
    func connectWithToken(token: String, onMessageCallback: WebSocketOnMessageCallback) {
        let path = "/ws?token=\(token)"
        connect(path, onMessageCallback: onMessageCallback)
    }
    
    func disconnect() {
        self.received = 0
        if let s = self.socket {
            s.disconnect()
            println("Disconnecting to websocket: \(self.host)\(self.path)")
            self.socket = nil
        }
    }
    
    // MARK: Websocket delegate methods
    func websocketDidConnect(ws: WebSocket) {
        println("Websocket is connected: \(self.host)\(self.path)")
    }
    
    func websocketDidDisconnect(ws: WebSocket, error: NSError?) {
        if let e = error {
            println("Websocket is disconnected: \(e.localizedDescription)")
        } else {
            println("Websocket disconnected: \(self.host)\(self.path)")
        }
    }
    
    func websocketDidReceiveMessage(ws: WebSocket, text: String) {
        self.received++
        println(self.received)
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            var error: NSError?;
            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data,
                options:NSJSONReadingOptions.allZeros,
                error: &error) as? NSDictionary;
            
            if (jsonResult != nil) {
                self.onMessageCallback?(data: jsonResult)
            } else {
                println("ERROR: Unable to parse text: \(text)");
            }
        }
    }
    
    func websocketDidReceiveData(ws: WebSocket, data: NSData) {
        println("Received data: \(data.length)")
    }

}