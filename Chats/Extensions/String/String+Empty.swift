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
