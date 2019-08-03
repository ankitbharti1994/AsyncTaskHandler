import Foundation

public class Resources {
    public let maxSize: Int
    private var sentSize = 0
    
    public init() {
        self.maxSize = Int.random(in: 1...50)
    }
    
    public var didNotify: (([Int]) -> Void)?
    
    private var receive: [Int] {
        guard self.sentSize < self.maxSize else {
            print("difference: \(self.maxSize - self.sentSize)")
            return []
        }
        
        let needToSend = maxSize - sentSize
        let valueToSend = Int.random(in: 0..<100)
        let sizeToSend = Int.random(in: 1...needToSend)
        let dataToSend = [Int](repeating: valueToSend, count: sizeToSend)
        self.sentSize += dataToSend.count
        return dataToSend
    }
    
    public func find() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let values = self.receive
            guard !values.isEmpty else {
                return
            }
            
            self.didNotify?(values)
            self.find()
        }
        
        self.didNotify?(self.receive)
    }
}
