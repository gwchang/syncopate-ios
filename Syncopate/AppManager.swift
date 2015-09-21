//
//  AppManager.swift
//  Syncopate
//
//  Created by Gary Chang on 9/4/15.
//  Copyright (c) 2015 Gary Chang. All rights reserved.
//

import Foundation
import UIKit

class AppManager {
    
    typealias Callback = (Bool) -> Void
    
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
    var onSocketCallback: Callback?
    
    init() {
        persistencyManager = PersistencyManager()
        http = HttpClient(host: AppConfig.httpHost)
        ws = WebSocketClient(host: AppConfig.wsHost)
        loggedIn = false
        username = ""
        password = ""
    }
    
    func isLoggedIn() -> Bool {
        return loggedIn
    }
    
    func login(username: String, password: String, callback: HttpStatusCallback) {
        http.get(
            username,
            password: password,
            urlpath: "/cluster-login/",
            callback: {(data, response, error) in
                let status = (response as? NSHTTPURLResponse)?.statusCode
                let success = HttpClient.isSuccessCode(status)
                if success {
                    self.loggedIn = true
                    self.username = username
                    self.password = password
                    self.parseClusterDetailData(data)
                }
                callback(success, status)
        })
    }
    
    func logout() {
        clearData()
        loggedIn = false
        ws.disconnect()
        // let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // appDelegate.showLoginScreen(false)
    }
    
    func loadClusterDetailData(path: String) {
        if let path = NSBundle.mainBundle().pathForResource(path, ofType: "json") {
            if let jsonData = try? NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe) {
                parseClusterDetailData2(jsonData)
            }
        }
    }
    
    func parseClusterDetailData2(data: NSData) {
        if let jsonResult: NSDictionary = (try? NSJSONSerialization.JSONObjectWithData(
            data,
            options: NSJSONReadingOptions.MutableContainers)) as? NSDictionary {
            let (token, seriesUrl) = persistencyManager.setCluster(jsonResult)
            if seriesUrl.count > 0 {
                ws.connectWithTokenAndSeries(token, series: seriesUrl, onMessageCallback: {(data: NSDictionary) in
                    if !self.isLoggedIn() {
                        return
                    }
                    if let series = data["Series"] as? [Dictionary<String,AnyObject>] {
                        for s in series {
                            self.persistencyManager.updateChannelWithKey(
                                s["k"]! as! String,
                                value: s["v"]! as! String)
                        }
                        // println(series)
                        if series.count > 0 {
                            self.onSocketCallback?(true)
                        }
                    }
                })
            }
        }
    }
    
    func parseClusterDetailData(data: NSData) {
        loadClusterDetailData("cluster-detail-example")
        /*
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
        */
    }
    
    func refreshClusterDetail(callback: HttpStatusCallback) {
        ws.disconnect()
        if let s = persistencyManager.selectedCluster {
            updateClusterDetail(s.id, callback: callback)
        }
    }
    
    func updateClusterDetail(id: Int, callback: HttpStatusCallback) {
        http.get(
            self.username,
            password: self.password,
            urlpath: "/cluster/\(id)/",
            callback: {(data, response, error) in
                let status = (response as? NSHTTPURLResponse)?.statusCode
                let success = HttpClient.isSuccessCode(status)
                if success {
                    self.parseClusterDetailData(data)
                }
                callback(success, status)
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
                let success = HttpClient.isSuccessCode(status)
                if success {
                    self.parseClusterListData(data)
                }
        })
    }
    
    func parseClusterListData(data: NSData) {
        persistencyManager.clusters = [ClusterState]()
        var error: NSError?
        do {
            let json: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            if let array = json as? NSArray {
                // println(array)
                for elem in array {
                    
                    if let c = elem as? Dictionary<String,AnyObject> {
                        let cluster = ClusterState(
                            name: c["name"]! as! String,
                            token: c["token"]! as! String,
                            id: c["id"]! as! Int)
                        persistencyManager.clusters.insert(cluster, atIndex: 0)
                        // clusters.append(cluster)
                        // println(cluster)
                    }
                }
            }
        } catch let error1 as NSError {
            error = error1
        }
    }
    
    func clearData() {
        // Clear user data on logout
        persistencyManager.reset()
    }
    
    func numSections() -> Int {
        return persistencyManager.numSections()
    }
    
    func numCellsInSection(section: Int) -> Int {
        return persistencyManager.numCellsInSection(section)
    }
    
    func getChannelInSectionAtIndex(section: Int, index: Int) -> ChannelState? {
        return persistencyManager.getCellInSectionAtIndex(section, index: index)
    }
    
    func getHeaderInSection(section: Int) -> String? {
        return persistencyManager.getHeaderInSection(section)
    }
    
    
    func getClusters() -> [ClusterState] {
        return persistencyManager.clusters
    }
    
    /*
    func getChannelAtIndex(index: Int) -> ChannelState? {
        return persistencyManager.getChannelAtIndex(index)
    }
    
    func getChannelsCount() -> Int {
        return persistencyManager.channelsOrder.count
    }
    */
    
    // Selected cluster
    func getSelectedCluster() -> String {
        return persistencyManager.selectedCluster!.name
    }
    
    /*
    func setSelectedCluster(name: String, token: String, id: Int, channels: [ChannelState]) {
        println("setSelectedCluster")
        persistencyManager.setCluster(name, token: token, id: id, channels: channels)
        
        if channels.count > 0 {
            var series = [String]()
            for c in channels {
                series.append(c.url())
            }
            ws.connectWithTokenAndSeries(token, series: series, onMessageCallback: {(data: NSDictionary) in
                if !self.isLoggedIn() {
                    return
                }
                if let series = data["Series"] as? [Dictionary<String,AnyObject>] {
                    for s in series {
                        self.persistencyManager.updateChannel(
                            s["k"]! as! String,
                            value: s["v"]! as! String)
                    }
                    // println(series)
                    if series.count > 0 {
                        self.onSocketCallback?(true)
                    }
                }
            })
        }
    }
    */
    
    // Selected channel
    func getSelectedChannelName() -> String {
        return persistencyManager.selectedChannelGroup + "." + persistencyManager.selectedChannelTopic
    }
    
    func setSelectedChannel(group: String, topic: String) {
        persistencyManager.selectedChannelGroup = group
        persistencyManager.selectedChannelTopic = topic
    }
}