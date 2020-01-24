//
//  QuoteDetailView.swift
//  Footnote2
//
//  Created by Cameron Bardell on 2020-01-23.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import SwiftUI
import CoreData

struct QuoteDetailView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var text: String
    @State var title: String
    @State var author: String
    var quote: Quote
    
    
    
    var body: some View {
        VStack {
            TextField("Text", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Author", text: $author)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                self.updateQuote()
            }) {
                Text("Save Changes")
            }
        }
    }
    
    func updateQuote() {
        print("update")
        
        quote.text = self.text
        quote.title = self.title
        quote.author = self.author
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
        self.managedObjectContext.refreshAllObjects()
        
    }
}

