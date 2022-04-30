
import Foundation
import CommonCrypto
import CryptoKit

@objc class CryptoManager: NSObject {
    @objc static func sha256(fromString string: String?) -> String? {
        guard
            let string = string,
            let data = string.data(using: .utf8)
        else { return nil }

        return sha256(fromData: data)
    }

    static func sha256(fromBase64Encoded base64Encoded: String?) -> String? {
        guard
            let base64Encoded = base64Encoded,
            let data = Data(base64Encoded: base64Encoded)
        else { return nil }

        return sha256(fromData: data)
    }

    private static func sha256(fromData data: Data) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes { bytes in
            _ = CC_SHA256(bytes.baseAddress, CC_LONG(data.count), &digest)
        }

        return digest.makeIterator().map { String(format: "%02x", $0) }.joined()
    }

    static func md5(data: Data) -> String {
        if #available(iOS 13.0, *) {
            return Insecure.MD5.hash(data: data).map { String(format: "%02x", $0) }.joined()
        } else {
            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            data.withUnsafeBytes { bytes in
                _ = CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
            }

            return digest.makeIterator().map { String(format: "%02x", $0) }.joined()
        }
    }
}
