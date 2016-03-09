//
//  ImageLoader.swift
//  Lost In Flight Studios, LLC
//
//  Created by Austin Feight on 3/2/16.
//  Copyright © 2016 Lost In Flight Studios, LLC. All rights reserved.
//

import UIKit

class ImageLoader {
  let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
}

// MARK: - Interface
extension ImageLoader {
  func loadImageFromWeb(urlString: String, imageView: UIImageView)
  {
    guard let url = NSURL(string: urlString)
      else { return }
    
    NSURLSession.sharedSession().dataTaskWithURL(url) { data, response, error in
      guard let data = data,
                image = UIImage(data: data)
        else { return }
      
      dispatch_async(dispatch_get_main_queue()) { imageView.image = image }
    }.resume()
  }
  
  func loadImageFromDisk(url: String, imageView: UIImageView)
  {
    dispatch_async(queue) {
      guard let image = UIImage(contentsOfFile: url)
        else { return }
      dispatch_async(dispatch_get_main_queue()) { imageView.image = image }
    }
  }
}

// MARK: - UIImageView Extension
extension UIImageView {
  func loadImageFromUrl(url: String, placeholder: UIImage? = nil)
  {
    if let placeholder = placeholder {
      image = placeholder
    }
    
    let imageLoader = ImageLoader()
    switch url {
    case Regex(pattern: "^http(s)?://"):
      imageLoader.loadImageFromWeb(url, imageView: self)
    case Regex(pattern: "^/"):
      fallthrough
    case Regex(pattern: "^~/"):
      imageLoader.loadImageFromDisk(url, imageView: self)
    default:
      break
    }
  }
}