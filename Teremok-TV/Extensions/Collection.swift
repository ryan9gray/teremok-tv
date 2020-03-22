

import Foundation

extension Collection {
    func allUnwrapapping<T>(transform: (Iterator.Element) -> T?) -> [T]? {
        let array = lazy.compactMap(transform)
        return array.count == count ? array : nil
    }
}
extension Sequence {
	/// Returns an array with the contents of this sequence, shuffled.
	func shuffled() -> [Element] {
		var result = Array(self)
		result.shuffle()
		return result
	}
}
extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
//    subscript (safe index: Index) -> Iterator.Element? {
//        return indices.contains(index) ? self[index] : nil
//    }
    var second: Element? {
        // Is the collection empty?
        guard self.startIndex != self.endIndex else { return nil } // Get the second index
        let index = self.index(after: self.startIndex)
        // Is that index valid?
        guard index != self.endIndex else { return nil } // Return the second element
        return self[index]
    }

}
extension Collection where Indices.Iterator.Element == Index {
   public subscript(safe index: Index) -> Iterator.Element? {
     return (startIndex <= index && index < endIndex) ? self[index] : nil
   }
}
extension RawRepresentable where Self: Hashable {
    
    static func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
        var i = 0
        var first: T?
        return AnyIterator {
            let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
            if i == 0 {
                first = next
            } else if next == first {
                return nil
            }
            i += 1
            return next
        }
    }
    
    static func allValues() -> [Self] {
        return Array(iterateEnum(Self.self))
    }
    
}
