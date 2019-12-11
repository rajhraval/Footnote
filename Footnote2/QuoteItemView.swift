//
//  QuoteItemView.swift
//  Footnote2
//
//  Created by Cameron Bardell on 2019-12-10.
//  Copyright © 2019 Cameron Bardell. All rights reserved.
//

import SwiftUI

struct QuoteItemView: View {
    var quote: Quote
    var body: some View {
        VStack(alignment: .leading) {
            Text(quote.text)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(3)
               
            Divider()
            HStack(alignment: .top) {
                Text("\(quote.title)  by \(quote.author)").font(.footnote)
                    
            }.padding(3)
            
        }.padding(5)
        .background(Color.footnoteBabyBlue)
        .cornerRadius(10)
        .padding(5)
        
    }
}

//struct QuoteItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuoteItemView()
//}
