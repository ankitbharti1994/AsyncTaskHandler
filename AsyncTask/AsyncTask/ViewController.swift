//
//  ViewController.swift
//  AsyncTask
//
//  Created by ankit bharti on 03/08/19.
//  Copyright © 2019 ankit kumar bharti. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let names = ["ankit", "kailash", "garima", "rohit", "sumit"]
    @IBAction func startExecuting(_ sender: Any) {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 10
        
        let _names = names[0..<Int.random(in: 0..<names.count)]
        
        for _name in _names {
            operationQueue.addOperation {
                let name = _name
                ServiceQueue.shared.write(value: name) { response in
                    print("received response for \(name): \(response)")
                }
            }
        }
        
        /*
        operationQueue.addOperation {
            let name = "rohit shrivastva"
            ServiceQueue.shared.write(value: name) { response in
                print("received response for \(name): \(response)")
            }
        }
    
        
        operationQueue.addOperation {
            let name = "kailash kumar"
            ServiceQueue.shared.write(value: name) { response in
                print("received response for \(name): \(response)")
            }
        }
        
        operationQueue.addOperation {
            let name = "garima sharma"
            ServiceQueue.shared.write(value: name) { response in
                print("received response for \(name): \(response)")
            }
        }
        
        operationQueue.addOperation {
            let name = "sumit sharma"
            ServiceQueue.shared.write(value: name) { response in
                print("received response for \(name): \(response)")
            }
        }
        
        operationQueue.addOperation {
            let name = "shashi mishra"
            ServiceQueue.shared.write(value: name) { response in
                print("received response for \(name): \(response)")
            }
        }
        
        operationQueue.addOperation {
            let name = "nitish diwakar"
            ServiceQueue.shared.write(value: name) { response in
                print("received response for \(name): \(response)")
            }
        }
        
        operationQueue.addOperation {
            let name = "aakriti kishore"
            ServiceQueue.shared.write(value: name) { response in
                print("received response for \(name): \(response)")
            }
        }
 */
    }
}

