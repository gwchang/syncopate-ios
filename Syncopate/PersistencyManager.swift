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
    var channels = [ChannelState]()
    
    init() {
        loadSampleClusters()
        loadSampleChannels()
    }
    
    func loadSampleClusters() {
        let cluster1 = ClusterState(name: "cluster1", token: "abc")
        let cluster2 = ClusterState(name: "cluster2", token: "def")
        clusters += [ cluster1, cluster2 ]
    }
    
    func loadSampleChannels() {
        let channel1 = ChannelState(
            group: "top",
            topic: "cpu_usage_user",
            value: "25%")!
        let channel2 = ChannelState(
            group: "top",
            topic:"cpu_usage_sys",
            value: "75%")!
        channels += [ channel1, channel2 ]
    }
}