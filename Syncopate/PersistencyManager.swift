//
//  PersistencyManager.swift
//  Syncopate
//
//  Created by Gary Chang on 9/6/15.
//  Copyright (c) 2015 Gary Chang. All rights reserved.
//

import Foundation


typealias ChannelStateDict = Dictionary<String,ChannelState>
typealias ChannelLookup = Dictionary<String, Array<ChannelState>>

class ChannelSection {
    
    var header: String?
    var channels: [ChannelState]
    
    init(jsonDict: NSDictionary) {
        channels = [ChannelState]()
        
        // (1) Parse header
        if let header = jsonDict["header"] as? String {
            self.header = header
        }
        // (2) Parse cells
        if let cells = jsonDict["cells"] as? Array<Dictionary<String,String>> {
            for c in cells {
                let cs = ChannelState(
                    key: c["key"]!,
                    label: c["label"]!)!
                channels.append(cs)
            }
        }
    }
    
    func description() -> String {
        return (header == nil) ? "" : header!
    }
}

class PersistencyManager {
    
    // MARK: Instance properties
    var channelSections = [ChannelSection]()
    var channelLookup = ChannelLookup()
    
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
        channelSections = [ChannelSection]()
        channelLookup = ChannelLookup()
        
        clusters = [ClusterState]()
        channels = ChannelStateDict()
        channelsOrder = [String]()
        selectedCluster = nil
        selectedChannelGroup = ""
        selectedChannelTopic = ""
    }
    
    func setCluster(jsonResult: NSDictionary) {
        selectedCluster = ClusterState(
            name: jsonResult["name"]! as! String,
            token: jsonResult["token"]! as! String,
            id: jsonResult["id"]! as! Int)
        
        if let sections = jsonResult["sections"] as? Array<NSDictionary> {
            for sjson in sections {
                let s = ChannelSection(jsonDict: sjson)
                channelSections.append(s)
                
                // Update channel lookup
                for cs in s.channels {
                    if var l = channelLookup[cs.key()] {
                        l.append(cs)
                    } else {
                        channelLookup[cs.key()] = [ cs ]
                    }
                }
            }
        }

    }
    
    func numSections() -> Int {
        return channelSections.count
    }
    
    func numCellsInSection(section: Int) -> Int {
        return channelSections[section].channels.count
    }
    
    func getCellInSection(section: Int, index: Int) -> ChannelState? {
        if section >= 0 && section < channelSections.count {
            let s = channelSections[section]
            if index >= 0 && index < s.channels.count {
                return s.channels[index]
            }
        }
        return nil
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