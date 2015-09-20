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
    var isConnected: Bool
    
    init(host: String) {
        self.received = 0
        self.host = host
        self.path = ""
        self.socket = nil
        self.onMessageCallback = nil
        self.isConnected = false
    }
    
    func connect(path: String, onMessageCallback: WebSocketOnMessageCallback) {
        // if (path != self.path) || !isConnected {
        // Disconnect previous connection
        disconnect()
        
        self.received = 0
        self.path = path
        self.socket = WebSocket(url: NSURL(scheme: "ws",
            host: self.host,
            path: self.path)!)
        self.socket?.delegate = self;
        self.socket?.connect();
        self.onMessageCallback = onMessageCallback
        
        print("Connecting to websocket: \(self.host)")
        // }
    }
    
    func connectWithTokenAndSeries(token: String, series: [String], onMessageCallback: WebSocketOnMessageCallback) {
        if series.count > 0 {
            let seriesJoin = series.joinWithSeparator("&")
            let path = "/ws?token=\(token)&\(seriesJoin)"
            connect(path, onMessageCallback: onMessageCallback)
        } else {
            print("Websocket url has not series requested.")
        }
    }
    
    func disconnect() {
        self.received = 0
        if let s = self.socket {
            s.disconnect()
            print("Disconnecting to websocket: \(self.host)")
            self.socket = nil
        }
    }
    
    // MARK: Websocket delegate methods
    func websocketDidConnect(ws: WebSocket) {
        print("Websocket is connected: \(self.host)")
        isConnected = true
    }
    
    func websocketDidDisconnect(ws: WebSocket, error: NSError?) {
        if let e = error {
            print("Websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("Websocket disconnected: \(self.host)")
        }
        isConnected = false
    }
    
    func websocketDidReceiveMessage(ws: WebSocket, text: String) {
        self.received++
        // println(self.received)
        
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data,
                    options:NSJSONReadingOptions()) as! NSDictionary;
            
            // if (jsonResult != nil) {
                self.onMessageCallback?(data: jsonResult)
            } catch {
                print("ERROR: Unable to parse text: \(text)");
            }
        }
        isConnected = true
    }
    
    func websocketDidReceiveData(ws: WebSocket, data: NSData) {
        print("Received data: \(data.length)")
        isConnected = true
    }

}