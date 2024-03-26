//
//  Colors.swift
//  FetchRewardsTakeHome
//
//  Created by Trevor Walker on 3/25/24.
//

import SwiftUI

extension UIColor {
  convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
    let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
    let blue = CGFloat(hex & 0x0000FF) / 255.0
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }

  func asColor() -> Color { Color(uiColor: self) }
}

extension Color {
  static let primaryText = UIColor(hex: 0x333333, alpha: 1)
}
