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
        ws = WebSocketClient(host: SyncopateConfig.wsHost)
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
            urlpath: "/cluster-login/",
            callback: {(data, response, error) in
                let status = (response as? NSHTTPURLResponse)?.statusCode
                // println(status)
                if status != nil && status! >= 200 && status! < 300 {
                    self.loggedIn = true
                    self.username = username
                    self.password = password
                    self.parseClusterDetailData(data)
                    callback(true)
                } else {
                    callback(false)
                }
        })
    }
    
    func parseClusterDetailData(data: NSData) {
        var error: NSError?
        if let json: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) {
            if let dict = json as? NSDictionary {
                if let name = dict["name"] as? String {
                    var channels = [ChannelState]()
                    if let channelList = dict["channels"] as? Array<Dictionary<String,String>> {
                        for c in channelList {
                            if let channelState = ChannelState(group: c["group"]!, topic: c["topic"]!) {
                                channels.append(channelState)
                                // println(c)
                            }
                        }
                    }
                    setSelectedCluster(
                        name,
                        token: dict["token"] as! String,
                        id: dict["id"] as! Int,
                        channels: channels)
                }
            }
        }
    }
    
    func refreshClusterDetail(callback: Bool -> Void) {
        if let s = persistencyManager.selectedCluster {
            updateClusterDetail(s.id, callback: callback)
        }
    }
    
    func updateClusterDetail(id: Int, callback: Bool -> Void) {
        http.get(
            self.username,
            password: self.password,
            urlpath: "/cluster/\(id)/",
            callback: {(data, response, error) in
                let status = (response as? NSHTTPURLResponse)?.statusCode
                // println(status)
                if status != nil && status! >= 200 && status! < 300 {
                    self.parseClusterDetailData(data)
                    callback(true)
                } else {
                    callback(false)
                }
        })
    }
    
    func updateClusterList() {
        http.get(
            self.username,
            password: self.password,
            urlpath: "/cluster-list/",
            callback: {(data, response, error) in
                let status = (response as? NSHTTPURLResponse)?.statusCode
                // println(status)
                if status != nil && status! >= 200 && status! < 300 {
                    self.parseClusterListData(data)
                }
        })
    }
    
    func parseClusterListData(data: NSData) {
        var clusters = [ClusterState]()
        var error: NSError?
        if let json: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) {
            if let array = json as? NSArray {
                // println(array)
                for elem in array {
                    
                    if let c = elem as? Dictionary<String,AnyObject> {
                        let cluster = ClusterState(
                            name: c["name"]! as! String,
                            token: c["token"]! as! String,
                            id: c["id"]! as! Int)
                        clusters.insert(cluster, atIndex: 0)
                        // clusters.append(cluster)
                        // println(cluster)
                    }
                }
            }
        }
        persistencyManager.clusters = clusters
    }
    
    func clearData() {
        // Clear user data on logout
    }
    
    
    func getClusters() -> [ClusterState] {
        return persistencyManager.clusters
    }
    
    func getChannels() -> [ChannelState] {
        return persistencyManager.getChannelList()
    }
    
    // Selected cluster
    func getSelectedCluster() -> String {
        return persistencyManager.selectedCluster!.name
    }
    
    func setSelectedCluster(name: String, token: String, id: Int, channels: [ChannelState]) {
        persistencyManager.setCluster(name, token: token, id: id, channels: channels)
        
        if channels.count > 0 {
            var series = [String]()
            for c in channels {
                series.append(c.url())
            }
            ws.connectWithTokenAndSeries(token, series: series, onMessageCallback: self.parseWebSocketMessage)
        }
    }
    
    func parseWebSocketMessage(data: NSDictionary) {
        println(data)
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