import PlaygroundSupport
import Foundation

PlaygroundPage.current.needsIndefiniteExecution = true

/*
let handler = TaskHandler()

handler.request(for: "ankit") { message, data in
    print(message, data.count)
    print("------------------------------------\n")
}

handler.request(for: "rohit") { message, data in
    print(message, data.count)
    print("------------------------------------\n")
}

handler.request(for: "garima") { message, data in
    print(message, data.count)
    print("------------------------------------\n")
}

handler.request(for: "sumit") { message, data in
    print(message, data.count)
    print("------------------------------------\n")
}

handler.request(for: "kailash") { message, data in
    print(message, data.count)
    print("------------------------------------\n")
    PlaygroundPage.current.finishExecution()
}

 */

/*
var names = [String]() {
    didSet {
        print("after appended new name: \(names)", names.count)
    }
}

let queue1 = DispatchQueue(label: "com.ankit.queue1")
let queue2 = DispatchQueue(label: "com.ankit.queue2")
let queue3 = DispatchQueue(label: "com.ankit.queue3")

queue1.async {
    names.append("ankit")
    semaphore.signal()
}

semaphore.wait()
print("Rohit in waiting...")
queue2.asyncAfter(deadline: .now() + 3) {
    names.append("rohit")
    semaphore.signal()
}

semaphore.wait()
print("Garima in waiting...")
queue3.async {
    names.append("garima")
    semaphore.signal()
}
*/

func startExecuting() {
    DispatchQueue.global(qos: .default).async {
        let name = "ankit bharti"
        ServiceQueue.shared.write(value: name) { response in
            print("received response for \(name): \(response)")
        }
    }
    
    DispatchQueue.global(qos: .default).async {
        let name = "rohit shrivastva"
        ServiceQueue.shared.write(value: name) { response in
            print("received response for \(name): \(response)")
        }
    }
    
    DispatchQueue.global(qos: .default).async {
        let name = "kailash kumar"
        ServiceQueue.shared.write(value: name) { response in
            print("received response for \(name): \(response)")
        }
    }
    
    DispatchQueue.global(qos: .default).async {
        let name = "garima sharma"
        ServiceQueue.shared.write(value: name) { response in
            print("received response for \(name): \(response)")
        }
    }
    
    DispatchQueue.global(qos: .default).async {
        let name = "sumit sharma"
        ServiceQueue.shared.write(value: name) { response in
            print("received response for \(name): \(response)")
        }
    }
    
    DispatchQueue.global(qos: .default).async {
        let name = "shashi mishra"
        ServiceQueue.shared.write(value: name) { response in
            print("received response for \(name): \(response)")
        }
    }
    
    DispatchQueue.global(qos: .default).async {
        let name = "nitish diwakar"
        ServiceQueue.shared.write(value: name) { response in
            print("received response for \(name): \(response)")
        }
    }
    
    DispatchQueue.global(qos: .default).async {
        let name = "aakriti kishore"
        ServiceQueue.shared.write(value: name) { response in
            print("received response for \(name): \(response)")
        }
    }
}

startExecuting()
