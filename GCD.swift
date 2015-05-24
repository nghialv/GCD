//
//  GCD.swift
//
//  Created by Le Van Nghia on 7/25/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import Foundation

public typealias GCDClosure = () -> ()
public typealias GCDApplyClosure = (Int) -> ()
public typealias GCDOnce = dispatch_once_t

public enum QueueType {
    case Main
    case High
    case Default
    case Low
    case Background
    case Custom(GCDQueue)
    
    public func getQueue() -> dispatch_queue_t {
        switch self {
        // return concurrent queue with hight priority
        case .High:
            return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
        
        // return concurrent queue with default priority
        case .Default:
            return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        // return concurrent queue with low priority
        case .Low:
            return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
        
        // return background concurrent queue
        case .Background:
            return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
            
        // return custom queue
        case .Custom(let gcdQueue):
            return gcdQueue.dispatchQueue
            
        // return the serial dispatch queue associated with the application’s main thread
        case .Main:
            fallthrough
        
        default:
            return dispatch_get_main_queue()
        }
    }
}

public class GCDQueue
{
    let dispatchQueue: dispatch_queue_t
    
    /**
    *  Init with main queue (tasks execute serially on your application’s main thread)
    */
    public init() {
        dispatchQueue = dispatch_get_main_queue()
    }
    
    /**
    *  Init with a serial queue (tasks execute one at a time in FIFO order)
    *
    *  @param label (can be nil)
    */
    public init(serial label: String?) {
        if label != nil {
            dispatchQueue = dispatch_queue_create(label!, DISPATCH_QUEUE_SERIAL)
        }
        else {
            dispatchQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)
        }
    }
    
    /**
    *  Init with concurrent queue (tasks are dequeued in FIFO order, but run concurrently and can finish in any order)
    *
    *  @param label (can be nil)
    */
    public init(concurrent label: String?) {
        if label != nil {
            dispatchQueue = dispatch_queue_create(label!, DISPATCH_QUEUE_CONCURRENT)
        }
        else {
            dispatchQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT)
        }
    }
    
    /**
    *  Submits a barrier block for asynchronous execution and returns immediately
    *
    *  @param GCDClosure
    *
    */
    public func asyncBarrier(closure: GCDClosure) {
        dispatch_barrier_async(dispatchQueue, closure)
    }
   
    /**
    *  Submits a barrier block object for execution and waits until that block completes
    *
    *  @param GCDClosure
    *
    */
    public func syncBarrier(closure: GCDClosure) {
        dispatch_barrier_sync(dispatchQueue, closure)
    }
    
    /**
    *  suspend queue
    *
    */
    public func suspend() {
        dispatch_suspend(dispatchQueue)
    }
    
    /**
    *  resume queue
    *
    */
    public func resume() {
        dispatch_resume(dispatchQueue)
    }
    
}

public class GCDGroup
{
    let dispatchGroup: dispatch_group_t
    
    public init() {
        dispatchGroup = dispatch_group_create()
    }
    
    public func enter() {
        dispatch_group_enter(dispatchGroup)
    }
    
    public func leave() {
        dispatch_group_leave(dispatchGroup)
    }
   
    /**
    *  Waits synchronously for the previously submitted block objects to complete
    *  returns if the blocks do not complete before the specified timeout period has elapsed
    *
    *  @param Double timeout in second
    *
    *  @return all blocks associated with the group completed before the specified timeout or not
    */
    public func wait(timeout: Double) -> Bool {
        let t = timeout * Double(NSEC_PER_SEC)
        return dispatch_group_wait(dispatchGroup, dispatch_time(DISPATCH_TIME_NOW, Int64(t))) == 0
    }
    
    /**
    *  Submits a block to a dispatch queue and associates the block with current dispatch group
    *
    *  @param QueueType
    *  @param GCDClosure
    *
    */
    public func async(queueType: QueueType, closure: GCDClosure) {
        dispatch_group_async(dispatchGroup, queueType.getQueue(), closure)
    }
   
    /**
    *  Schedules a block object to be submitted to a queue when
    *  previously submitted block objects of current group have completed
    *
    *  @param QueueType
    *  @param GCDClosure
    *
    */
    public func notify(queueType: QueueType, closure: GCDClosure) {
        dispatch_group_notify(dispatchGroup, queueType.getQueue(), closure)
    }
}

public class gcd
{
    /**
    *  Async
    *  Submits a block for asynchronous execution on a dispatch queue and returns immediately
    *
    *  @param QueueType  : the queue (main or serially or concurrently) on which to submit the block
    *  @param GCDClosure : the block will be run
    *
    */
    public class func async(queueType: QueueType, closure: GCDClosure) {
        dispatch_async(queueType.getQueue(), closure)
    }
   
    // Enqueue a block for execution at the specified time
    public class func async(queueType: QueueType, delay: Double, closure: GCDClosure) {
        let t = delay * Double(NSEC_PER_SEC)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(t)), queueType.getQueue(), closure)
    }
    
    /**
    *  Sync
    *  Submits a block object for execution on a dispatch queue and waits until that block completes
    *
    *  @param QueueType  :  the queue (main or serially or concurrently) on which to submit the block
    *  @param GCDClosure :  the block will be run
    *
    */
    public class func sync(queueType: QueueType, closure: GCDClosure) {
        dispatch_sync(queueType.getQueue(), closure)
    }
   
    /**
    *  dispatch apply
    *  this method waits for all iterations of the task block to complete before returning
    *
    *  @param QueueType       :  the queue (main or serially or concurrently) on which to submit the block
    *  @param UInt            :  the number of iterations to perform
    *  @param GCDApplyClosure :  the block will be run
    *
    */
    public class func apply(queueType: QueueType, interators: UInt, closure: GCDApplyClosure) {
        dispatch_apply(Int(interators), queueType.getQueue(), closure)
    }
    
    /**
    *
    *
    *  @param UnsafePointer<dispatch_once_t>
    *  @param GCDClosure
    *
    *  @return
    */
    public class func once(predicate: UnsafeMutablePointer<dispatch_once_t>, closure: GCDClosure) {
        dispatch_once(predicate, closure)
    }
}