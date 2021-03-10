//
//  ImageFromFile.swift
//  SmARt
//
//  Created by MacBook on 10.03.21.
//

import SwiftUI

struct ImageFromFile: View {
    @State var name: String
    @State var directory: FileManager.SearchPathDirectory = .documentDirectory
    
    var body: some View {
        Image(uiImage: UIImage.read(from: directory, name: name))
            .resizable()
    }
}
