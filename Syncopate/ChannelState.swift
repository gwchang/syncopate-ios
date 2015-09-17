//
//  ChannelState.swift
//  Syncopate
//
//  Created by Gary Chang on 9/3/15.
//  Copyright (c) 2015 Gary Chang. All rights reserved.
//

import Foundation
import UIKit

class ChannelState {
    
    // MARK: Properties
    var label: String
    var group: String
    var topic: String
    var value: String
    var valueLabel: UILabel?
    
    // MARK: Initialization
    init?(key: String, label: String) {
        let tokens = key.componentsSeparatedByString(".")
        
        self.label = label
        self.value = ""
        self.group = tokens[0]
        self.topic = ""
        
        if tokens.count != 2 {
            return nil
        } else {
            self.topic = tokens[1]
        }
    }
    
    init?(group: String, topic: String, value: String) {
        self.group = group
        self.topic = topic
        self.value = value
        
        // Default label is topic
        self.label = topic
        
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
    
    func setValueLabel(label: UILabel) {
        valueLabel = label
    }
    
    func setValue(value: String) {
        self.value = value
        if let label = self.valueLabel {
            label.setNeedsDisplay()
        } else {
            // println("ChannelState \(key()) missing UILabel on setValue")
        }
    }
    
    func description() -> String {
        let label: String = valueLabel != nil ? "*" : "nil"
        return "\(group).\(topic) = \(value) \(label)"
    }
}