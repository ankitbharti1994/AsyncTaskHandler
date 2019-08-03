import PlaygroundSupport
import Foundation

PlaygroundPage.current.needsIndefiniteExecution = true

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
