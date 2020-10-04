//
//  WidgetCount.swift
//  Footnote
//
//  Created by Japneet Singh on /410/20.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import Foundation
import WidgetKit

struct WidgetContent: TimelineEntry, Codable{

        var date = Date()
        var text: String = "Default Text"
        var title: String = "Default Title"
        var author: String = "Default Author"
}
