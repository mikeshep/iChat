//
//  SignupView.swift
//  FoodNinja
//
//  Created by Imran on 14/01/24.
//

import SwiftUI

struct SignupView: View {
    @ObservedObject private var viewModel = SignupViewModel()
    @EnvironmentObject private var navigationStore: NavigationStore
    @EnvironmentObject private var user: UserInfo

    var fields: some View {
        VStack {
            CustomTextField(placeholder: "Nombre de usuario",
                            text: $viewModel.username,
                            leftImage: .profile)

            CustomTextField(placeholder: "Email",
                            text: $viewModel.email,
                            leftImage: .message)

            CustomTextField(placeholder: "Contraseña",
                            text: $viewModel.password,
                            leftImage: .lock,
                            isPasswordField: true)
        }
    }

    var actions: some View {
        VStack {
            Label("Mantener sesión", systemImage: viewModel.keepMeSignedIn ? ImageName.checkMarkFilled.rawValue : ImageName.checkmark.rawValue)
                .contentTransition(.symbolEffect(.replace))
                .foregroundColor(viewModel.keepMeSignedIn ? .darkGreen : .gray)
                .padding(.top)
                .onTapGesture {
                    viewModel.keepMeSignedIn.toggle()
                }
                .frame(maxWidth: .infinity, alignment: .leading)

            let config = CustomButtonConfig(title: "Crear cuenta") {
                Task {
                    await viewModel.signUp(user: user)
                }
            }

            CustomButton(config: config)
                .frame(width: 150)
                .padding(.top, 40)

            Button(action: {
                navigationStore.popToRoot()
            }, label: {
                Text("¿Ya tienes una cuenta?")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.lightGreen)
            })
            .padding(.top)
            .padding(.bottom, 40)
        }
    }

    var body: some View {
        ZStack {
            Image(name: .splash)
                .ignoresSafeArea()

            ScrollView {
                Image(name: .splashLogo)

                Text("Registro")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.top, 50)

                fields
                actions

            }
            .padding(.horizontal)
            .navigationBarBackButtonHidden(true)
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(title: Text("Authentication Error"), message: Text(viewModel.error), dismissButton: .default(Text("OK")))
            }
            .onChange(of: viewModel.isAuthenticated, initial: false) { _, otherValue in
                if otherValue {
                    navigationStore.push(to: .home)
                }
            }
        }
    }
}

#Preview {
    SignupView()
}
