//
//  QuoteCodableExtension.swift
//  Footnote
//
//  Created by Japneet Singh on /410/20.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import Foundation
import CoreData

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

class Quote: NSManagedObject, Codable {
    
    enum CodingKeys: CodingKey{
        case author, coverImage, dateCreated, mediaType, text, title
    }
    
    required convenience init(from decoder: Decoder) throws {
      guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
        throw DecoderConfigurationError.missingManagedObjectContext
      }

      self.init(context: context)

      let container = try decoder.container(keyedBy: CodingKeys.self)
        self.author = try container.decode(String.self, forKey: .author)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.mediaType = try container.decode(Int16.self, forKey: .mediaType)
        self.text = try container.decode(String.self, forKey: .text)
        self.title = try container.decode(String.self, forKey: .title)
        self.coverImage = try container.decode(Data.self, forKey: .coverImage)
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.author, forKey: .author)
        try container.encode(self.coverImage, forKey: .coverImage)
        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.mediaType, forKey: .mediaType)
        try container.encode(self.text, forKey: .text)
        try container.encode(self.title, forKey: .title)
    }
}

class Author: NSManagedObject, Codable {
    
    enum CodingKeys: CodingKey{
        case count, text
    }
    
    required convenience init(from decoder: Decoder) throws {
      guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
        throw DecoderConfigurationError.missingManagedObjectContext
      }

      self.init(context: context)

      let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try container.decode(Int16.self, forKey: .count)
        self.text = try container.decode(String.self, forKey: .text)
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.count, forKey: .count)
        try container.encode(self.text, forKey: .text)
    }
}

class Title: NSManagedObject, Codable {
    
    enum CodingKeys: CodingKey{
        case count, text
    }
    
    required convenience init(from decoder: Decoder) throws {
      guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
        throw DecoderConfigurationError.missingManagedObjectContext
      }

      self.init(context: context)

      let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try container.decode(Int16.self, forKey: .count)
        self.text = try container.decode(String.self, forKey: .text)
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.count, forKey: .count)
        try container.encode(self.text, forKey: .text)
    }
}

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
