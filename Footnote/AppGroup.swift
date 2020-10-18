//
//  AppGroup.swift
//  Footnote
//
//  Created by Japneet Singh on /410/20.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import Foundation

public enum AppGroup: String {
  case appGroup = "group.com.bardell.footnote"

  public var containerURL: URL {
    switch self {
    case .appGroup:
      return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: self.rawValue)!
    }
  }
}

