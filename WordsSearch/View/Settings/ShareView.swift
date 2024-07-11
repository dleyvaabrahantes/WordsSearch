//
//  ShareView.swift
//  ShareContent
//
//  Created by David on 1/31/24.
//

import SwiftUI

struct ShareView: View {
    @Binding var showShareView: Bool
    @State var copyLink = false
    var link = "https://apps.apple.com/us/app/word-explorer-puzzle/id6514323759"
    var link2 = "https://apps.apple.com/us/app/word-explorer-puzzle/id6514323759"
    var body: some View {
        VStack{
            Button(action: {
                withAnimation {
                    showShareView.toggle()
                }
            }, label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .padding(10)
                    .background(.gray.opacity(0.15), in: Circle())
                    .frame(maxWidth: .infinity, alignment: .leading)
            })
            .padding(.top)
            .tint(.black)
            Spacer()
            Group {
                Text("Invite your friends\nto discover the app")
                    .bold()
                    .font(.largeTitle)
               
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            IconShareView()
                .frame(height: 300)
            HStack(spacing: 14){
                Button {
                    UIPasteboard.general.string = link
                    withAnimation {
                        copyLink.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                        withAnimation {
                            copyLink.toggle()
                        }
                    }
                } label: {
                    VStack{
                        Image(systemName: "doc.on.doc")
                            .font(.title)
                        Text("Copy link")
                            .font(.custom("HoeflerText-Regular", size: 20))
                    }
                    .frame(width: 160, height: 140)
                    .background(.gray.opacity(0.15), in: RoundedRectangle(cornerRadius: 30))
                }

                ShareLink(item: URL(string: link) ?? URL(string: link2)!){
                    VStack{
                        Image(systemName: "square.and.arrow.up")
                            .font(.title)
                        Text("Share Link")
                            .font(.custom("HoeflerText-Regular", size: 20))
                    }
                    .frame(width: 160, height: 140)
                    .background(.gray.opacity(0.15), in: RoundedRectangle(cornerRadius: 30))
                }
            }
            .tint(.primary)
            Spacer()
            Button {
                withAnimation {
                    showShareView.toggle()
                }
            } label: {
                Text("Maybe later")
                    .font(.system(size: 25))
                    .opacity(0.5)
            }
            .tint(.primary)

        }
        .overlay(alignment: .bottom, content: {
            Text("Link Copied :)")
                .bold()
                .font(.headline)
                .frame(width: 150, height: 50)
                .background(.white, in: RoundedRectangle(cornerRadius: 30))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 0)
                .offset(y: copyLink ? 0 : 100)
            
        })
        .padding(.horizontal,30)
    }
}

#Preview {
    ShareView(showShareView: .constant(false))
}
