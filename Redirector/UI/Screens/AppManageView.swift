//
//  AppManageView.swift
//  Redirector
//
//  Created by 박상원 on 4/11/24.
//

import SwiftUI

struct AppManageView: View {
  @StateObject var viewModel: AppSettingViewModel = .init()

  var body: some View {
    HStack(spacing: Sizes.Paddings.half) {
      AppList(viewModel: viewModel)
      DescriptionEditForm(viewModel: viewModel)
    }
    .padding()
  }
}


#Preview {
  AppManageView()
}
