//
//  ServiceQueue.swift
//  AsyncTask
//
//  Created by ankit bharti on 07/08/19.
//  Copyright © 2019 ankit kumar bharti. All rights reserved.
//

import Foundation

typealias _ResponseType = (String) -> Void
typealias _RequestQueue = (String, _ResponseType)
typealias _ExecutionResponseType = (String, _ResponseType) -> Void

class ServiceQueue {
    private let semaphore: DispatchSemaphore
    private let resourceQueue: DispatchQueue
    private let processingQueue: DispatchQueue
    
    private var requests: [_RequestQueue] = []
    
    private init() {
        self.resourceQueue = DispatchQueue(label: "com.service.ankit")
        self.processingQueue = DispatchQueue(label: "com.service.processing")
        self.semaphore = DispatchSemaphore(value: 1)
    }
    
    static let shared = ServiceQueue()
    
    func enqueue(_ request: _RequestQueue) {
        self.resourceQueue.async(flags: .barrier) {
            self.requests.append(request)
            print("inserted \(request.0) to queue.")
            self.processingQueue.async {
                self.semaphore.wait()
                self.startProcessing()
            }
        }
    }
    
    func dequeue() -> _RequestQueue? {
        var request: _RequestQueue?
        
        self.resourceQueue.sync {
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
        
        self.resourceQueue.sync {
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
        resourceQueue.sync {
            queueCount = self.requests.count
        }
        
        return queueCount
    }
    
    private func startProcessing() {
        guard let request = self.firstRequest() else {
            print("nothing to execute.")
            return
        }
        
        print("started executing at: \(Date())")
        execute(request) { [weak self] value, handler in
            print("Finished execution at: \(Date())")
            _ = self?.dequeue()
            self?.semaphore.signal()
            print("deleted \(value) from queue.")
            handler(value)
        }
    }
    
    private func execute(_ request: _RequestQueue, _ completion: @escaping _ExecutionResponseType) {
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 1) {
            completion(request.0, request.1)
        }
    }
    
    func write(value: String, _ handler: @escaping _ResponseType) {
        self.enqueue((value, handler))
    }
}
