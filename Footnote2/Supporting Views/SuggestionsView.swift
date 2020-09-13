//
//  SuggestionsView.swift
//  Footnote2
//
//  Created by Cameron Bardell on 2020-08-29.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import SwiftUI
import Alamofire

struct SuggestionsView: View {
    
    @State var bookList: [Book] = []
    @State var searchString: String
    
    var body: some View {
        VStack {
            Text(searchString)
            HStack {
                Text("See Me")
                
            }
        }.background(Color.white)
    }
    
    func updateBooks() {
        self.bookList = getBooks(searchString: searchString)
    }
    
}

struct SuggestionsView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionsView(searchString: "The Golem and the Jinni")
    }
}

func getBooks(searchString: String) -> [Book]  {
    print(searchString)
    let url = "https://openlibrary.org/search.json"
    var returnedBooks: [Book] = []
    let parameters: [String: String] = ["q": searchString, "page": "1"]
    let request = AF.request(url, parameters: parameters)
    
    request.validate()
        .responseDecodable(of: Books.self) { response in
            guard let books = response.value else { return }
            print(books.allBooks)
            returnedBooks = books.allBooks
    }
    
    return returnedBooks
}

struct Book: Decodable {
    
    let title: String
    let author_names: [String]
    
    enum CodingKeys: String, CodingKey {
        case title
        case author_names = "author_name"
    }
}

struct Books: Decodable {
    let numFound: Int
    let allBooks: [Book]
    
    enum CodingKeys: String, CodingKey {
        case numFound
        case allBooks = "docs"
    }
}

