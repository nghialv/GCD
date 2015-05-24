//
//  AppDelegate.swift
//  Example
//
//  Created by Le Van Nghia on 7/25/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        // write as a trailing closure
        gcd.async(.Main) {
            println("on main thread : \(NSThread.isMainThread())")
        }
        
        gcd.async(.Default) {
            var i = 0
            for i = 0; i < 10; i++ {
                NSLog("default global queue : \(i)")
            }
            gcd.async(.Main) { NSLog("main thread : \(i)") }
        }
        
        let myQueue = GCDQueue(concurrent: "myConcurentQueue") // or let myQueue = GCDQueue(concurrent: nil)
        gcd.async(.Custom(myQueue)) {
            NSLog("Log from my concurrent queue : \(NSThread.isMainThread())")
        }
        
        // delay
        gcd.async(.Main, delay: 5.0) {
            NSLog("gcd after")
        }
        
        // group
        let myGroup = GCDGroup()
        myGroup.async(.Default) {
            NSLog("group")
        }
        myGroup.wait(10)
       
        NSLog("DONE")
        
        return true
    }
}

