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
    
    @State var bookList = [Book]()
    
    init(searchString: String) {
        getBooks(searchString: searchString)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("See Me")
                VStack {
                    ForEach(self.bookList, id: \.self) { book in
                        Text(book.title)
                    }
                }
                
                
            }
        }.background(Color.white)
    }
    
    func getBooks(searchString: String) {
        print(searchString)
        let queryItems = [URLQueryItem(name: "q", value: searchString), URLQueryItem(name: "page", value: "1")]
        var urlComps = URLComponents(string: "https://openlibrary.org/search.json")!
        urlComps.queryItems = queryItems
        let result = urlComps.url!
        let request = URLRequest(url: result)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Books.self, from: data) {
                    DispatchQueue.main.async {
                        print(decodedResponse.allBooks)
                        self.bookList = decodedResponse.allBooks
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
        
    }
    
    func updateBooks(books: [Book]) {
        self.bookList = books
    }
}

struct SuggestionsView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionsView(searchString: "The Golem and the Jinni")
    }
}



struct Book: Decodable, Hashable {
    
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

