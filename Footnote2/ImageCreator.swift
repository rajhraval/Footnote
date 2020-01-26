//
//  ImageCreator.swift
//  Footnote2
//
//  Created by Cameron Bardell on 2020-01-25.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import SwiftUI

struct ImageCreator: View {
    var text: String
    var body: some View {
        GeometryReader { geometry in
            self.drawImage(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    func drawImage(width: CGFloat, height: CGFloat) -> Image {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))

        let img = renderer.image { ctx in
            // 2
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            // 3
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24),
                .paragraphStyle: paragraphStyle
            ]

            
            let attributedString = NSAttributedString(string: text, attributes: attrs)

            // 5
            attributedString.draw(with: CGRect(x: 0, y: 0, width: width - 10, height: height), options: .usesLineFragmentOrigin, context: nil)

            
        }

        return Image(uiImage: img)
    }
}

struct ImageCreator_Previews: PreviewProvider {
    static var previews: some View {
        ImageCreator(text: "The best laid plans of mice and men")
    }
}
