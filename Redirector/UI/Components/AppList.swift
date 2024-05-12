//
//  AppList.swift
//  Redirector
//
//  Created by 박상원 on 4/12/24.
//

import SwiftUI

struct AppList: View {
  @State var list = [Apps(name: "App Store", image: NSImage(resource: .appStore))]
  @State var isEditing: Bool = false
  @State var triggerAlert: Bool = false

  var body: some View {
    VStack {
      List {
        ForEach(0 ..< list.count, id: \.self) { index in
          HStack {
            if let appImage = list[index].image {
              Image(nsImage: appImage)
                .resizable()
                .frame(width: 32, height: 32)
                .aspectRatio(contentMode: .fit)
            }
            Text(list[index].name)
              .padding()
            Spacer()
            if isEditing {
              Button {
                if list.count > 1 {
                  list.remove(at: index)
                } else {
                  triggerAlert = true
                }
              } label: {
                Image(systemName: "trash")
              }
              Image(systemName: "line.3.horizontal")
            }
          }
        }
        .onMove { indices, newOffset in
          if isEditing {
            onMoveUsers(fromOffsets: indices, toOffset: newOffset)
          }
        }
      }
      .border(SeparatorShapeStyle())
      HStack {
        Button(action: addApp) {
          Image(systemName: "plus")
        }
        .disabled(list.count >= 4)
        Button(action: removeApp) {
          Image(systemName: "minus")
        }
        .disabled(list.count <= 1)
        Spacer()
      }
      .buttonStyle(BorderlessButtonStyle())
    }
    .padding()
    .alert(Text("There should be at least one App."), isPresented: $triggerAlert) {}
  }

  func addApp() {
    guard let panel = openPanel(type: [.application]) else { return }
    if panel.runModal() == .OK {
      guard let url = panel.urls.first else { return }
      if let appName = url.pathComponents.last {
        let name = appName.components(separatedBy: ".")[0]
        if list.contains(where: { $0.name == name }) {
        } else {
          list.append(Apps(name: name, image: getIcon(application: appName) ?? NSImage(resource: .figma)))
        }
      }
    }
  }
  
  func removeApp() {
    isEditing.toggle()
  }
  func onMoveUsers(fromOffsets source: IndexSet, toOffset destination: Int) {
    list.move(fromOffsets: source, toOffset: destination)
  }

  // MARK: - App Icons

  func getIcon(file path: String) -> NSImage? {
    guard FileManager.default.fileExists(atPath: path)
    else { return nil }

    return NSWorkspace.shared.icon(forFile: path)
  }

  func getIcon(bundleID: String) -> NSImage? {
    guard let path = NSWorkspace.shared.absolutePathForApplication(withBundleIdentifier: bundleID)
    else { return nil }

    return getIcon(file: path)
  }

  func getIcon(application: String) -> NSImage? {
    guard let path = NSWorkspace.shared.fullPath(forApplication: application)
    else { return nil }

    return getIcon(file: path)
  }

  // MARK: - Bundles

  /// Easily read Info.plist as a Dictionary from any bundle by accessing .infoDictionary on Bundle
  func bundle(forBundleID: String) -> Bundle? {
    guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: forBundleID)
    else { return nil }

    return Bundle(url: url)
  }
}

#Preview {
    AppList()
}
