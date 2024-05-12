//
//  AppManageView.swift
//  Redirector
//
//  Created by 박상원 on 4/11/24.
//

import SwiftUI

struct AppManageView: View {
  @ObservedObject var viewModel: AppSettingViewModel = .init()
  @State var icloudenabled = true

  var body: some View {
    HStack(spacing: Paddings.half) {
      VStack {
        List(selection: $viewModel.selectedIndex) {
          Section(header: Text(AppStrings.apps)) {
            ForEach(0 ..< viewModel.list.count, id: \.self) { index in
              HStack {
                AppIcon(image: viewModel.list[index].image)
                Text(viewModel.list[index].name)
                  .lineLimit(1)
                Spacer()
              }
              .listRowSeparator(.hidden)
              .listRowInsets(.none)
              .onTapGesture {
                viewModel.selectedIndex = index
              }
            }
            .onMove { indices, newOffset in
              viewModel.onMoveUsers(fromOffsets: indices, toOffset: newOffset)
            }
          }
        }
        .border(SeparatorShapeStyle())
      }
      .overlay(alignment: .bottom) {
        HStack {
          addAppButton
          removeAppButton
          Spacer()
        }
        .padding(Paddings.quarter)
        .buttonStyle(BorderlessButtonStyle())
      }
      .frame(width: SettingComponentSizes.appListWidth)

      List {
        Form {
          TextField(AppStrings.title, text: $viewModel.appTitle)
          TextField(AppStrings.description, text: $viewModel.appDescription, axis: .vertical)
            .lineLimit(5, reservesSpace: true)
          Spacer()
        }
      }
    }
    .padding()
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
}

#Preview {
  AppManageView()
}
