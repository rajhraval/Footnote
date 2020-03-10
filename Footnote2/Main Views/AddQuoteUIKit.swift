//
//  AddQuoteUIKit.swift
//  Footnote2
//
//  Created by Cameron Bardell on 2020-03-06.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import SwiftUI
import UIKit

struct AddQuoteUIKit: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var text: String = ""
    @State var author: String = ""
    @State var title: String = ""
    
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 4) {
                TextView(text: self.$text, placeholder: "Add a quote...")
                    .frame(width: geometry.size.width - 20, height: geometry.size.height / 6)
                    
                
                TitleSuggestionsView(filter: self.title, text: self.$title).environment(\.managedObjectContext, self.managedObjectContext)
                    .frame(width: geometry.size.width - 30, height: 50)
                
                TextView(text: self.$title, placeholder: "Title...")
                    .frame(width: geometry.size.width - 20, height: 30)
                    
                
                
                AuthorSuggestionsView(filter: self.author, text: self.$author).environment(\.managedObjectContext, self.managedObjectContext)
                    .frame(width: geometry.size.width - 30, height: 50)
                
                TextView(text: self.$author, placeholder: "Author...")
                    .frame(width: geometry.size.width - 20, height: 30)
                    
                
                Button(action: {
                    self.addQuote()
                }) {
                    VStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.white)
                            
                        Text("Save")
                            .foregroundColor(Color.white)
                            
                    }.padding(.top)
                }
                
                
                Spacer()
            }.padding(.top)
        }
    }
    
    func addQuote() {
        // Add a new quote
        let quote = Quote(context: self.managedObjectContext)
        quote.title = self.title
        quote.text = self.text
        quote.author = self.author
        quote.dateCreated = Date()
        
//        let authorItem = Author(context: self.managedObjectContext)
//        authorItem.text = self.author
//        authorItem.count += 1
//
//        let titleItem = Title(context: self.managedObjectContext)
//        titleItem.text = self.title
//        titleItem.count += 1
        
        if inputImage != nil {
            quote.coverImage = inputImage!.pngData() as Data?
        }
        
        do {
            try self.managedObjectContext.save()
        } catch {
            // handle the Core Data error
            print("Failed to save new item. Error = \(error)")
            managedObjectContext.delete(quote)  
        }
        
        title = ""
        text = ""
        author = ""
    }
}

// To preview with CoreData
#if DEBUG
struct AddQuoteUIKit_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return Group {
            AddQuoteUIKit().environment(\.managedObjectContext, context).environment(\.colorScheme, .light)
        }
        
    }
}
#endif


struct TextView: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, placeholder: placeholder)
    }
    
    func makeUIView(context: Context) -> UITextView {
        
        let myTextView = UITextView()
        myTextView.delegate = context.coordinator
        
        myTextView.font = UIFont(name: "HelveticaNeue", size: 15)
        myTextView.isScrollEnabled = true
        myTextView.isEditable = true
        myTextView.isUserInteractionEnabled = true
        myTextView.text = placeholder
        
        
        return myTextView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != "" {
            uiView.text = text
        } else {
            uiView.text = placeholder
            uiView.textColor = UIColor.lightGray
        }
        
    }
    
    
    
    class Coordinator : NSObject, UITextViewDelegate {
        
        var parent: TextView
        var placeholder: String
        
        init(_ uiTextView: TextView, placeholder: String) {
            self.parent = uiTextView
            self.placeholder = placeholder
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.lightGray {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.textColor = UIColor.lightGray
            }
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
    }
}


