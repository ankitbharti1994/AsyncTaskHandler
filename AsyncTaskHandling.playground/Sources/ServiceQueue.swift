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
    private var requests: [_RequestQueue] = [] {
        didSet {
            DispatchQueue.global(qos: .default).async {
                self.startProcessing()
            }
        }
    }
    
    private let _queue: DispatchQueue
    
    enum ExecutionState {
        case busy
        case normal
    }
    
    private var executionState: ExecutionState = .normal
    
    private init() {
        self._queue = DispatchQueue(label: "com.service.ankit", attributes: .concurrent)
    }
    
    public static let shared = ServiceQueue()
    
    public func enqueue(_ request: _RequestQueue) {
        self._queue.async(flags: .barrier) {
            self.requests.append(request)
            print("inserted \(request.0) to queue.")
        }
    }
    
    public func dequeue() -> _RequestQueue? {
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
    
    public func removeAll() {
        self._queue.sync {
            self.requests.removeAll()
        }
    }
    
    public func firstRequest() -> _RequestQueue? {
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
    
    private var count: Int {
        var queueCount = 0
        _queue.sync {
            queueCount = self.requests.count
        }
        
        return queueCount
    }
    
    private func startProcessing() {
        guard let request = self.firstRequest(), self.executionState == .normal else {
            if self.count > 0 {
                print("request in queue.")
            } else {
                print("executed all reques.")
            }
            return
        }
        
        self.executionState = .busy
        execute(request) { [weak self] value, handler in
            self?.executionState = .normal
            _ = self?.dequeue()
            print("deleted \(value) from queue.")
            handler(value)
        }
    }
    
    private func execute(_ request: _RequestQueue, _ completion: @escaping _ExecutionResponseType) {
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 5) {
            completion(request.0, request.1)
        }
    }
    
    public func write(value: String, _ handler: @escaping _ResponseType) {
        self.enqueue((value, handler))
    }
}
