//
//  Cosmetics.swift
//  Footnote2
//
//  Created by Cameron Bardell on 2019-12-10.
//  Copyright © 2019 Cameron Bardell. All rights reserved.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
    
    // Palette 1
    static let footnoteBlue = Color(UIColor(red: 0.15, green: 0.43, blue: 0.83, alpha: 1.00))
    static let footnoteBabyBlue = Color(UIColor(red: 0.54, green: 0.81, blue: 0.94, alpha: 1.00))
    static let footnoteCream = Color(UIColor(red: 1.00, green: 1.00, blue: 0.96, alpha: 1.00))
    static let footnotePurple = Color(UIColor(red: 0.53, green: 0.50, blue: 0.60, alpha: 1.00))
    static let footnoteDark = Color(UIColor(red: 0.20, green: 0.25, blue: 0.33, alpha: 1.00))
    
}
