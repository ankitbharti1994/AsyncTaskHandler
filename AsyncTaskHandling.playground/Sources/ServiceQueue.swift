//
//  ServiceQueue.swift
//  AsyncTask
//
//  Created by ankit bharti on 07/08/19.
//  Copyright © 2019 ankit kumar bharti. All rights reserved.
//

import Foundation

public typealias _ResponseType = (String) -> Void
public typealias _RequestQueue = (String, _ResponseType)
public typealias _ExecutionResponseType = (String, _ResponseType) -> Void

public class ServiceQueue {
    private let semaphore: DispatchSemaphore
    private let _queue: DispatchQueue
    private let processQueue: DispatchQueue
    
    private var requests: [_RequestQueue] = [] {
        didSet {
            self.processQueue.async {
                self.semaphore.wait()
                self.startProcessing()
            }
        }
    }
    
    private init() {
        self._queue = DispatchQueue(label: "com.service.ankit")
        self.processQueue = DispatchQueue(label: "process.service.ankit")
        self.semaphore = DispatchSemaphore(value: 1)
    }
    
    public static let shared = ServiceQueue()
    
    public func enqueue(_ request: _RequestQueue) {
        self._queue.async(flags: .barrier) {
            self.requests.append(request)
            print("inserted \(request.0) to queue.")
        }
    }
    
    func dequeue() -> _RequestQueue? {
        var request: _RequestQueue?
        
        self._queue.sync {
            if self.requests.isEmpty {
                request = nil
            } else {
                request = self.requests.removeFirst()
            }
        }
        
        return request
    }
    
    func firstRequest() -> _RequestQueue? {
        var request: _RequestQueue?
        
        self._queue.sync {
            if self.requests.isEmpty {
                request = nil
            } else {
                request = self.requests.first
            }
        }
        
        return request
    }
    
    var count: Int {
        var queueCount = 0
        _queue.sync {
            queueCount = self.requests.count
        }
        
        return queueCount
    }
    
    public func removeAll() {
        _queue.sync {
            self.requests.removeAll()
        }
    }
    
    private func startProcessing() {
        guard let request = self.firstRequest() else {
            if self.count > 0 {
                print("request in queue.")
            } else {
                print("executed all reques.")
                self.semaphore.signal()
            }
            
            return
        }
        
        execute(request) { [weak self] value, handler in
            _ = self?.dequeue()
            self?.semaphore.signal()
            print("deleted \(value) from queue.")
            handler(value)
        }
    }
    
    private func execute(_ request: _RequestQueue, _ completion: @escaping _ExecutionResponseType) {
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 1.0) {
            completion(request.0, request.1)
        }
    }
    
    public func write(value: String, _ handler: @escaping _ResponseType) {
        self.enqueue((value, handler))
    }
}
