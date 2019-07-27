import Foundation
import PlaygroundSupport

let data1 = "ankit".data(using: .utf8)
let data2 = "rohit".data(using: .utf8)
let data3 = "garima".data(using: .utf8)
let data4 = "kailash".data(using: .utf8)

PlaygroundPage.current.needsIndefiniteExecution = true

let taskHandler = TaskHandler()
taskHandler.executeTask(data: data1) { data in
    print("executed task for \(String(data: data!, encoding: .utf8)!)")
}

taskHandler.executeTask(data: data2) { data in
    print("executed task for \(String(data: data!, encoding: .utf8)!)")
}

taskHandler.executeTask(data: data3) { data in
    print("executed task for \(String(data: data!, encoding: .utf8)!)")
}

taskHandler.executeTask(data: data4) { data in
    print("executed task for \(String(data: data!, encoding: .utf8)!)")
}

taskHandler.didFinishAllQuery = {
    print("process completed")
    PlaygroundPage.current.finishExecution()
}
