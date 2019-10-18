/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import CoreFoundation
import Network

/**
 Assertion for checking that the call is being made on the main thread.

 - parameter message: Message to display in case of assertion.
 */
public func assertIsMainThread(_ message: String) {
    assert(Thread.isMainThread, message)
}

public var debugSimulateSlowDBOperations = false

// Simple timer for manual profiling. Not for production use.
// Prints only if timing is longer than a threshold (to reduce noisy output).
open class PerformanceTimer {
    let startTime: CFAbsoluteTime
    var endTime: CFAbsoluteTime?
    let threshold: Double
    let label: String

    public init(thresholdSeconds: Double = 0.001, label: String = "") {
        self.threshold = thresholdSeconds
        self.label = label
        startTime = CFAbsoluteTimeGetCurrent()
    }

    public func stopAndPrint() {
        if let t = stop() {
            print("Ran for \(t) seconds. [\(label)]")
        }
    }

    public func stop() -> String? {
        endTime = CFAbsoluteTimeGetCurrent()
        if let duration = duration {
            return "\(duration)"
        }
        return nil
    }

    public var duration: CFAbsoluteTime? {
        if let endTime = endTime {
            let time = endTime - startTime
            return time > threshold ? time : nil
        } else {
            return nil
        }
    }
}

public class LinkedList<T> {
    class Node {
        var value: T
        var next: Node? = nil

        init(value: T) {
            self.value = value
        }
    }

    private var head: Node? = nil
    private var tail: Node? = nil
    public private(set) var count = 0

    public init() {}

    public func append(value: T) {
        count += 1
        let node = Node(value: value)
        if let tail = tail {
            tail.next = node
            self.tail = node
        } else {
            head = node
            tail = node
            assert(count == 1)
        }
    }

    public func popFront() -> T? {
        if count > 0 {
            count -= 1
        }
        let val = head?.value
        if head === tail {
            assert(count == 0)
            head = nil
            tail = nil
        } else if let head = head {
            assert(count > 0)
            self.head = head.next
        }
        return val
    }
}

public class LRUCache<T> {
    class Node {
        var data: T? = nil
        var key = 0
    }

    let maxSize: UInt
    var queue = LinkedList<Node>()
    var dict = [Int: Node]()

    public init(size: UInt = 1000) {
        maxSize = size
    }

    public func get(key: Int) -> T? {
        return dict[key]?.data
    }

    public func set(key: Int, value: T) {
        let node = Node()
        node.data = value
        node.key = key
        if queue.count >= maxSize {
            let oldNode = queue.popFront()
            dict[oldNode!.key] = nil
        }
        queue.append(value: node)
        dict[key] = node
    }
}
