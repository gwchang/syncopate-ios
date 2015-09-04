//
//  AppState.swift
//  Syncopate
//
//  Created by Gary Chang on 9/4/15.
//  Copyright (c) 2015 Gary Chang. All rights reserved.
//

import Foundation

class AppState {
    
    // MARK: Properties
    var clusters = [ClusterState]()
    var wsconn = WebSocketConnection()
    
    init() {
        
    }
    
    func loadClusters() {
        
        // TEMP
        clusters.append(ClusterState(
            name:  SyncopateConfig.debugClusterName,
            token: SyncopateConfig.debugClusterToken))
    }
    
    func displayCluster(index: Int) {
        if index >= 0 && index < self.clusters.count {
            let c = self.clusters[0]
            wsconn.connect(c.wsHost, path: c.wsPath)
            
        }
    }
}