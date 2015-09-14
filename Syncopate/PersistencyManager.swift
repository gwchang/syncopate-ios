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
    var channels = Dictionary<String, ChannelStateDict>()
    var selectedCluster: ClusterState?
    var selectedChannelGroup: String = ""
    var selectedChannelTopic: String = ""
    
    init() {
        // loadSampleData()
    }
    
    func reset() {
        clusters = [ClusterState]()
        channels = Dictionary<String, ChannelStateDict>()
        selectedCluster = nil
        selectedChannelGroup = ""
        selectedChannelTopic = ""
    }
    
    func setCluster(name: String, token: String, id: Int, channels: [ChannelState]) {
        selectedCluster = ClusterState(name: name, token: token, id: id)
        var channelDict = ChannelStateDict()
        for c in channels {
            channelDict[c.key()] = c
        }
        self.channels[name] = channelDict
    }
    
    func getChannelList() -> [ChannelState] {
        if let channelDict = channels[selectedCluster!.name] {
            var channelList = [ChannelState]()
            for (key, value) in channelDict {
                channelList.append(value)
            }
            return channelList
        } else {
            return []
        }
    }
    
    func updateChannel(key: String, value: String) {
        if let channelDict = channels[selectedCluster!.name] {
            if let c = channelDict[key] {
                c.setValue(value)
                // println(value)
            }
        } else {
            println("Unable to find \(selectedCluster!.name)")
        }
    }

}