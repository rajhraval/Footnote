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
    
    // Onboarding via Sheet
    @State private var showOnboarding = false
    
    @State private var refreshing = false
    private var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)

    
    @FetchRequest(
        entity: Quote.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Quote.dateCreated, ascending: false)
        ]
    ) var quotes: FetchedResults<Quote>
    
    var body: some View {
            NavigationView {
                    VStack {
                        TextField("Search", text: self.$search)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding([.leading, .trailing, .top])
                        Spacer()
                        
                        if self.search != "" {
                            FilteredList(filter: self.search).environment(\.managedObjectContext, self.managedObjectContext)
                        } else {
                            if quotes.isEmpty {
                                VStack(alignment: .center, spacing: 14) {
                                    Image("QuotePlaceholder")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 85, height: 85)
                                    VStack(alignment: .center, spacing: 6) {
                                        Text("No Quotes Added")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Text("Click"+" + Add Quote")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                }
                                Spacer()
                            } else {
                                List {
                                    ForEach(self.quotes, id: \.self) { quote in
                                        
                                        NavigationLink(destination: QuoteDetailView(text: quote.text ?? "", title: quote.title ?? "", author: quote.author ?? "", quote: quote).environment(\.managedObjectContext, self.managedObjectContext)) {
                                            QuoteItemView(quote: quote)
                                        }
                                        .onReceive(self.didSave) { _ in
                                            self.refreshing.toggle()
                                            print("refresh")
                                        }
                                    }.onDelete(perform: self.removeQuote)
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .navigationBarTitle("Footnote", displayMode: .inline)
                    .navigationBarItems(trailing:
                        Button(action: {
                            self.showView = .addQuoteView
                            self.showModal.toggle()
                        }) {
                        Image(systemName: "plus")
                        }
                        .sheet(isPresented: $showModal) {
                            AddQuoteUIKit().environment(\.managedObjectContext, self.managedObjectContext)
                        }
                    )
        }.accentColor(Color.footnoteRed)
//        .sheet(isPresented: $showModal) {
//            if self.showView == .addQuoteView {
//
//
//
//            } else {
//                // modals...
//            }
//
//        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingView()
        }
        .onAppear(perform: checkForFirstTimeDownload)
    }
    
    // MARK: One-time onboarding on first time downloading
    
    /// Checks if the app is a first time download.
    func checkForFirstTimeDownload() {
        let launchKey = "didLaunchBefore"
        if !UserDefaults.standard.bool(forKey: launchKey) {
            UserDefaults.standard.set(true, forKey: launchKey)
            showOnboarding.toggle()
        } else {
            // For Debug Purposes Only
            print("App has launched more than one time")
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

/// contentView modals
enum ContentViewModals {
    case addQuoteView
    case contributorView
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
