import Foundation

public typealias ResponseType = (String, [Int]) -> Void

public class TaskHandler {
    private var receivedValues = [Int]()
    private var size: Int = 0
    private var isFirstRequest = true
    private var currentHandler: ResponseType?
    
    public init() {}
    
    public func request(for name: String, _ handler: @escaping ResponseType) {
        if isFirstRequest {
            isFirstRequest.toggle()
            executeRequest(name: name, handler)
        } else {
            if self.currentHandler != nil {
                TaskQueue.shared.append((name, handler))
            } else {
                executeRequest(name: name, handler)
            }
        }
    }
    
    private func executeRequest(name: String, _ handler: @escaping ResponseType) {
        initilizeBuffer()
        let resources = Resources()
        self.size = resources.maxSize
        print("started executing... maximum size:", self.size)
        
        resources.didNotify = { values in
            if self.isReceivedComplete(values) {
                self.sendResponse(message: "data received for \(name)", value: self.receivedValues)
            } else {
                print("Data received yet: \(self.receivedValues.count) bytes")
            }
        }
        
        self.currentHandler = handler
        resources.find()
    }
    
    private func initilizeBuffer() {
        self.receivedValues = []
        self.size = 0
    }
    
    private func isReceivedComplete(_ values: [Int]) -> Bool {
        self.receivedValues.append(contentsOf: values)
        print("received: \(values.count) bytes.")
        return self.size == self.receivedValues.count
    }
    
    private func sendResponse(message: String, value: [Int]) {
        self.currentHandler?(message, value)
        self.currentHandler = nil
        guard let pendingTask = TaskQueue.shared.firstTask() else { return }
        self.request(for: pendingTask.0, pendingTask.1)
    }
}
