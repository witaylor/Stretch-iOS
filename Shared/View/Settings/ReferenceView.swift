//
//  ReferenceView.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 07/03/2021.
//

import SwiftUI

struct ReferenceView: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {        
        VStack(alignment: .leading, spacing: 20) {
          Text("Icons")
            .font(.system(.title, design: .rounded))
          
          Link(destination: URL(string: "https://thenounproject.com/duyhung7689/collection/organs-of-the-human-body/?i=2073591")!) {
            HStack {
              ZStack {
                Circle()
                  .fill(Color.iconBG_orange)
                  .frame(width: 24, height: 24)
                
                Image("BackIcon")
                  .resizable()
              }.frame(width: 28, height: 28)
              
              Text("Back icon, from thenounproject.com")
                .frame(maxWidth: .infinity, alignment: .leading)
            }.foregroundColor(Color.black)
          }
          
          Link(destination: URL(string: "https://thenounproject.com/duyhung7689/collection/organs-of-the-human-body/?i=2073597")!) {
            HStack {
              ZStack {
                Circle()
                  .fill(Color.iconBG_blue)
                  .frame(width: 24, height: 24)
                
                Image("ShoulderIcon")
                  .resizable()
              }.frame(width: 28, height: 28)
              
              Text("Shoulder icon, adapted from thenounproject.com")
                .frame(maxWidth: .infinity, alignment: .leading)
            }.foregroundColor(Color.black)
          }
          
          Link(destination: URL(string: "https://thenounproject.com/andrejs/collection/lifelike/?i=3355619")!) {
            HStack {
              ZStack {
                Circle()
                  .fill(Color.iconBG_green)
                  .frame(width: 24, height: 24)
                
                Image("LegIcon")
                  .resizable()
              }.frame(width: 28, height: 28)
              
              Text("Leg icon, from thenounproject.com")
                .frame(maxWidth: .infinity, alignment: .leading)
            }.foregroundColor(Color.black)
          }
          
          Link(destination: URL(string: "https://thenounproject.com/deemakdaksina/uploads/?i=2206952")!) {
            HStack {
              ZStack {
                Circle()
                  .fill(Color.iconBG_purple)
                  .frame(width: 24, height: 24)
                
                Image("NeckIcon")
                  .resizable()
              }.frame(width: 28, height: 28)
              
              Text("Neck icon, from thenounproject.com")
                .frame(maxWidth: .infinity, alignment: .leading)
            }.foregroundColor(Color.black)
          }
          
          Link(destination: URL(string: "https://developer.apple.com/sf-symbols/")!) {
            HStack {
              ZStack {
                Circle()
                  .fill(Color.iconBG_orange)
                  .frame(width: 24, height: 24)
                
                Image(systemName: "house")
                  .resizable()
              }.frame(width: 28, height: 28)
              
              Text("System icons from Apple's SF Symbols 2")
                .frame(maxWidth: .infinity, alignment: .leading)
            }.foregroundColor(Color.black)
          }
          
          Link(destination: URL(string: "https://ui8.net/scott-dunlap/products/64-fitness-icons")!) {
            HStack {
              ZStack {
                Circle()
                  .fill(Color.iconBG_blue)
                  .frame(width: 24, height: 24)
                
                Image("StretchIcon")
                  .resizable()
              }.frame(width: 28, height: 28)
              
              Text("Fitness icons from Scott Dunlap, who generously provided them without cost.")
                .frame(maxWidth: .infinity, alignment: .leading)
            }.foregroundColor(Color.black)
          }
        }.padding(.vertical)
        
        VStack(alignment: .leading, spacing: 10) {
          Text("Sounds")
            .font(.system(.title, design: .rounded))
          
          Link(destination: URL(string: "https://freesound.org/s/66951/")!) {
            HStack {
              ZStack {
                Circle()
                  .fill(Color.iconBG_orange)
                  .frame(width: 24, height: 24)
                
                Image(systemName: "link")
                  .resizable()
              }.frame(width: 28, height: 28)
              
              Text("Boxing bell, from freesound.org")
                .frame(maxWidth: .infinity, alignment: .leading)
            }.foregroundColor(Color.black)
          }
        }.padding(.vertical)
      }.padding(.horizontal)
    }.navigationTitle("References")
  }
}
