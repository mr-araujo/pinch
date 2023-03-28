//
//  ContentView.swift
//  Pinch
//
//  Created by Murillo R. Araújo on 21/03/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isAnimating = false
    @State private var imgScale = CGFloat(1)
    @State private var imgOffSet = CGSize(width: 0, height: 0)

    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                
                Image("magazine-front-cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(imgScale)
                    .offset(x: imgOffSet.width, y: imgOffSet.height)
                    .onTapGesture(count: 2) {
                        if imgScale == 1 {
                            withAnimation(.spring()) {
                                imgScale = 5
                            }
                        } else {
                            resetImgState()
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged{ value in
                                withAnimation(.linear(duration: 1)) {
                                    imgOffSet = value.translation
                                }
                            }
                            .onEnded { _ in
                                if imgScale <= 1 {
                                    resetImgState()
                                }
                            }
                    )
            }
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                withAnimation(.linear(duration: 1)) {
                    isAnimating = true
                }
            }
            .overlay(alignment: .top) {
                InfoPanelView(scale: imgScale, offset: imgOffSet)
                    .padding(.top, 30)
                    .padding(.horizontal)
            }
        }
    }
    
    private func resetImgState() {
        return withAnimation(.spring()) {
            imgScale = 1
            imgOffSet = .zero
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
