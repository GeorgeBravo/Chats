// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSColor
  internal typealias Color = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIColor
  internal typealias Color = UIColor
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Colors

// swiftlint:disable identifier_name line_length type_body_length
internal struct ColorName {
  internal let rgbValue: UInt32
  internal var color: Color { return Color(named: self) }

  internal static let blackColor = ColorName(rgbValue: 0x000000)
  internal static let coolGrey = ColorName(rgbValue: 0xa2a9b6)
  internal static let coolGreyTwo = ColorName(rgbValue: 0xa5aab1)
  internal static let descriptionGrayColor = ColorName(rgbValue: 0xa5aab1)
  internal static let optionsBlackColor = ColorName(rgbValue: 0x262626)
  internal static let optionsBlueColor = ColorName(rgbValue: 0x504eeb)
  internal static let optionsRedColor = ColorName(rgbValue: 0xed1c24)
  internal static let separatorColor = ColorName(rgbValue: 0xa2a9b6)
  internal static let slateGrey = ColorName(rgbValue: 0x60676f)
  internal static let whiteColor = ColorName(rgbValue: 0xffffff)
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

// swiftlint:disable operator_usage_whitespace
internal extension Color {
  convenience init(hex rgbValue: UInt32) {
    let red = CGFloat((rgbValue >> 16) & 0xff) / 255.0
    let green  = CGFloat((rgbValue >>  8) & 0xff) / 255.0
    let blue = CGFloat((rgbValue      ) & 0xff) / 255.0
    let alpha: CGFloat = 1
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
// swiftlint:enable operator_usage_whitespace

internal extension Color {
  convenience init(named color: ColorName) {
    self.init(hex: color.rgbValue)
  }
}
