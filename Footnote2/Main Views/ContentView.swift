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
    @State var search = ""
    @State var showAddQuote = false
    
    @FetchRequest(
        entity: Quote.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Quote.dateCreated, ascending: false)
        ]
    ) var quotes: FetchedResults<Quote>
    
    var body: some View {
        GeometryReader { geometry in
            
            NavigationView {
                ZStack {
                    
                    
                    VStack {
                        TextField("Search", text: self.$search)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding([.leading, .trailing, .top])
                        
                        
                        // TODO: Quote detail view, edit quote.
                        if self.search != "" {
                            FilteredList(filter: self.search).environment(\.managedObjectContext, self.managedObjectContext)
                        } else {
                            
                            List {
                                ForEach(self.quotes, id: \.self) { quote in
                                    
                                    NavigationLink(destination: QuoteDetailView(text: quote.text ?? "", title: quote.title ?? "", author: quote.author ?? "", quote: quote)) {
                                        QuoteItemView(quote: quote)
                                    }
                                    
                                    
                                }.onDelete(perform: self.removeQuote)
                                
                            }.navigationBarTitle("")
                                .navigationBarHidden(true)
                        }
                    }
                    
                    
                    
                    // Embedded stacks to put button in bottom corner
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Button(action: {
                                self.showAddQuote.toggle()
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    // Needs a background to colour the plus, corner radius to remove box
                                    .cornerRadius(25)
                                    .foregroundColor(Color.footnoteRed)
                                    .padding()
                                
                                
                            }
                            
                            
                        }
                    }
                    
                    // TODO: Keyboard Guardian
                    
                    //                AddQuoteView().environment(\.managedObjectContext, self.managedObjectContext).offset(x: 0, y: geometry.size.height + 100)
                    //                    .animation(.spring())
                    //                    .offset(x: 0, y: self.offset.height)
                    //                    .gesture(DragGesture()
                    //                        .onEnded {_ in
                    //                            print("drag")
                    //                            self.offset = .init(width: 0, height: 0)
                    //                            // Dismiss keyboard
                    //                            UIApplication.shared.endEditing()
                    //                    })
                    
                }
            }.accentColor(Color.footnoteRed)
            
            
        }.sheet(isPresented: $showAddQuote) {
            AddQuoteUIKit().environment(\.managedObjectContext, self.managedObjectContext)
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
        return Group {
            ContentView().environment(\.managedObjectContext, context).environment(\.colorScheme, .light)
            ContentView().environment(\.managedObjectContext, context).environment(\.colorScheme, .dark)
        }
        
    }
}
#endif

struct FilteredList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var showImageCreator = false
    var fetchRequest: FetchRequest<Quote>
    
    init(filter: String) {
        fetchRequest = FetchRequest<Quote>(entity: Quote.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Quote.dateCreated, ascending: false)
            ], predicate: NSCompoundPredicate(
                type: .or,
                subpredicates: [
                    // [cd] = case and diacritic insensitive
                    NSPredicate(format: "text CONTAINS[cd] %@", filter),
                    NSPredicate(format: "author CONTAINS[cd] %@", filter),
                    NSPredicate(format: "title CONTAINS[cd] %@", filter)
                ]
        ))
    }
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(fetchRequest.wrappedValue, id: \.self) { quote in
                    NavigationLink(destination: QuoteDetailView(text: quote.text ?? "", title: quote.title ?? "", author: quote.author ?? "", quote: quote)) {
                        QuoteItemView(quote: quote)
                    }
                }.onDelete(perform: self.removeQuote)
            }
        }.navigationBarTitle("")
            .navigationBarHidden(true)
    }
    
    func removeQuote(at offsets: IndexSet) {
        for index in offsets {
            let quote = fetchRequest.wrappedValue[index]
            managedObjectContext.delete(quote)
        }
        do {
            try managedObjectContext.save()
        } catch {
            // handle the Core Data error
        }
    }
}
