//
// Created by Will Taylor on 21/01/2021.
//

// adapted:
// https://medium.com/better-programming/how-to-write-a-collapsible-expandable-view-for-your-swiftui-app-d4a47fe8cb52

import SwiftUI

struct CollapsibleView<Content: View>: View {
  @State var label: String
  @State var content: () -> Content
  
  @State var isExpanded: Bool = false
  
  var body: some View {
    DisclosureGroup(isExpanded: $isExpanded) {
      content()
    } label: {
      Text(label)
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .leading)
    }.padding()
  }
}
