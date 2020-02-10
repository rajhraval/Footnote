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
    
    @State var showImageCreator = false
    var quote: Quote
    
    var body: some View {
        VStack {
            TextField("Text", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.bottom, .leading, .trailing])
            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.bottom, .leading, .trailing])
            TextField("Author", text: $author)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.bottom, .leading, .trailing])
            Button(action: {
                self.updateQuote()
            }) {
                Text("Save changes")
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.footnoteRed)
                    .cornerRadius(10)
            }.padding(.bottom)
            
            Button(action: {
                self.showImageCreator = true
            }) {
                Text("Share quote")
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.footnoteRed)
                    .cornerRadius(10)
                .sheet(isPresented: self.$showImageCreator) {
                    ImageCreator(text: self.quote.text ?? "", source: self.quote.title ?? "")
                }
            }
            Spacer()
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

