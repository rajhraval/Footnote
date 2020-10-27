//
//  AddQuoteUIKit.swift
//  Footnote2
//
//  Created by Cameron Bardell on 2020-03-06.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import SwiftUI
import UIKit

struct AddQuoteUIKit: View {

    @Environment(\.managedObjectContext) var managedObjectContext

    // Issue #17: Indicates the media type of the quote being added
    @State private var mediaType = MediaType.book

    @State var text: String = ""
    @State var author: String = ""
    @State var title: String = ""

    // Textfield Validation
    @State private var showEmptyTextFieldAlert = false
    private var textFieldsAreNonEmpty: Bool {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAuthor = author.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)

        return !trimmedText.isEmpty && !trimmedAuthor.isEmpty && !trimmedTitle.isEmpty
    }

    // For the height of the text field.
    @State var textHeight: CGFloat = 0
    @State var authorHeight: CGFloat = 0
    @State var titleHeight: CGFloat = 0

    @Binding var showModal: Bool

    init(showModal: Binding<Bool>) {
        UITableView.appearance().backgroundColor = .clear
        self._showModal = showModal
    }

    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?

    var body: some View {

        VStack(spacing: 20) {
            // Issue #17: Provides the user a choice of media types to use with their quote.
            // It is displayed in a segmented picker control
            Picker("Media Type", selection: $mediaType) {
                ForEach(MediaType.allCases, id: \.rawValue) {type in
                    Text(type.stringValue).font(.largeTitle)
                        .tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .accentColor(.blue)

            Divider()

            Form {
                Section(header: Text("Text").foregroundColor(.white)) {
                    if #available(iOS 14.0, *) {
                        TextEditor(text: $text)
                    } else {
                        TextField("If my life is going to mean anything, I have to live it myself.", text: $title)
                    }
                }
                Section(header: Text("Title").foregroundColor(.white)) {
                    TextField("The Lightning Thief", text: $title)
                }
                Section(header: Text("Author").foregroundColor(.white)) {
                    TextField("Rick Riordan", text: $author)
                }
            }
            Divider()
            SuggestionsView(searchString: self.title)
                .background(Color.white)

            Button(action: {
                if textFieldsAreNonEmpty {
                    self.addQuote()
                    self.showModal.toggle()
                } else {
                    self.showEmptyTextFieldAlert = true
                }
            }, label: {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.white)
                    .frame(height: 40)
                    .padding(.horizontal)
                    .overlay(
                        Text("Save changes")
                            .foregroundColor(.black)
                )
            })
            .alert(isPresented: $showEmptyTextFieldAlert, content: {
                Alert(title: Text("Error Saving Quote"),
                      message: Text("Please ensure that all text fields are filled before saving."),
                      dismissButton: .default(Text("Ok")))
            })
            Spacer()

        }.padding(.top)
            .background(Color.footnoteRed)
        .edgesIgnoringSafeArea(.bottom)
    }

    func addQuote() {
        // Add a new quote
        let quote = Quote(context: self.managedObjectContext)
        quote.title = self.title
        quote.text = self.text
        quote.author = self.author
        quote.dateCreated = Date()

        // Issue #17: Save the media type along with the quote in coredata
        quote.mediaType = self.mediaType.rawCoreDataValue()

        //        let authorItem = Author(context: self.managedObjectContext)
        //        authorItem.text = self.author
        //        authorItem.count += 1
        //
        //        let titleItem = Title(context: self.managedObjectContext)
        //        titleItem.text = self.title
        //        titleItem.count += 1

        if inputImage != nil {
            quote.coverImage = inputImage!.pngData() as Data?
        }

        do {
            try self.managedObjectContext.save()
        } catch {
            // handle the Core Data error
            print("Failed to save new item. Error = \(error)")
            managedObjectContext.delete(quote)
        }

        title = ""
        text = ""
        author = ""
    }

}

// To preview with CoreData
#if DEBUG
struct AddQuoteUIKit_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next force_cast
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return Group {
            AddQuoteUIKit(showModal: .constant(true))
                .environment(\.managedObjectContext, context)
                .environment(\.colorScheme, .light)
        }
    }
}
#endif
