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
                    .padding([.leading, .trailing, .bottom])
                    .disableAutocorrection(true)
                
                SuggestionsView(filter: self.author, filterType: "author").environment(\.managedObjectContext, self.managedObjectContext)
                
                Button(action: {
                    self.addQuote()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.white)
                        .padding(.bottom)
                    
                }.padding(.top)
                
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

    
    init(filter: String, filterType: String) {
        fetchRequest = FetchRequest<Quote>(entity: Quote.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Quote.dateCreated, ascending: false)
            ], predicate: NSCompoundPredicate(
                type: .or,
                subpredicates: [
                    // [cd] = case and diacritic insensitive
                    NSPredicate(format: "author CONTAINS[cd] %@", filter),
                    NSPredicate(format: "title CONTAINS[cd] %@", filter)
                ]
        ))
    }
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack {
                ForEach(fetchRequest.wrappedValue, id: \.self) { quote in
                    Circle().fill(Color.white)
                }
            }
        }
    }
    
}

struct AddQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuoteView()
    }
}
