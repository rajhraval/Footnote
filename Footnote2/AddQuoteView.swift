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
            VStack {
                HStack {
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
                    
                    Spacer()
                    
                    if self.image != nil {
                        self.image?
                            .resizable()
                            .scaledToFit()
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
                    .padding(5)
                
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

struct AuthorSuggestionsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    var fetchRequest: FetchRequest<Author>
    
    @Binding var text: String
    
    init(filter: String, text: Binding<String>) {
        fetchRequest = FetchRequest<Author>(entity: Author.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Author.count, ascending: false)
            ], predicate: NSCompoundPredicate(
                type: .or,
                subpredicates: [
                    // [cd] = case and diacritic insensitive
                    NSPredicate(format: "text CONTAINS[cd] %@", filter),
                ]
        ))
        
        // Initialize a binding variable
        self._text = text
        
    }
    var body: some View {
        GeometryReader { geometry in
            
            HStack {
                // Couldn't figure out fetchlimit with SwiftUI, leading to this monstrosity.
                if self.fetchRequest.wrappedValue.count >= 2 {
                    Group {
                        Button(action: {
                            
                            self.text = self.fetchRequest.wrappedValue[0].text ?? ""
                            
                        }) {
                            Text(self.fetchRequest.wrappedValue[0].text ?? "")
                                .foregroundColor(Color.footnoteOrange)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(width: geometry.size.width / 2 - 5, height: 50)
                        }
                        
                       Button(action: {
                            
                                self.text = self.fetchRequest.wrappedValue[1].text ?? ""
                            
                        }) {
                            Text(self.fetchRequest.wrappedValue[1].text ?? "")
                                .foregroundColor(Color.footnoteOrange)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(width: geometry.size.width / 2 - 5, height: 50)
                        }
                    }
                } else {
                    ForEach(self.fetchRequest.wrappedValue, id: \.self) { item in
                        Button(action: {
                            
                                self.text = item.text ?? ""
            
                        }) {
                            Text(item.text ?? "")
                                .foregroundColor(Color.footnoteOrange)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(width: geometry.size.width / 2 - 5, height: 50)
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

struct TitleSuggestionsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    var fetchRequest: FetchRequest<Title>
    
    @Binding var text: String
    
    init(filter: String, text: Binding<String>) {
        fetchRequest = FetchRequest<Title>(entity: Title.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Title.count, ascending: false)
            ], predicate: NSCompoundPredicate(
                type: .or,
                subpredicates: [
                    // [cd] = case and diacritic insensitive
                    NSPredicate(format: "text CONTAINS[cd] %@", filter),
                ]
        ))
        print("init")
        // Initialize a binding variable
        self._text = text
        
    }
    var body: some View {
        GeometryReader { geometry in
            
            HStack {
                // Couldn't figure out fetchlimit with SwiftUI, leading to this monstrosity.
                if self.fetchRequest.wrappedValue.count >= 2 {
                    Group {
                        Button(action: {
                            
                            self.text = self.fetchRequest.wrappedValue[0].text ?? ""
                            
                        }) {
                            Text(self.fetchRequest.wrappedValue[0].text ?? "")
                                .foregroundColor(Color.footnoteOrange)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(width: geometry.size.width / 2 - 5, height: 50)
                        }
                        
                       Button(action: {
                            
                                self.text = self.fetchRequest.wrappedValue[1].text ?? ""

                        }) {
                            Text(self.fetchRequest.wrappedValue[1].text ?? "")
                                .foregroundColor(Color.footnoteOrange)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(width: geometry.size.width / 2 - 5, height: 50)
                        }
                    }
                } else {
                    ForEach(self.fetchRequest.wrappedValue, id: \.self) { item in
                        Button(action: {
                            
                                self.text = item.text ?? ""
            
                        }) {
                            Text(item.text ?? "")
                                .foregroundColor(Color.footnoteOrange)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(width: geometry.size.width / 2 - 5, height: 50)
                        }
                    }
                }
                Spacer()
            }
        }
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
