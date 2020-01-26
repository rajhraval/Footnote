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
    
    var colors: [UIColor] = [.black, .red, .orange, .yellow, .green, .blue, .purple, .brown, .cyan, .magenta]
    @State var selectedColor = UIColor.black
    var body: some View {
        GeometryReader { geometry in
            VStack {
                self.drawImage(width: geometry.size.width - 10, height: geometry.size.height / 2)
                    
                    .border(Color.black)
                
                Spacer()
                HStack {
                    ForEach(self.colors, id: \.self) { color in
                        Button(action: {
                            self.selectedColor = color
                        }) {
                            Circle().foregroundColor(Color(color))
                                .frame(width: geometry.size.width / CGFloat(self.colors.count) - 10, height: geometry.size.width / CGFloat(self.colors.count) - 10)
                                .overlay(
                                    Circle().stroke(Color.gray, lineWidth: self.selectedColor == color ? 3 : 0))
                        }
                    }
                }.padding()
                Button(action: {
                    self.saveImage(image: self.drawUIImage(width: geometry.size.width, height: geometry.size.height / 2))
                }) {
                    Text("Save")
                }
            }
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
                .paragraphStyle: paragraphStyle,
                .foregroundColor: self.selectedColor
            ]
            
            
            let attributedString = NSAttributedString(string: text, attributes: attrs)
            
            // 5
            attributedString.draw(with: CGRect(x: 0, y: height / 2, width: width - 10, height: height), options: .usesLineFragmentOrigin, context: nil)
            
            
        }
        
        return Image(uiImage: img)
    }
    
    func drawUIImage(width: CGFloat, height: CGFloat) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        
        let img = renderer.image { ctx in
            // 2
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            // 3
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: self.selectedColor
            ]
            
            
            let attributedString = NSAttributedString(string: text, attributes: attrs)
            
            // 5
            attributedString.draw(with: CGRect(x: 0, y: 0, width: width - 10, height: height), options: .usesLineFragmentOrigin, context: nil)
            
            
        }
        
        return img
    }
    
    func saveImage(image: UIImage) {
        // TODO: what happens if saving fails. https://www.hackingwithswift.com/books/ios-swiftui/how-to-save-images-to-the-users-photo-library
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}


struct ImageCreator_Previews: PreviewProvider {
    static var previews: some View {
        ImageCreator(text: "The best laid plans of mice and men")
    }
}
