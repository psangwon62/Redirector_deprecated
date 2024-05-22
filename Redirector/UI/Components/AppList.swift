//
//  AppList.swift
//  Redirector
//
//  Created by 박상원 on 4/12/24.
//

import SwiftUI

struct AppList: View {
  @ObservedObject var viewModel: AppSettingViewModel

  var body: some View {
    VStack {
      List(selection: $viewModel.selectedIndex) {
        Section(header: Text(AppStrings.apps)) {
          ForEach(0 ..< viewModel.listCount, id: \.self) { index in
            appLabel(index)
          }
          .onMove { indices, newOffset in
            viewModel.onMoveUsers(fromOffsets: indices, toOffset: newOffset)
          }
        }
        .border(.black)
      }
      .border(SeparatorShapeStyle())
    }
    .overlay(alignment: .bottom) {
      updateAppButton
    }
    .frame(width: Sizes.SettingComponents.appListWidth)
  }

  @ViewBuilder
  func appLabel(_ index: Int) -> some View {
    Label {
      Text(viewModel.appName(index))
        .padding(.leading, Sizes.Paddings.half)
        .lineLimit(1)
    } icon: {
      AppIcon(image: viewModel.appImage(index))
    }
    .padding(.leading, Sizes.Paddings.half)
    .listRowSeparator(.hidden)
    .listRowInsets(.none)
    .onTapGesture { viewModel.updateSelectedIndex(index) }
  }
  
  var addAppButton: some View {
    Button(action: viewModel.addApp) {
      Image(systemName: SFSymbols.plus)
    }
    .disabled(viewModel.addButtonDisabled)
  }

  var removeAppButton: some View {
    Button(action: viewModel.removeApp) {
      Image(systemName: SFSymbols.minus)
    }
    .disabled(viewModel.removeButtonDisabled)
  }

  var updateAppButton: some View {
    HStack {
      addAppButton
      removeAppButton
      Spacer()
    }
    .padding(Sizes.Paddings.quarter)
    .buttonStyle(BorderlessButtonStyle())
  }
}
