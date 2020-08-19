import Foundation

extension String {
    var isNumeric: Bool {
        guard !isEmpty else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    static func isEmpty(_ string: String?) -> Bool {
        return string?.count ?? 0 == 0
    }
    
    func withAttributes(_ attributes: [NSAttributedString.Key : Any]) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    func mutableStringWithAttributes(_ attributes: [NSAttributedString.Key : Any]) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes: attributes)
    }

}
