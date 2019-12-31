//
//  ContentView.swift
//  Footnote2
//
//  Created by Cameron Bardell on 2019-12-10.
//  Copyright © 2019 Cameron Bardell. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    //Controls translation of AddQuoteView
    @State private var offset: CGSize = .zero
    
    @FetchRequest(
        entity: Quote.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Quote.dateCreated, ascending: false)
        ]
    ) var quotes: FetchedResults<Quote>
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    HStack {
                    Text("Quotes")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding([.leading, .top])
                        Spacer()
                    }
                    Divider()
                    
                    // TODO: Quote detail view, edit quote.
                    List {
                        ForEach(self.quotes, id: \.self) { quote in
                            QuoteItemView(quote: quote)
                        }.onDelete(perform: self.removeQuote)
                        
                    }
                }
                
                // Embedded stacks to put button in bottom corner
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Button(action: {
                            self.offset = .init(width: 0, height: -550)
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                
                                .background(Color.footnoteOrange)
                                // Needs a background to colour the plus, corner radius to remove box
                                .cornerRadius(25)
                                .foregroundColor(Color.footnoteRed)
                                .padding()
                            
                        }
                    }
                }
            
                // TODO: Keyboard Guardian
          
                AddQuoteView().environment(\.managedObjectContext, self.managedObjectContext).offset(x: 0, y: geometry.size.height)
                .animation(.spring())
                .gesture(DragGesture()
                    .onEnded {_ in
                        self.offset = .init(width: 0, height: 0)
                        // Dismiss keyboard
                        UIApplication.shared.endEditing()
                })
                .offset(x: 0, y: self.offset.height)
                
            }
            
        }
    }
    
   func removeQuote(at offsets: IndexSet) {
        for index in offsets {
            let quote = quotes[index]
            managedObjectContext.delete(quote)
        }
        do {
            try managedObjectContext.save()
        } catch {
            // handle the Core Data error
        }
    }
}

// To preview with CoreData
#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
#endif
