//
//  HttpClient.swift
//  Syncopate
//
//  Created by Gary Chang on 9/13/15.
//  Copyright (c) 2015 Gary Chang. All rights reserved.
//

import Foundation

typealias HttpStatusCallback = (Bool, Int?) -> Void

class HttpClient {
    
    typealias HttpCallback = (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void
    var host: String
    
    init(host: String) {
        self.host = host
    }
    
    func get(username: String, password: String, urlpath: String, callback: HttpCallback) {
        // Create login string
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions([])
        
        // Create request
        let url = NSURL(string: "http://\(host)\(urlpath)")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 10.0
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) in
            callback(data: data, response: response, error: error)
        }
        
        task.resume()
    }
    
    static func isSuccessCode(status: Int?) -> Bool {
        return status != nil && status! >= 200 && status! < 300
    }
    
    static func isAccessDeniedCode(status: Int?) -> Bool {
        return status != nil && status! >= 400 && status! < 500
    }
}