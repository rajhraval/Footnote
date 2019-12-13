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
    @State var title: String = ""
    @State var author: String = ""
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                
                TextField("Text", text: self.$text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Title", text: self.$title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.leading, .trailing, .bottom])
                TextField("Author", text: self.$author)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.leading, .trailing, .bottom])
                Button(action: {
                    self.addQuote()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.footnoteBabyBlue)
                        .padding(.bottom)
                    
                }.padding(.top)
                
                Text("Add Quote").font(.title).foregroundColor(Color.footnoteCream)
                Text("Swipe to dismiss").font(.footnote).foregroundColor(Color.footnoteCream)
                Spacer()
                
            }.frame(width: geometry.size.width - 20, height: geometry.size.height)
                .background(Color.footnoteDark)
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


struct AddQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuoteView()
    }
}
