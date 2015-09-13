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
    let ws: WebSocketClient
    let http: HttpClient
    
    init() {
        persistencyManager = PersistencyManager()
        http = HttpClient(host: SyncopateConfig.httpHost)
        ws = WebSocketClient()
    }
    
    func isLoggedIn() -> Bool {
        return false
    }
    
    func login(username: String, password: String) {
        http.get(
            username,
            password: password,
            urlpath: "/cluster/login/",
            callback: {(data, response, error) in
                let status = (response as? NSHTTPURLResponse)?.statusCode
                println(status)
        })
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