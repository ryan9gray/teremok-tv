

import UIKit

extension String {
    var appointmentDateString: Date? {
        let dateFormat = "dd.MM.yyyy"
        return date(withFormat: dateFormat)
    }

    private func date(withFormat format: String) -> Date? {
        let inputFormatter = DateFormatter()
        inputFormatter.timeZone = TimeZone.current
        inputFormatter.dateFormat = format
        return inputFormatter.date(from: self)
    }
    
    var htmlToString: NSAttributedString? {
        return try? NSAttributedString(data: Data(utf8),
                                       options: [
                                        NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                                        NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
                                       documentAttributes: nil)
    }
    
    func md5() -> String {
        
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, self, CC_LONG(lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate()
        var hexString = ""
        for byte in digest {
            hexString += String(format: "%02x", byte)
        }
        
        return hexString
    }
    
    func md5HashAsUUID() -> UUID {
        //
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, self, CC_LONG(lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate()
        return NSUUID.init(uuidBytes: &digest) as UUID
    }
    
    func insert(seperator: String, afterEachIndex: Int) -> String {
        var result = ""
        enumerated().forEach { index, element in
            if index % afterEachIndex == 0 && index > 0 {
                result += seperator
            }
            result.append(element)
        }
        return result
    }
    
    func textSize(width: CGFloat, font: UIFont, numberOfLines: Int = Int.max) -> CGSize {
        
        let myString = self as NSString
        let maxHeight: CGFloat = font.lineHeight * CGFloat(numberOfLines)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        
        let rectNeeded = myString.boundingRect(with: CGSize(width: width, height: maxHeight),
                                               options: .usesLineFragmentOrigin,
                                               attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraph],
                                               context: nil)
        
        return rectNeeded.size
    }
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    func substring(with range: NSRange) -> String {
        return (self as NSString).substring(with: range) // 🇩🇪
    }
    
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}
