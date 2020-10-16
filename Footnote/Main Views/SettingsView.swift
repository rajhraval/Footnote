//
//  SettingsView.swift
//  Footnote
//
//  Created by Cameron Bardell on 2020-10-03.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import SwiftUI
import UIKit

struct SettingsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var showModal: Bool

    var body: some View {
      HStack(alignment: .center) {
        Image(systemName: "gear").renderingMode(.original).resizable().cornerRadius(20).frame(width: 60, height: 60).clipped().aspectRatio(contentMode: .fit)

        VStack(alignment: .leading, spacing: nil/*@END_MENU_TOKEN@*/, content: {
            Text("Footnote - IOS SwiftUI Open-Source Application developed during Hacktoberfest 2020.")
                .font(.system(size: 18))
                .lineLimit(nil)
        })
      }.padding()
    }
}

// To preview with CoreData
#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return Group {
            SettingsView(showModal: .constant(true)).environment(\.managedObjectContext, context).environment(\.colorScheme, .light)
        }

    }
}
#endif
