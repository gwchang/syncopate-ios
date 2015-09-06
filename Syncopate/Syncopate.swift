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
    
    if (count(cString) != 6) {
        return UIColor.grayColor()
    }
    
    var rString = (cString as NSString).substringToIndex(2)
    var gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
    var bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    NSScanner(string: rString).scanHexInt(&r)
    NSScanner(string: gString).scanHexInt(&g)
    NSScanner(string: bString).scanHexInt(&b)
    
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}

struct SyncopateTheme {
    static let color1 = colorWithHexString("#304269")
    static let color2 = colorWithHexString("#91BED4")
    static let color3 = colorWithHexString("#D9E8F5")
    static let color4 = colorWithHexString("#FFFFFF")
    static let color5 = colorWithHexString("#F26101")
}

struct SyncopateStyle {
    static let mainTextColor        = SyncopateTheme.color4
    static let mainHighlightColor   = SyncopateTheme.color5
    static let mainBackgroundColor  = SyncopateTheme.color1
    static let mainSeparatorColor   = SyncopateTheme.color2
    static let mainNavColor         = SyncopateTheme.color2
}

struct SyncopateConfig {
    static let wsHost = "api.blub.io:32798"
    static let debugClusterName = "__debug__"
    static let debugClusterToken = "asdf"
}