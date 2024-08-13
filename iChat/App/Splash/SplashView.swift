//
//  SplashView.swift
//  FoodNinja
//
//  Created by Imran on 24/12/23.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Image(name: .splash)
                .resizable()
                .ignoresSafeArea()

            VStack {

                Image(name: .splashLogo)
                    .padding()

                Text("Bienvenido a")
                    .padding(.top)
                    .font(.system(.title2))

                Text("iChat")
                    .font(.system(size: 39,
                                  weight: .bold,
                                  design: .rounded))

            }
        }
    }
}

#Preview {
    SplashView()
}
