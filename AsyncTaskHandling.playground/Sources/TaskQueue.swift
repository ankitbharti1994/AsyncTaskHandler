import Foundation

public typealias QueueType = (String, (String, [Int]) -> Void)

public class TaskQueue {
    private init() { }
    public static let shared = TaskQueue()
    public let semaphore = DispatchSemaphore(value: 0)
    
    private var queue: [QueueType] = []
    private var id: [Int] = []
    
    public var isEmpty: Bool {
        return queue.isEmpty
    }
    
    public var count: Int {
        return queue.count
    }
    
    public func append(_ newQueue: QueueType) {
        print("append \(newQueue.0)")
        self.queue.append(newQueue)
        print("after appending: \(self.count)")
    }
    
    public func remove() {
        guard !isEmpty else {
            return
        }
        
        _ = queue.removeFirst()
    }
    
    public func firstTask() -> QueueType? {
        let firstTask = queue.first
        self.remove()
        return firstTask
    }
}
