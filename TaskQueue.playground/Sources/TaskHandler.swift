import Foundation

public typealias handlerType = ((Data?) -> Void)

final public class TaskHandler {
    private var pendingTask: [(Data?, handlerType)] = []
    private var isProcessing = false {
        didSet {
            if !isProcessing && pendingTask.isEmpty {
                didFinishAllQuery?()
            } else if !isProcessing, let task = pendingTask.first {
                pendingTask.removeFirst()
                executeTask(data: task.0, task.1)
            } else {
                print("processing in progress...")
            }
        }
    }
    
    public var didFinishAllQuery: (() -> Void)?
    
    public init() { }

    public func executeTask(data: Data?, _ handler: @escaping handlerType) {
        if isProcessing {
            pendingTask.append((data, handler))
        } else {
            isProcessing = true
            DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 2.0) {
                self.sendResponse(to: handler, data: data)
            }
        }
    }
    
    private func sendResponse(to caller: handlerType, data: Data?) {
        caller(data)
        self.isProcessing = false
    }
}
