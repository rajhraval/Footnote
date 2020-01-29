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
    
 
    
    var colors: [UIColor] = [.yellow, .kellyGreen, .crayonRed, .tiffanyBlue, .pastelGreen, .paleRobinEggBlue, .safetyOrange, .harvardCrimson, .bordeaux, .uclaBlue, .tuftsBlue, .deepFuchsia]
    
    var fonts: [String] = [
        "Merriweather-Regular",
        "Lobster-Regular",
        "Bangers-Regular",
        "CabinSketch-Regular",
        "CormorantGaramond-Medium",
        "LifeSavers-Regular",
        "PermanentMarker-Regular",
        "PlayfairDisplay-Regular"
    ]
    
    @State private var selectedFont = "Merriweather-Regular"
    @State private var selectedColor = UIColor.black
    @State private var fontSize: Double = 20
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                self.drawImage(width: geometry.size.width - 10, height: geometry.size.height / 2)
                    .border(Color.black)
                    .gesture(DragGesture().onChanged { value in
                            self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                    }   // 4.
                        .onEnded { value in
                            self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                            print(self.newPosition.width)
                            self.newPosition = self.currentPosition
                        })
                
                Spacer()
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(self.fonts, id: \.self) { font in
                            Button(action: {
                                self.selectedFont = font
                            }) {
                                Text(font)
                                    .foregroundColor(self.selectedFont == font ? Color(self.selectedColor) : .black)
                                .font(.custom(font, size: 20))
                                
                            }
                            
                        }
                    }
                }.padding()
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(self.colors, id: \.self) { color in
                            Button(action: {
                                self.selectedColor = color
                            }) {
                                Circle().foregroundColor(Color(color))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Circle().stroke(Color.gray, lineWidth: self.selectedColor == color ? 3 : 0))
                            }
                        }
                    }.padding()
                }
                
                Slider(value: self.$fontSize, in: 1...100, step: 1)
                    .padding()
                
                Button(action: {
                    self.saveImage(image: self.drawUIImage(width: geometry.size.width, height: geometry.size.height / 2))
                }) {
                    Text("Save").padding()
                        .foregroundColor(.white)
                        .background(Color.footnoteRed)
                        .cornerRadius(10)
                        .padding(5)
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
            
            guard let customFont = UIFont(name: self.selectedFont, size: CGFloat(self.fontSize)) else {
                fatalError("""
                    Failed to load the "CustomFont-Light" font.
                    Make sure the font file is included in the project and the font name is spelled correctly.
                    """
                )
            }
            
            // 3
            let attrs: [NSAttributedString.Key: Any] = [
                .font: customFont,
                .paragraphStyle: paragraphStyle,
                .foregroundColor: self.selectedColor
            ]
            
            
            let attributedString = NSAttributedString(string: text, attributes: attrs)
            
            // 5
            attributedString.draw(with: CGRect(x: self.currentPosition.width, y: self.currentPosition.height, width: width, height: height), options: .usesLineFragmentOrigin, context: nil)
            
            
        }
        
        // Prints all available font names
//        for family in UIFont.familyNames.sorted() {
//            let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family) Font names: \(names)")
//        }
        
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
                .font: UIFont.systemFont(ofSize: CGFloat(self.fontSize)),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: self.selectedColor
            ]
            
            let attributedString = NSAttributedString(string: text, attributes: attrs)
            
            // 5
            attributedString.draw(with: CGRect(x: 5, y: height / 2.5, width: width - 10, height: height), options: .usesLineFragmentOrigin, context: nil)
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
        ImageCreator(text: "All work and no play makes Jack a dull boy.")
    }
}
