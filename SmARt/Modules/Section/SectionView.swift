//
//  Covering5GView.swift
//  SmARt
//
//  Created by MacBook on 2/11/21.
//

import SwiftUI

struct SectionView: View {
    @ObservedObject var viewModel: SectionViewModel
    
    init(sectionInfo: Section?) {
        viewModel = SectionViewModel(sectionInfo: sectionInfo)
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView(sectionInfo: nil)
    }
}
