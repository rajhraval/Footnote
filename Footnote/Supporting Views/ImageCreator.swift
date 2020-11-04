//
//  ImageCreator.swift
//  Footnote2
//
//  Created by Cameron Bardell on 2020-01-25.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import SwiftUI
import UIKit

struct ImageCreator: View {
    var text: String
    var source: String

    var colors: [UIColor] = [
        .black,
        .uclaBlue,
        .tuftsBlue,
        .tiffanyBlue,
        .paleRobinEggBlue,
        .pastelGreen,
        .kellyGreen,
        .yellow,
        .sunglow,
        .westSide,
        .safetyOrange,
        .crayonRed,
        .harvardCrimson,
        .bordeaux,
        .deepFuchsia
    ]

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

    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?

    @State private var showingShareSheet = false

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    self.drawImage(width: geometry.size.width - 10, height: geometry.size.height / 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .foregroundColor(Color(self.selectedColor))
                    )
                        .gesture(DragGesture().onChanged { value in
                            self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width,
                                                          height: value.translation.height + self.newPosition.height)
                        }   // 4.
                            .onEnded { value in
                                self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width,
                                                              // swiftlint:disable:next line_length
                                                              height: value.translation.height + self.newPosition.height)
                                print(self.newPosition.width)
                                self.newPosition = self.currentPosition
                        })
                        .padding(.top)

                    ScrollView(.vertical) {
                        Button(action: {
                            print("Image picker")
                            self.showingImagePicker = true

                        }, label: {
                            Text("Add a background image")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color(self.selectedColor))
                                .cornerRadius(10)
                        }).sheet(isPresented: self.$showingImagePicker, onDismiss: self.loadBackgroundImage) {
                            ImagePicker(image: self.$inputImage)
                        }

                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(self.fonts, id: \.self) { font in
                                    Button(action: {
                                        withAnimation(.easeInOut) {
                                            self.selectedFont = font
                                        }

                                    }, label: {
                                        Text(font.components(separatedBy: "-")[0])
                                            .padding()
                                            .foregroundColor(self.selectedFont == font ? .white : .black)
                                            .font(.custom(font, size: 15))
                                            .background(self.selectedFont == font ? Color(self.selectedColor) : .white)
                                            .cornerRadius(10)

                                    })
                                }
                            }
                        }.padding()

                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(self.colors, id: \.self) { color in
                                    Button(action: {
                                        withAnimation(.easeInOut) {
                                            self.selectedColor = color
                                        }

                                    }, label: {
                                        Circle().foregroundColor(Color(color))
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Circle().stroke(Color.gray,
                                                                lineWidth: self.selectedColor == color ? 3 : 0))
                                    })
                                }
                            }.padding()
                        }

                        HStack {
                            Text("Font size")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color(self.selectedColor))
                                .cornerRadius(10)
                                .padding(.leading, 5)
                            Slider(value: self.$fontSize, in: 1...50, step: 1)
                                .padding(.trailing).accentColor(Color(self.selectedColor))
                        }

                        HStack {
                            Button(action: {
                                self.saveImage(image: self.renderImage(width: geometry.size.width,
                                                                       height: geometry.size.height / 2))
                                self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                HStack {
                                    Text("Save to Library")
                                    Image(systemName: "square.and.arrow.down")
                                        .font(.headline)
                                }
                                .padding()
                                .foregroundColor(.white)
                                .background(Color(self.selectedColor))
                                .cornerRadius(10)
                            })
                            .layoutPriority(1)

                            Spacer()
                                .layoutPriority(0)

                            Button(action: {
                                    self.showingShareSheet = true
                            }, label: {
                                HStack {
                                    Text("Share Image")
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.headline)
                                }
                                .padding()
                                .foregroundColor(.white)
                                .background(Color(self.selectedColor))
                                .cornerRadius(10)
                            })
                            .layoutPriority(1)
                            .sheet(isPresented: self.$showingShareSheet) {
                                ShareSheetView(activityItems: [self.renderImage(width: geometry.size.width-10,
                                                                                height: geometry.size.height/2)])
                            }
                        }
                        .padding()
                    }

                }
            }
            .navigationBarTitle("Share Quote", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            })
        }

    }

    func loadBackgroundImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }

    func renderImage(width: CGFloat, height: CGFloat) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))

        let img = renderer.image { _ in
            // 2

            if let background = inputImage {
                let resizable = background.resizableImage(withCapInsets: UIEdgeInsets(top: 0,
                                                                                      left: 0,
                                                                                      bottom: 0,
                                                                                      right: 0),
                                                          resizingMode: .stretch)
                resizable.draw(in: CGRect(x: 0, y: 0, width: width, height: height))

            }

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

            let attributedString = NSMutableAttributedString(string: text, attributes: attrs)

            let sourceAttributedString = NSAttributedString(string: "\n\n —\(self.source)", attributes: attrs)

            attributedString.append(sourceAttributedString)
            // 5
            attributedString.draw(with: CGRect(x: self.currentPosition.width + 5,
                                               y: self.currentPosition.height + 50,
                                               width: width - 10,
                                               height: height),
                                  options: .usesLineFragmentOrigin,
                                  context: nil)

//            let watermarkAttrs: [NSAttributedString.Key: Any] = [
//                .font: UIFont.systemFont(ofSize: 29)
//            ]
//
//            let attributedWatermark = NSMutableAttributedString(string: "Footnote", attributes: watermarkAttrs)
//
//            let watermarkAttachment = NSTextAttachment()
//                       watermarkAttachment.image = UIImage(named: "icon2")
//                       let iconString = NSAttributedString(attachment: watermarkAttachment)
//            attributedWatermark.append(iconString)
//
// swiftlint:disable:next line_length
//            attributedWatermark.draw(with: CGRect(x: width - 150, y: height - 40, width: width, height: height), options: .usesLineFragmentOrigin, context: nil)

        }

        return img

        // Prints all available font names
        //        for family in UIFont.familyNames.sorted() {
        //            let names = UIFont.fontNames(forFamilyName: family)
        //            print("Family: \(family) Font names: \(names)")
        //        }
    }

    func drawImage(width: CGFloat, height: CGFloat) -> Image {
        return Image(uiImage: renderImage(width: width, height: height))
    }

    func saveImage(image: UIImage) {
        // https://www.hackingwithswift.com/books/ios-swiftui/how-to-save-images-to-the-users-photo-library
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }

    // Copied from StackOverflow, not tested.
//    func shareToInstagram(deepLinkString : String){
//        let url = URL(string: "instagram-stories://share")!
//        if UIApplication.shared.canOpenURL(url){
//
//            let backgroundData = UIImage(named: "shop_placeholder")!.jpegData(compressionQuality: 1.0)!
//            let creditCardImage = UIImage(named: "share_instagram")!
//            let stickerData = creditCardImage.pngData()!
//            let pasteBoardItems = [
//                ["com.instagram.sharedSticker.backgroundImage" : backgroundData],
//                ["com.instagram.sharedSticker.stickerImage" : stickerData],
//            ]
//
//            if #available(iOS 10.0, *) {
//
//                UIPasteboard.general.setItems(pasteBoardItems,
//                                            options: [.expirationDate: Date().addingTimeInterval(60 * 5)])
//            } else {
//                UIPasteboard.general.items = pasteBoardItems
//            }
//            UIApplication.shared.openURL(url)
//        }
//    }
}

struct ImageCreator_Previews: PreviewProvider {
    static var previews: some View {
        ImageCreator(text: "All work and no play makes Jack a dull boy.", source: "Jack Nicholson")
    }
}
