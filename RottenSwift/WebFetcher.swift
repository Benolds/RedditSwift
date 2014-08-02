//
//  WebFetcher.swift
//  RedditSwift
//
//  Created by Zachary Barryte on 7/20/14.
//  Copyright (c) 2014 Zachary Barryte. All rights reserved.
//

import Foundation

let _sharedInstance = WebFetcher()

class WebFetcher : NSObject {
    
    // We'd like Web Fetcher to be a singleton, meaning we'd only ever like to instantiate it once
    // Here we call on a global constant, which will be the same instance wherever it is called
    class var sharedInstance : WebFetcher {
        return _sharedInstance
    }
    
    // This delegate will receive the json
    var delegate: JsonReceiverDelegate?
    
    func loadJsonFromUrlWithString(string: NSString) {
        
        var url: NSURL? = NSURL(string: string)
        
        func completionHandler(response: NSURLResponse!, data: NSData!, error: NSError!) ->() {
            
            assert(!error,"*** Fetch Failed : double-check your url ***")
            
            receivedJson(data)
        }
        
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: url), queue: NSOperationQueue(), completionHandler:completionHandler)
    }
    
    func receivedJson(data: NSData) {
        var error: NSErrorPointer = nil
        var jsonDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: error) as NSDictionary
        
        assert(delegate,"*** WebFetcher's JsonReceiverDelegate is null: be sure you assigned it ***")
        
        delegate!.receiveJson(jsonDictionary)
    }
}
