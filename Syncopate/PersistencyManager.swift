//
//  PersistencyManager.swift
//  Syncopate
//
//  Created by Gary Chang on 9/6/15.
//  Copyright (c) 2015 Gary Chang. All rights reserved.
//

import Foundation

class PersistencyManager {
    
    typealias ChannelStateDict = Dictionary<String,ChannelState>
    
    // MARK: Instance properties
    var clusters = [ClusterState]()
    var channels = ChannelStateDict()
    var selectedCluster: ClusterState?
    var selectedChannelGroup: String = ""
    var selectedChannelTopic: String = ""
    
    init() {
        // loadSampleData()
    }
    
    func reset() {
        clusters = [ClusterState]()
        channels = ChannelStateDict()
        selectedCluster = nil
        selectedChannelGroup = ""
        selectedChannelTopic = ""
    }
    
    func setCluster(name: String, token: String, id: Int, channels: [ChannelState]) {
        selectedCluster = ClusterState(name: name, token: token, id: id)
        self.channels = ChannelStateDict()
        for c in channels {
            self.channels[c.key()] = c
        }
    }
    
    func getChannelList() -> [ChannelState] {
        var channelList = [ChannelState]()
        for (key, value) in self.channels {
            channelList.append(value)
        }
        return channelList
    }
    
    func updateChannel(key: String, value: String) {
        // println("updateChannel, key: \(key), value: \(value)")
        if let c = self.channels[key] {
            c.setValue(value)
        } else {
            println("ERROR: PersistencyManager unable to find \(key) in channel dictionary.")
        }
    }

}