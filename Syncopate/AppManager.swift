//
//  AppManager.swift
//  Syncopate
//
//  Created by Gary Chang on 9/4/15.
//  Copyright (c) 2015 Gary Chang. All rights reserved.
//

import Foundation

class AppManager {
    
    // MARK: Class properties
    class var sharedInstance: AppManager {
        struct Singleton {
            static let instance = AppManager()
        }
        return Singleton.instance
    }
    
    // MARK: Instance properties
    private let persistencyManager: PersistencyManager
    var ws = WebSocketClient()
    
    init() {
        persistencyManager = PersistencyManager()
    }
    
    func isLoggedIn() -> Bool {
        return false
    }
    
    func login(username: String, password: String) {
        // Create login string
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
        
        // Create request
        let url = NSURL(string: "http://localhost:8000/cluster/login")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 10.0
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) in
            let status = (response as? NSHTTPURLResponse)?.statusCode
            println(status)
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
            // println(response)
            // println(error)
        }
        
        task.resume()
    }
    
    func clearData() {
        // Clear user data on logout
    }
    
    
    func getClusters() -> [ClusterState] {
        return persistencyManager.clusters
    }
    
    func getChannels() -> [ChannelState] {
        if let val = persistencyManager.channels[persistencyManager.selectedClusterName] {
            return val
        } else {
            return []
        }
    }
    
    // Selected cluster
    func getSelectedClusterName() -> String {
        return persistencyManager.selectedClusterName
    }
    
    func setSelectedClusterName(name: String) {
        persistencyManager.selectedClusterName = name
    }
    
    // Selected channel
    func getSelectedChannelName() -> String {
        return persistencyManager.selectedChannelGroup + "." + persistencyManager.selectedChannelTopic
    }
    
    func setSelectedChannel(group: String, topic: String) {
        persistencyManager.selectedChannelGroup = group
        persistencyManager.selectedChannelTopic = topic
    }
}