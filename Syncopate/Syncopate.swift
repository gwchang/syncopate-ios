//
//  Syncopate.swift
//  Syncopate
//
//  Created by Gary Chang on 9/3/15.
//  Copyright (c) 2015 Gary Chang. All rights reserved.
//

import Foundation
import UIKit

func colorWithHexString(hex:String) -> UIColor {
    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
    
    if (cString.hasPrefix("#")) {
        cString = (cString as NSString).substringFromIndex(1)
    }
    
    if (cString.characters.count != 6) {
        return UIColor.grayColor()
    }
    
    let rString = (cString as NSString).substringToIndex(2)
    let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
    let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    NSScanner(string: rString).scanHexInt(&r)
    NSScanner(string: gString).scanHexInt(&g)
    NSScanner(string: bString).scanHexInt(&b)
    
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}

struct SyncopateTheme {
    static let color1 = colorWithHexString("#ff7f66")
    static let color2 = colorWithHexString("#59646e")
    static let color3 = colorWithHexString("#fff6e5")
    static let color4 = colorWithHexString("#3e454c")
    static let color5 = colorWithHexString("#2F3440")
}

struct SyncopateStyle {
    static let mainTextColor        = SyncopateTheme.color3
    static let mainHighlightColor   = SyncopateTheme.color1
    static let mainBackgroundColor  = SyncopateTheme.color4
    static let mainSeparatorColor   = SyncopateTheme.color5
    static let mainSelectedColor    = SyncopateTheme.color2
    static let mainNavColor         = SyncopateTheme.color4
    
    static let menuTextColor        = SyncopateTheme.color3
    static let menuHighlightColor   = SyncopateTheme.color2
    static let menuBackgroundColor  = SyncopateTheme.color5
    static let menuSeparatorColor   = SyncopateTheme.color4
    static let menuSelectedColor    = SyncopateTheme.color4
    
    static let topicBackgroundColor = SyncopateTheme.color5
    
    static let mainValueFontSize: CGFloat = 20
    static let mainGroupFontSize: CGFloat = 15
    static let mainTopicFontSize: CGFloat = 15
    static let mainHeaderFontSize: CGFloat = 13
    static let mainRowHeight: CGFloat = 30
    static let mainHeaderHeight: CGFloat = 24
}

struct SyncopateConfig {
    static let wsHost = "45.33.39.21:8080"
    static let httpHost = "localhost:8000"
    static let debugClusterName = "__debug__"
    static let debugClusterToken = "asdf"
}