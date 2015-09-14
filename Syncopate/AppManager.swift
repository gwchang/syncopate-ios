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
    private let ws: WebSocketClient
    private let http: HttpClient
    private var loggedIn: Bool
    private var username: String
    private var password: String
    
    init() {
        persistencyManager = PersistencyManager()
        http = HttpClient(host: SyncopateConfig.httpHost)
        ws = WebSocketClient()
        loggedIn = false
        username = ""
        password = ""
    }
    
    func isLoggedIn() -> Bool {
        return loggedIn
    }
    
    func login(username: String, password: String, callback: Bool -> Void) {
        http.get(
            username,
            password: password,
            urlpath: "/cluster/login/",
            callback: {(data, response, error) in
                let status = (response as? NSHTTPURLResponse)?.statusCode
                // println(status)
                if status != nil && status! >= 200 && status! < 300 {
                    self.loggedIn = true
                    self.username = username
                    self.password = password
                    self.parseClusterData(data)
                    callback(true)
                } else {
                    callback(false)
                }
        })
    }
    
    func parseClusterData(data: NSData) {
        var error: NSError?
        if let json: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) {
            if let dict = json as? NSDictionary {
                if let name = dict["name"] as? String {
                    setSelectedCluster(name)
                    
                    var channels = [ChannelState]()
                    if let channelList = dict["channels"] as? Array<Dictionary<String,String>> {
                        for c in channelList {
                            if let channelState = ChannelState(group: c["group"]!, topic: c["topic"]!) {
                                channels.append(channelState)
                                // println(c)
                            }
                        }
                    }
                    persistencyManager.channels[name] = channels
                }
            }
        }
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
    func getSelectedCluster() -> String {
        return persistencyManager.selectedClusterName
    }
    
    func setSelectedCluster(name: String) {
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