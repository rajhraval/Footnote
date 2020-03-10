//
//  AddQuoteView.swift
//  Footnote2
//
//  Created by Cameron Bardell on 2019-12-10.
//  Copyright © 2019 Cameron Bardell. All rights reserved.
//

import SwiftUI

struct AddQuoteView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var text: String = ""
    @State var author: String = ""
    @State var title: String = ""
    
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack(spacing: 5) {
                HStack {
                    if self.image != nil {
                        self.image?
                        .resizable()
                            .frame(width: 50, height: 70)
                        .padding(5)
                    } else {
                        Button(action: {
                            print("Select cover")
                            self.showingImagePicker = true
                        }) {
                            VStack {
                                Image(systemName: "book.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color.white)
                                    .padding(.top, 5)
                                Text("Add Cover")
                                    .foregroundColor(Color.white)
                                    .padding([.leading, .bottom], 5)
                            }
                        }
                    }
                    
                    
                    Spacer()
                    
                    
                    Button(action: {
                        self.addQuote()
                    }) {
                        VStack {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color.white)
                                .padding([.trailing, .top], 5)
                            Text("Save")
                                .foregroundColor(Color.white)
                                .padding(.bottom, 5)
                        }
                    }
                }
                
                TextField("Text", text: self.$text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.leading, .trailing, .bottom], 5)
                
                
                TextField("Title", text: self.$title)
                    .textContentType(.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.leading, .trailing, .bottom], 5)
                    .disableAutocorrection(true)
                
                TextField("Author", text: self.$author)
                    .textContentType(.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.leading, .trailing], 5)
                    .disableAutocorrection(true)
                
                AuthorSuggestionsView(filter: self.author, text: self.$author).environment(\.managedObjectContext, self.managedObjectContext)
                    .frame(width: geometry.size.width - 30, height: 50)
                
                TitleSuggestionsView(filter: self.title, text: self.$title).environment(\.managedObjectContext, self.managedObjectContext)
                .frame(width: geometry.size.width - 30, height: 50)
                
                Text("Add Quote").font(.title).foregroundColor(Color.white)
                Text("Swipe to dismiss").font(.footnote).foregroundColor(Color.white)
                Spacer()
                
            }.sheet(isPresented: self.$showingImagePicker, onDismiss: self.loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            .frame(width: geometry.size.width - 20, height: geometry.size.height)
                .background(Color.footnoteRed)
                .cornerRadius(10)
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func addQuote() {
        // Add a new quote
        let quote = Quote(context: self.managedObjectContext)
        quote.title = self.title
        quote.text = self.text
        quote.author = self.author
        quote.dateCreated = Date()
        
        let authorItem = Author(context: self.managedObjectContext)
        authorItem.text = self.author
        authorItem.count += 1
        
        let titleItem = Title(context: self.managedObjectContext)
        titleItem.text = self.title
        titleItem.count += 1
        
        if inputImage != nil {
            quote.coverImage = inputImage!.pngData() as Data?
        }
        
        
        do {
            try self.managedObjectContext.save()
        } catch {
            // handle the Core Data error
        }
        
        title = ""
        text = ""
        author = ""
    }
}




// To preview with CoreData
#if DEBUG
struct AddQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return Group {
            AddQuoteView().environment(\.managedObjectContext, context).environment(\.colorScheme, .light)
            
        }
         
    }
}
#endif
