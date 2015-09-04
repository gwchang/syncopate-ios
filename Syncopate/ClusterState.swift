//
//  ClusterState.swift
//  Syncopate
//
//  Created by Gary Chang on 9/4/15.
//  Copyright (c) 2015 Gary Chang. All rights reserved.
//

import Foundation

class ClusterState {
    
    // MARK: Properties
    var name: String
    var token: String
    var wsHost: String
    var wsPath: String
    
    init(name: String, token: String) {
        self.name = name
        self.token = token
        
        self.wsHost = SyncopateConfig.wsHost
        self.wsPath = "/ws?token=" + self.token
    }
}