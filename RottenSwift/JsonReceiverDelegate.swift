//
//  JsonReceiverDelegate.swift
//  RedditSwift
//
//  Created by Zachary Barryte on 7/20/14.
//  Copyright (c) 2014 Zachary Barryte. All rights reserved.
//

import Foundation

protocol JsonReceiverDelegate {
    
    func receiveJson(jsonDictionary:NSDictionary) ->()
    
}