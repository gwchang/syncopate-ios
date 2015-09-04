//
//  Channel.swift
//  Syncopate
//
//  Created by Gary Chang on 9/3/15.
//  Copyright (c) 2015 Gary Chang. All rights reserved.
//

import Foundation

class Channel {
    
    // MARK: Properties
    var group: String
    var topic: String
    var value: String
    
    // MARK: Initialization
    init?(group: String, topic: String) {
        self.group = group
        self.topic = topic
        self.value = ""
        
        if group.isEmpty || topic.isEmpty {
            return nil
        }
    }
}