//
//  ContentView.swift
//  SmARt
//
//  Created by MacBook on 2/3/21.
//

import SwiftUI
import Combine

struct MenuView: View {
    @ObservedObject var viewModel = MenuViewModel()

    var body: some View {
        MenuARView(
            sectionsList3DItemData:
                $viewModel.sectionsList3DItemData,
            sectionItemSelected: viewModel.sectionItemSelected)
            .edgesIgnoringSafeArea(.all)
    }
}

struct SectionsView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
