//
//  LoginView.swift
//  FoodNinja
//
//  Created by Imran on 01/01/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var navigationStore: NavigationStore
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var user: UserInfo
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        ZStack {
            Image(name: .splash)
                .ignoresSafeArea()

            ScrollView {
                Image(name: .splashLogo)
                    .padding(.top)

                Text("iChat")
                    .font(.system(size: 39,
                                  weight: .bold,
                                  design: .rounded))

                Text("Bienvenido")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.top, 50)

                CustomTextField(placeholder: "Email", text: $viewModel.email)
                    .padding(.top, 40)

                CustomTextField(placeholder: "Password", text: $viewModel.password, isPasswordField: true)
                    .padding(.top)

                Button {
                    print("Forgot password is tapped.")
                } label: {
                    Text("Olvidé mi contraseña")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.lightGreen)
                }

                let config = CustomButtonConfig(title: "Login") {
                    Task { await viewModel.login(user: user) }
                }

                CustomButton(config: config)
                    .frame(width: 140)
                    .padding(.top)

                Button {
                    navigationStore.push(to: .signup)
                } label: {
                    Text("¿No tienes cuenta?, Comencemos")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.lightGreen)
                }
                .padding(.top)
                .padding(.bottom, 40)

            }
            .padding(.horizontal)
            .scrollIndicators(.hidden)
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(title: Text("Authentication Error"),
                      message: Text(viewModel.error),
                      dismissButton: .default(Text("OK")))
            }
            .onReceive(viewModel.$isAuthenticated, perform: { _ in
                if viewModel.isAuthenticated {
                    appState.isAuthenticated = true
                }
            })
            .onChange(of: viewModel.isAuthenticated) {
                DispatchQueue.main.async {
                    appState.isAuthenticated = viewModel.isAuthenticated
                }
            }
            .onAppear {
                debugPrint("onAppear")
            }
            .onDisappear {
                debugPrint("onDisappear")
            }
        }
    }
}

#Preview {
    LoginView()
}
