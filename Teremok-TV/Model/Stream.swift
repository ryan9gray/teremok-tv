
import Foundation

struct Stream: Hashable, Codable {
    let url: URL
    let name: String
    let art: Data?
    let id: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(url)
    }
}

extension Stream: Equatable {
    static func ==(lhs: Stream, rhs: Stream) -> Bool {
        return (lhs.name == rhs.name) && (lhs.url == rhs.url)
    }
}
