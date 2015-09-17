//
//  PersistencyManager.swift
//  Syncopate
//
//  Created by Gary Chang on 9/6/15.
//  Copyright (c) 2015 Gary Chang. All rights reserved.
//

import Foundation

class ChannelSection {
    
    var header: String?
    var cells = [ChannelState]()
    
    init(jsonDict: NSDictionary) {
        // (1) Parse header
        if let header = jsonDict["header"] as? String {
            self.header = header
        }
        // (2) Parse cells
        if let cells = jsonDict["cells"] as? Array<Dictionary<String,String>> {
            for c in cells {
                
            }
        }
                
        // (3) Parse footer

    }
    
    func description() -> String {
        return (header == nil) ? "" : header!
    }
}

class PersistencyManager {
    
    typealias ChannelStateDict = Dictionary<String,ChannelState>
    
    // MARK: Instance properties
    var clusters = [ClusterState]()
    var channels = ChannelStateDict()
    var channelsOrder = [String]()
    var selectedCluster: ClusterState?
    var selectedChannelGroup: String = ""
    var selectedChannelTopic: String = ""
    
    init() {
        // loadSampleData()
    }
    
    func reset() {
        clusters = [ClusterState]()
        channels = ChannelStateDict()
        channelsOrder = [String]()
        selectedCluster = nil
        selectedChannelGroup = ""
        selectedChannelTopic = ""
    }
    
    func setCluster(name: String, token: String, id: Int, channels: [ChannelState]) {
        selectedCluster = ClusterState(name: name, token: token, id: id)
        self.channels = ChannelStateDict()
        self.channelsOrder = [String]()
        for c in channels {
            self.channels[c.key()] = c
            self.channelsOrder.append(c.key())
        }
    }
    
    func getChannelAtIndex(index: Int) -> ChannelState? {
        if index >= 0 && index < channelsOrder.count {
            if let c = channels[channelsOrder[index]] {
                return c
            }
        }
        return nil
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