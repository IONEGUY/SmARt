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
        NavigationView {
            ZStack {
                NavigationLink(
                    destination: SectionView(sectionInfo: viewModel.section),
                    isActive: $viewModel.pushActive,
                    label: { Text(String.empty) })
                MenuARView(
                    menuItems: $viewModel.menuItems,
                    onMenuItemSelected: $viewModel.onMenuItemSelected)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct SectionsView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
