import Foundation

extension String {
    var isNilOrHasSpace: Bool {
        if self == " " || self == nil {
            return true
        } else {
            return false
        }
    }

    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
//    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}

extension String {
    
    var isNumeric: Bool {
        guard !isEmpty else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
