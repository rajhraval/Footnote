//
//  SettingsView.swift
//  Footnote
//
//  Created by Cameron Bardell on 2020-10-03.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
      VStack(alignment: .leading) {
        Text("An eventual home for settings, about, and contributors list. Likely contributors list at the bottom, beneath settings.")
        Text("Possible settings include: text size, color theme, quote export.")
      }.padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
