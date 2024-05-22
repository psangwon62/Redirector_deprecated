//
//  Apps.swift
//  Redirector
//
//  Created by 박상원 on 4/13/24.
//

import Foundation
import SwiftUI

struct Apps: Identifiable, Hashable {
  let id = UUID()
  let name: String
  var image: NSImage?
  var appDescription: AppDescription
  
  init(name: String, image: NSImage? = nil, description: AppDescription = AppDescription()) {
    self.name = name
    self.image = image
    self.appDescription = AppDescription(title: name)
  }
}

struct AppDescription: Hashable {
  var title: String? = nil
  var subTitle: String? = nil
  var description: String? = nil
}
