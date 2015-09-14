//
//  ChannelState.swift
//  Syncopate
//
//  Created by Gary Chang on 9/3/15.
//  Copyright (c) 2015 Gary Chang. All rights reserved.
//

import Foundation

class ChannelState {
    
    // MARK: Properties
    var group: String
    var topic: String
    var value: String
    
    // MARK: Initialization
    init?(group: String, topic: String, value: String) {
        self.group = group
        self.topic = topic
        self.value = value
        
        if group.isEmpty || topic.isEmpty {
            return nil
        }
    }
    
    convenience init?(group: String, topic: String) {
        self.init(group: group, topic: topic, value: "")
    }
    
    func key() -> String {
        return "\(group).\(topic)"
    }
    
    func url() -> String {
        return "series=\(key())"
    }
}