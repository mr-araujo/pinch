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
    @State private var isDrawerOpen = false
    @State private var drawerDidOpen = false

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
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)) {
                                    if imgScale >= 1 && imgScale <= 5 {
                                        imgScale = value
                                    } else if imgScale > 5 {
                                        imgScale = 1
                                    }
                                }
                            }
                            .onEnded { _ in
                                resetImgState()
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
            .overlay(alignment: .topTrailing) {
                HStack {
                    Image(systemName: drawerDidOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.5)) {
                                isDrawerOpen.toggle()
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeOut) {
                                    drawerDidOpen.toggle()
                                }
                            }
                        }

                    Spacer()
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 8)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .opacity(isAnimating ? 1 : 0)
                .frame(width: 260)
                .padding(.top, UIScreen.main.bounds.height / 12)
                .offset(x: isDrawerOpen ? 20 : 215)
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
