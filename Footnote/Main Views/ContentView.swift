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
  @State var showModal = false
  @State var showView: ContentViewModals = .addQuoteView
  
  @State private var refreshing = false
  private var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
  
  
  @FetchRequest(
    entity: Quote.entity(),
    sortDescriptors: [
      NSSortDescriptor(keyPath: \Quote.dateCreated, ascending: false)
    ]
  ) var quotes: FetchedResults<Quote> {
    didSet{
        self.widgetSync()
    }
  }
  
  var body: some View {
    
    NavigationView {
      VStack {
        TextField("Search", text: self.$search)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding([.leading, .trailing, .top])
        
        
        if self.search != "" {
          FilteredList(filter: self.search).environment(\.managedObjectContext, self.managedObjectContext)
        } else {
          
          List {
            ForEach(self.quotes, id: \.self) { quote in
              // Issue #17: Pass Media type to the detail view
              NavigationLink(destination: QuoteDetailView(text: quote.text ?? "",
                                                          title: quote.title ?? "",
                                                          author: quote.author ?? "",
                                                          mediaType: MediaType(rawValue: Int(quote.mediaType)) ?? MediaType.book,
                                                          quote: quote
              ).environment(\.managedObjectContext, self.managedObjectContext)) {
                QuoteItemView(quote: quote)
              }
              .onReceive(self.didSave) { _ in
                self.refreshing.toggle()
                self.widgetSync()
                print("refresh")
              }
              
              
            }.onDelete(perform: self.removeQuote)
            
          }
          .listStyle(PlainListStyle())
          .navigationBarTitle("Footnote", displayMode: .inline)
          .navigationBarItems(leading:
                                Button(action: {
                                  self.showView = .settingsView
                                  self.showModal.toggle()
                                } ) {
                                  Image(systemName: "gear")
                                },
                              
                              trailing:
                                Button(action: {
                                  self.showView = .addQuoteView
                                  self.showModal.toggle()
                                } ) {
                                  Image(systemName: "plus")
                                }
                              )
          .onAppear(perform: {
            self.widgetSync()
          })
        }
      }
    }.sheet(isPresented: $showModal) {
      if self.showView == .addQuoteView {
        
        AddQuoteUIKit(showModal: $showModal).environment(\.managedObjectContext, self.managedObjectContext)
        
      }
      
//      if self.showView == .settingsView {
//        SettingsView()
//      }
      
    }.accentColor(Color.footnoteRed)
    
  }
  
  func removeQuote(at offsets: IndexSet) {
    for index in offsets {
      let quote = quotes[index]
      managedObjectContext.delete(quote)
    }
    do {
      try managedObjectContext.save()
        self.widgetSync()
    } catch {
      // handle the Core Data error
    }
  }
    
    func widgetSync(){
        
        
        let quotesJSON = self.quotes.map({
            WidgetContent(date: $0.dateCreated ?? Date(), text: $0.text ?? "Default Text", title: $0.title ?? "Default Title", author: $0.author ?? "Default Author")
        })
        
        print("Syncing")
        
        guard let encodedData = try? JSONEncoder().encode(quotesJSON) else {
            print("Couldnt encode")
            return }
        
        print("encoded to UDs")
        print(encodedData)
        
        print(type(of: quotesJSON))
        UserDefaults(suiteName: AppGroup.appGroup.rawValue)!.set(encodedData, forKey: "WidgetContent")
        
    }
}

/// contentView modals
enum ContentViewModals {
  case addQuoteView
  case settingsView
  
}

// To preview with CoreData
#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    return Group {
      ContentView().environment(\.managedObjectContext, context).environment(\.colorScheme, .light)
      
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
          // Issue #17: Pass Media type to the detail view
          NavigationLink(destination: QuoteDetailView(text: quote.text ?? "",
                                                      title: quote.title ?? "",
                                                      author: quote.author ?? "",
                                                      mediaType: MediaType(rawValue: Int(quote.mediaType)) ?? MediaType.book,
                                                      quote: quote)) {
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
        self.widgetSync()
    } catch {
      // handle the Core Data error
    }
  }
}
