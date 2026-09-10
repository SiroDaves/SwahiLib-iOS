//
//  SplashView.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel: SplashViewModel = {
        DiContainer.shared.resolve(SplashViewModel.self)
    }()
    @State private var navigateToNextScreen = false
    
    let deepLinked: Bool
    let word: Word
    
    var body: some View {
        Group {
            if navigateToNextScreen {
                destinationView
            } else {
                SplashContent()
                    .onAppear {
                        viewModel.initialize()
                    }
            }
        }
        .onReceive(viewModel.$isInitialized) { initialized in
            if initialized {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    navigateToNextScreen = true
                }
            }
        }
        .animation(.easeInOut, value: navigateToNextScreen)
    }
    
    @ViewBuilder
    private var destinationView: some View {
        if viewModel.prefsRepo.isDataLoaded {
            if deepLinked {
                WordView(deepLinked: true, word: word)
            } else {
                HomeView()
            }
        } else {
            InitView()
        }
    }
}

struct SplashContent: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image(.mainIcon)
                .resizable()
                .frame(width: 200, height: 200)

            Text(AppConstants.appTitle)
                .font(.system(size: 50, weight: .bold))
                .kerning(5)
                .foregroundColor(.primary1)
                .padding(.top, 5)
            
            Text(AppConstants.appTitle2)
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(.primary1)
            
            Spacer()
            
            Text(AppConstants.appTagline)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary1)
            .padding(.bottom, 20)
            
            Divider()
                .frame(height: 1)
                .padding(.horizontal, 100)
                .background(.onPrimaryContainer)

            Text(AppConstants.appCredits)
                .font(.system(size: 16))
                .foregroundColor(.primary1)
            .padding(.top, 20)

            Spacer().frame(height: 20)
        }.padding()
    }
}

#Preview {
    SplashView(deepLinked: false, word: Word.sampleWords[0])
}
