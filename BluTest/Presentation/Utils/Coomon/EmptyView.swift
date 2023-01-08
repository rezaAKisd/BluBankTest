//
//  EmptyView.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import SwiftUI

struct EmptyView: View {
    var emptyTitle: String

    init(emptyTitle: String) {
        self.emptyTitle = emptyTitle
    }

    var body: some View {
        VStack {
            Image("country")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()
            Text(emptyTitle)
        }
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView(emptyTitle: "Empty List")
    }
}
