//
//  StringUtilities.swift
//  Lost In Flight Studios, LLC
//
//  Created by Austin Feight on 3/2/16.
//  Copyright © 2016 Lost In Flight Studios, LLC. All rights reserved.
//

import UIKit

// MARK: - Regex Matching

struct Regex {
  let pattern: String
  let options: NSRegularExpressionOptions
  
  private var matcher: NSRegularExpression {
    return try! NSRegularExpression(pattern: pattern, options: options)
  }
  
  init(pattern: String, options: NSRegularExpressionOptions! = nil)
  {
    self.pattern = pattern
    self.options = options ?? []
  }
  
  func match(string: String, options: NSMatchingOptions = []) -> Bool
  {
    let entireRange = NSMakeRange(0, string.characters.count)
    let matches = matcher.numberOfMatchesInString(string, options: options, range: entireRange)
    return matches > 0
  }
}

protocol RegularExpressionMatchable {
  func match(regex: Regex) -> Bool
}

extension String: RegularExpressionMatchable {
  func match(regex: Regex) -> Bool {
    return regex.match(self)
  }
}

func ~=<T: RegularExpressionMatchable>(pattern: Regex, matchable: T) -> Bool {
  return matchable.match(pattern)
}