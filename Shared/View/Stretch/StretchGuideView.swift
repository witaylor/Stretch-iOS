//
//  StretchGuideView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 01/03/2021.
//

import SwiftUI
import AVKit

struct StretchGuideView: View {
  var stretch: Stretch
  
  private var player: AVPlayer?
  
  init(stretch: Stretch) {
    self.stretch = stretch
    
    if let videoName = stretch.guide.videoName {
      player = AVPlayer(url: Bundle.main.url(forResource: videoName, withExtension: "mov")!)
    }
  }
  
  var body: some View {
    VStack {
      if let vp = player {
        VideoPlayer(player: vp)
          .aspectRatio(16 / 9, contentMode: .fit)
          .cornerRadius(10)
          .padding(.top)
      }
      
      CollapsibleView(
        label: "Stretch guide",
        content: {
          LazyVStack {
            ForEach(stretch.guide.text.indices, id: \.self) { index in
              HStack(alignment: .top) {
                Image(systemName: "\(index + 1).circle")
                  .imageScale(.large)
                Text(stretch.guide.text[index])
                  .padding(.vertical, 2)
                  .frame(maxWidth: .infinity, alignment: .leading)
              }.padding(.bottom, 1)
            }
          }.padding(.vertical, 10)
        },
        isExpanded: player == nil
      )
      .background(Color.lightGrey )
      .cornerRadius(10)
    }
  }
}
