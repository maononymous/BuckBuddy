//
//  HomeView.swift
//  BuckBuddy
//
//  Created by Abdullah Omer Mohammed on 5/28/25.
//

import SwiftUI

struct HomeView: View {
    @State private var navigateTo: String? = nil
    @State private var userBalance: Double = 0.0
    
    // Animation-related states
    @State private var circleScale: CGFloat = 10
    @State private var circleOffset: CGSize = .zero
    @State private var showCircle = false

    var body: some View {
        ZStack {
            
            Color.black.ignoresSafeArea()

            lastLayer
            
            naviLayer

            if showCircle {
                Circle()
                    .fill(.teal)
                    .frame(width: UIScreen.main.bounds.height,
                           height: UIScreen.main.bounds.height)
                    .scaleEffect(circleScale)
                    .offset(circleOffset)
                    .ignoresSafeArea()
            }
        }
        .fullScreenCover(item: $navigateTo) { destination in
            switch destination {
            case "groups": GroupListView()
            case "friends": FriendListView()
            case "expenses": ExpenseView()
            case "profile": ProfileView()
            default: EmptyView()
            }
        }
        .transaction { transaction in
            transaction.disablesAnimations = true
        }
    }
    
    private var lastLayer: some View {
        VStack {
            Spacer()
            Text("Your Balance")
                .foregroundColor(.white)
                .font(.title3)
                .opacity(0.8)

            Text("$\(String(format: "%.2f", userBalance))")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onEnded { value in
                    let horizontal = value.translation.width
                    let vertical = value.translation.height
                    let screenHeight = UIScreen.main.bounds.height
                    let screenWidth = UIScreen.main.bounds.width

                    if abs(horizontal) > abs(vertical) {
                        if horizontal > screenWidth / 3 {
                            circleOffset = CGSize(width: -screenWidth, height: 0)
                            animateCircleAndNavigate(to: "groups")
                        } else if horizontal < -(screenWidth / 3) {
                            circleOffset = CGSize(width: screenWidth, height: 0)
                            animateCircleAndNavigate(to: "friends")
                        }
                    } else {
                        if vertical < -(screenHeight / 3) {
                            circleOffset = CGSize(width: 0, height: screenHeight)
                            animateCircleAndNavigate(to: "expenses")
                        } else if vertical > screenHeight / 3 {
                            circleOffset = CGSize(width: 0, height: -screenHeight)
                            animateCircleAndNavigate(to: "profile")
                        }
                    }
                }
        )
    }
    
    private var naviLayer: some View {
        VStack {
            Image(systemName: "gear")
                .frame(width: 200, height: 200)
                .foregroundStyle(.white)
                .background(Circle().fill(.white).opacity(0.03))
                .ignoresSafeArea()
                .padding(.top, -150)
            
            Spacer()
            
            HStack {
                Image(systemName: "person.fill")
                    .frame(width: 200, height: 200)
                    .foregroundStyle(.white)
                    .background(Circle().fill(.white).opacity(0.03))
                    .ignoresSafeArea()
                    .padding(.leading, -90)
                
                Spacer()
                
                Image(systemName: "person.3.fill")
                    .frame(width: 200, height: 200)
                    .foregroundStyle(.white)
                    .background(Circle().fill(.white).opacity(0.03))
                    .ignoresSafeArea()
                    .padding(.trailing, -90)
            }
            
            Spacer()
            
            Image(systemName: "plus.app")
                .frame(width: 200, height: 200)
                .foregroundStyle(.white)
                .background(Circle().fill(.white).opacity(0.03))
                .ignoresSafeArea()
                .padding(.bottom, -130)
        }
    }

    func animateCircleAndNavigate(to destination: String) {
        showCircle = true
        withAnimation(.easeInOut(duration: 1)) {
            circleScale = 10
            circleOffset = .zero
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.37) {
            navigateTo = destination
            circleScale = 0.1
            showCircle = false
        }
    }
}

extension String: @retroactive Identifiable {
    public var id: String { self }
}

#Preview {
    HomeView()
}
