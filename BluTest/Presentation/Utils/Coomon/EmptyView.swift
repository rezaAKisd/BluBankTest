//
//  EmptyView.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import SwiftUI

struct EmptyView: View {
    var emptyTitle: String {
        return NSLocalizedString("Any Selected Country", comment: "")
    }

    var body: some View {
        VStack {
            Image("countrie")
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
        EmptyView()
    }
}
