GCD
======
A wrapper of Grand Central Dispatch written in Swift.


Examples
--------
**gcd**
```swift
// submit your code for asynchronous execution on a global queue with high priority
gcd.async(.High) {
    // your code
}

// or with main thread
gcd.async(.Main) {
    // your code
}

gcd.async(.Default) {
    // your code
    gcd.async(.Main) {
        // code run on main thread
    }
}

// with your custom queue
let myQueue = GCDQueue(serial: "myQueue")
gcd.async(.Custom(myQueue)) {
    // your code
}

// run with delay
gcd.async(.Background, delay: 5.0) {
    // your code
}

// sync code
gcd.sync(.Main) {
    // your code
}

// apply
gcd.apply(.Default, 10) { index in
    // your code
}

// once
var onceToken: GCDOnce = 0
gcd.once(&onceToken) {
    // your code
}
```

**manage group of block with GCDGroup**
```swift
// create group
let group = GCDGroup()

// you can add async code to group
group.async(.Defaul) {
    // your code
}

// you can set notify for this group
group.notify(.Main) {
    // your code
}

// or wait synchronously for block in group to complete and timeout is 10 seconds
group.wait(10)
```

**create your custom queue with CGDQueue**
```swift
// create a serial queue
let serialQueue = GCDQueue(serial: "mySerialQueue")

// create a concurrent queue
let concurrentQueue = GCDQueue(concurrent: "myConcurrentQueue")

// you can submit async barrier to queue
myQueue.asyncBarrier {
    // your code
}

// or sync code
myQueue.syncBarrier {
    // your code
}
```

##Installation

- Installation with CocoaPods
 `pod 'GCD'`

- Copying all the files into your project

- Using submodule
