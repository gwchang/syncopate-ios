//
//  PersistencyManager.swift
//  Syncopate
//
//  Created by Gary Chang on 9/6/15.
//  Copyright (c) 2015 Gary Chang. All rights reserved.
//

import Foundation

class PersistencyManager {
    
    // MARK: Instance properties
    var clusters = [ClusterState]()
    var channels = Dictionary<String, Array<ChannelState>>()
    var selectedClusterName: String = ""
    var selectedChannelGroup: String = ""
    var selectedChannelTopic: String = ""
    
    init() {
        loadSampleData()
    }
    
    func loadSampleData() {
        let cluster1 = ClusterState(name: "cluster1", token: "abc")
        let cluster2 = ClusterState(name: "cluster2", token: "def")
        self.clusters += [ cluster1, cluster2 ]
        
        self.selectedClusterName = clusters[0].name

        let channel1 = ChannelState(
            group: "top",
            topic: "cpu_usage_user",
            value: "25%")!
        let channel2 = ChannelState(
            group: "top",
            topic:"cpu_usage_sys",
            value: "75%")!
        self.channels[selectedClusterName] = [ channel1, channel2 ]
    }
    
    func reset() {
        clusters = [ClusterState]()
        channels = Dictionary<String, Array<ChannelState>>()
        selectedClusterName = ""
        selectedChannelGroup = ""
        selectedChannelTopic = ""
    }
}