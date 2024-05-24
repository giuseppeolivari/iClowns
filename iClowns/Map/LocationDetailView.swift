//
//  LocationDetailView.swift
//  iClowns
//
//  Created by Giuseppe Olivari on 23/05/24.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    @Binding var selectedTag: Int?
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
    }
}

#Preview {
    LocationDetailView(selectedTag: .constant(nil))
}
