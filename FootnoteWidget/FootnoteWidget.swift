//
//  FootnoteWidget.swift
//  FootnoteWidget
//
//  Created by Japneet Singh on /410/20.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    @AppStorage("WidgetContent", store: UserDefaults(suiteName: AppGroup.appGroup.rawValue)) var quotes = Data()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), quote: WidgetContent(date: Date(), text: "Do or do not, there is no try", title: "Star Wars Episode V", author: "Yoda"))
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        var entry: SimpleEntry
        if let decodedData = try? JSONDecoder().decode([WidgetContent].self, from: quotes) {
            entry = SimpleEntry(date: decodedData[0].date, configuration: configuration, quote: decodedData[0])
            print("Decoded")
        } else {
            entry = SimpleEntry(date: Date(), configuration: configuration, quote: WidgetContent(date: Date(), text: "Do or do not, there is no try", title: "Star Wars Episode V", author: "Yoda Snapshot"))
            print("couldnt decode")
        }
       completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        if let decodedData = try? JSONDecoder().decode([WidgetContent].self, from: quotes) {
            let entry = SimpleEntry(date: decodedData[0].date, configuration: configuration, quote: decodedData[0])
            print("Decoded")
            entries.append(entry)
        } else {
            let entry = SimpleEntry(date: Date(), configuration: configuration, quote: WidgetContent(date: Date(), text: "Do or do not, there is no try", title: "Star Wars Episode V", author: "Yoda Timeline"))
            entries.append(entry)
            print("couldnt decode")
        }
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let quote: WidgetContent
}

struct FootnoteWidgetEntryView : View {
    @Environment(\.widgetFamily) private var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        if widgetFamily == .systemSmall {
            SmallWidgetView(entry: entry)
        } else if widgetFamily == .systemMedium {
            MediumWidgetView()
        }
        else{
            LargeWidgetView()
        }
    }
}

@main
struct FootnoteWidget: Widget {
    let kind: String = "FootnoteWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            FootnoteWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Quote")
        .description("Add your favourite quotes directly to the homescreen.")
    }
}

//struct FootnoteWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        FootnoteWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//        FootnoteWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemMedium))
//        FootnoteWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemLarge))
//    }
//}

struct SmallWidgetView: View {
    
    var entry: Provider.Entry
    
    var body: some View {
        
        HStack{
            VStack(alignment: .leading){
                Text(entry.quote.author)
                    .font(.body)
                    .foregroundColor(.purple)
                    .bold()
                Spacer()
                Text(entry.quote.text)
                    .font(.title)
                    .foregroundColor(.purple)
                    .bold()
                    .minimumScaleFactor(0.5)
                    }
                    Spacer()
                }
                .padding(.all, 8)
                .background(ContainerRelativeShape().fill(Color(.cyan)))
    }
}

struct MediumWidgetView: View {
    var body: some View {
        Text("This is a medium or large widget")
    }
}

struct LargeWidgetView: View {
    var body: some View {
        Text("This is a large widget!")
    }
}
