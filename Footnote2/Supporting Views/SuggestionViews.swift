//
//  SuggestionViews.swift
//  Footnote2
//
//  Created by Cameron Bardell on 2020-03-06.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SwiftUI

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
                                .foregroundColor(Color.white)
                            .padding(5)
                            .background(Color.footnoteRed)
                            .cornerRadius(10)
                            .frame(width: geometry.size.width / 2 - 5, height: 50)
                        }
                        
                       Button(action: {
                            
                                self.text = self.fetchRequest.wrappedValue[1].text ?? ""
                            
                        }) {
                            Text(self.fetchRequest.wrappedValue[1].text ?? "")
                                .foregroundColor(Color.white)
                            .padding(5)
                            .background(Color.footnoteRed)
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
                                .foregroundColor(Color.white)
                            .padding(5)
                            .background(Color.footnoteRed)
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
                                .foregroundColor(Color.white)
                            .padding(5)
                            .background(Color.footnoteRed)
                            .cornerRadius(10)
                            .frame(width: geometry.size.width / 2 - 5, height: 50)
                        }
                        
                       Button(action: {
                            
                                self.text = self.fetchRequest.wrappedValue[1].text ?? ""

                        }) {
                            Text(self.fetchRequest.wrappedValue[1].text ?? "")
                                .foregroundColor(Color.white)
                            .padding(5)
                            .background(Color.footnoteRed)
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
                                .foregroundColor(Color.white)
                            .padding(5)
                            .background(Color.footnoteRed)
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
