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
            .overlay(alignment: .bottom) {
                Group {
                    HStack {
                        Button {
                            withAnimation(.spring()) {
                                if imgScale > 1 {
                                    imgScale -= 1
                                }
                                
                                if imgScale <= 1 {
                                    resetImgState()
                                }
                            }
                        } label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }
                        
                        Button {
                            resetImgState()
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        
                        Button {
                            withAnimation(.spring()) {
                                if imgScale < 5 {
                                    imgScale += 1
                                }
                                
                                if imgScale > 5 {
                                    imgScale = 5
                                }
                            }
                        } label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                }.padding(.bottom, 30)
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
