//
//  HomeView.swift
//  FoodNinja
//
//  Created by Miguel Olmedo on 08/08/24.
//

import SwiftUI

struct HomeView: View {

    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var navigationStore: NavigationStore
    @EnvironmentObject private var user: UserInfo
    @EnvironmentObject private var appState: AppState

    var body: some View {
        GeometryReader { reader in
            ZStack {
                Image(name: .conversations)
                    .ignoresSafeArea()

                ScrollView {
                    VStack {
                        HStack {
                            Text("Mensajes")
                                .font(.system(size: 25, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top)

                            Spacer()

                            powerButton
                        }
                        .padding(.horizontal)

                        HStack {
                            Image(.searchIcon)
                                .foregroundColor(.white)

                            TextField("Buscar contacto", text: $viewModel.searchText)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .font(.system(size: 14))
                        }
                        .padding(.horizontal)
                        .frame(height: 48) // Establece la altura del SearchBar
                        .background(.white)
                        .cornerRadius(12) // Redondeo como Card
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // Sombra difusa
                        .padding(.horizontal, 30)

                        if viewModel.filteredContacts.isEmpty && viewModel.filteredFindUsers.isEmpty {
                            Spacer()
                        }

                        // Contact List

                        if !viewModel.filteredContacts.isEmpty {
                            List(viewModel.filteredContacts) { contact in
                                HStack(alignment: .center) {
                                    Image(.profile)

                                    VStack(alignment: .leading) {
                                        Text(contact.displayName)
                                            .font(.system(size: 13))
                                        Text(contact.email)
                                            .font(.system(size: 13))
                                            .foregroundStyle(.gray)
                                    }

                                    Spacer()
                                }
                                .frame(height: 103) //
                                .frame(maxWidth: .infinity) // Ocupar todo el ancho disponible
                                .background(Color.white.opacity(0.5))
                                .cornerRadius(15)
                                .listRowBackground(Color.clear)
                                .listRowSpacing(10)
                                .listRowSeparator(.hidden)
                                .onTapGesture {
                                    let userUid = UserUid()
                                    userUid.uid = contact.uid
                                    userUid.displayName = contact.displayName
                                    navigationStore.push(to: .chat(contact: userUid))
                                }

                            }
                            .listStyle(.plain)
                        }

                        if !viewModel.filteredFindUsers.isEmpty {
                            Text("Otros usuarios")
                                .font(.system(size: 13, weight: .regular))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)

                            List(viewModel.filteredFindUsers) { contact in
                                HStack(alignment: .center) {
                                    Image(.profile)

                                    VStack(alignment: .leading) {
                                        Text(contact.displayName)
                                            .font(.system(size: 13))
                                        Text("Hey, how's it goin?")
                                            .font(.system(size: 13))
                                            .foregroundStyle(.gray)
                                    }

                                    Spacer()
                                }
                                .frame(height: 103) //
                                .frame(maxWidth: .infinity) // Ocupar todo el ancho disponible
                                .background(Color.white.opacity(0.5))
                                .cornerRadius(15)
                                .listRowBackground(Color.clear)
                                .listRowSpacing(10)
                                .listRowSeparator(.hidden)
                                .onTapGesture {
                                    let userUid = UserUid()
                                    userUid.uid = contact.uid
                                    userUid.displayName = contact.displayName
                                    navigationStore.push(to: .chat(contact: userUid))
                                }

                            }
                            .listStyle(.plain)
                        }

                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: reader.size.height)
                }
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    viewModel.getContacts(user: user)
                }
            }
        }
    }

    private var powerButton: some View {
        Button(action: {
            user.uid = ""
            user.displayName = ""
            appState.isAuthenticated = false
            navigationStore.popToRoot()
        }, label: {
            Image(sysNameImage: .power)
        })
    }
}

#Preview {
    LoginView()
}
