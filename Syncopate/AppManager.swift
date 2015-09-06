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
    var ws = WebSocketClient()
    
    init() {
        persistencyManager = PersistencyManager()
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
    
    func getSelectedClusterName() -> String {
        return persistencyManager.selectedClusterName
    }
    
    func setSelectedClusterName(name: String) {
        persistencyManager.selectedClusterName = name
    }
}