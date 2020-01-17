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
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                Button(action: {
                    self.addQuote()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.white)
                     
                    
                }
                TextField("Text", text: self.$text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Title", text: self.$title)
                    .textContentType(.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.leading, .trailing, .bottom])
                    .disableAutocorrection(true)
                
                TextField("Author", text: self.$author)
                    .textContentType(.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.leading, .trailing])
                    .disableAutocorrection(true)
                
                SuggestionsView(filter: self.author, filterType: "author", author: self.$author, title: self.$title).environment(\.managedObjectContext, self.managedObjectContext)
                    .frame(width: geometry.size.width - 30, height: 50)
                SuggestionsView(filter: self.title, filterType: "title", author: self.$author, title: self.$title).environment(\.managedObjectContext, self.managedObjectContext)
                .frame(width: geometry.size.width - 30, height: 50)
                
                
                
                Text("Add Quote").font(.title).foregroundColor(Color.white)
                Text("Swipe to dismiss").font(.footnote).foregroundColor(Color.white)
                Spacer()
                
            }.frame(width: geometry.size.width - 20, height: geometry.size.height)
                .background(Color.footnoteRed)
                .cornerRadius(10)
        }
    }
    
    func addQuote() {
        // Add a new quote
        let quote = Quote(context: self.managedObjectContext)
        quote.title = self.title
        quote.text = self.text
        quote.author = self.author
        quote.dateCreated = Date()
        
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

struct SuggestionsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    var fetchRequest: FetchRequest<Quote>
    var filterType: String
    
    @Binding var author: String
    @Binding var title: String
    
    init(filter: String, filterType: String, author: Binding<String>, title: Binding<String>) {
        fetchRequest = FetchRequest<Quote>(entity: Quote.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Quote.dateCreated, ascending: false)
            ], predicate: NSCompoundPredicate(
                type: .or,
                subpredicates: [
                    // [cd] = case and diacritic insensitive
                    NSPredicate(format: "\(filterType) CONTAINS[cd] %@", filter),
                    
                ]
        ))
        
        // Initialize a binding variable
        self._author = author
        self._title = title
        self.filterType = filterType
        
        
    }
    var body: some View {
        GeometryReader { geometry in
            
            HStack {
                
                // Couldn't figure out fetchlimit with SwiftUI, leading to this monstrosity.
                if self.fetchRequest.wrappedValue.count >= 2 {
                    Group {
                        Button(action: {
                            if self.filterType == "author" {
                                self.author = self.fetchRequest.wrappedValue[0].author ?? ""
                            } else if self.filterType == "title" {
                                self.title = self.fetchRequest.wrappedValue[0].title ?? ""
                            }
                        }) {
                            Text(self.filterType == "author" ? self.fetchRequest.wrappedValue[0].author ?? "" : self.fetchRequest.wrappedValue[0].title ?? "")
                                .foregroundColor(Color.footnoteOrange)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(width: geometry.size.width / 2 - 5, height: 50)
                                
                        }
                        
                       Button(action: {
                            if self.filterType == "author" {
                                self.author = self.fetchRequest.wrappedValue[1].author ?? ""
                            } else if self.filterType == "title" {
                                self.title = self.fetchRequest.wrappedValue[1].title ?? ""
                            }
                        }) {
                            Text(self.filterType == "author" ? self.fetchRequest.wrappedValue[1].author ?? "" : self.fetchRequest.wrappedValue[1].title ?? "")
                                .foregroundColor(Color.footnoteOrange)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(width: geometry.size.width / 2 - 5, height: 50)
                        }
                    }
                } else {
                    ForEach(self.fetchRequest.wrappedValue, id: \.self) { quote in
                        Button(action: {
                            if self.filterType == "author" {
                                self.author = quote.author ?? ""
                            } else if self.filterType == "title" {
                                self.title = quote.title ?? ""
                            }
                        }) {
                            Text(self.filterType == "author" ? quote.author ?? "" : quote.title ?? "")
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

struct AddQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuoteView()
    }
}
