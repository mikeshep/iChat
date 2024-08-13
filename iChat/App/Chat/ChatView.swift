//
//  ChatView.swift
//  FoodNinja
//
//  Created by Miguel Olmedo on 09/08/24.
//

import SwiftUI
import Combine

struct ChatView: View {

    @StateObject private var viewModel = ChatViewModel()
    @EnvironmentObject private var navigationStore: NavigationStore
    @EnvironmentObject private var user: UserInfo
    @ObservedObject var contact: UserUid
    @State private var messageText = ""

    private var headerBackView: some View {
        HStack {
            backButton
                .padding(.horizontal, 20)
            Spacer()
        }
    }

    var profileView: some View {
        HStack(alignment: .center) {
            Image(name: .profile)
                .frame(width: 100, height: 100)

            VStack(alignment: .leading) {
                Text(contact.displayName)
                    .font(.system(size: 22))

                Text("Online")
                    .font(.system(size: 15))
            }
            Spacer()
        }
    }

    var headerView: some View {
        VStack {
            ZStack {
                Image(name: .headerChat)
                    .resizable()
                VStack {
                    headerBackView
                    profileView
                }
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 150)
    }

    var messagesView: some View {
        LazyVStack {
            ForEach(viewModel.messages) { message in
                HStack {
                    if message.senderId == user.uid {
                        Spacer()
                        Text(message.text)
                            .padding()
                            .background(Color.lightGreen)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    } else {
                        Text(message.text)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .foregroundColor(.black)
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 4)
            }
        }
    }

    var senderView: some View {
        HStack {
            TextField("Escribe tu mensaje", text: $messageText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                let messageText = self.messageText
                Task {
                    await viewModel.sendMessage(contact: contact, text: messageText, user: user)
                }
                self.messageText = ""
            }) {
                Text("Eviar")
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
    }

    func messageScrollView(reader: GeometryProxy) -> some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                messagesView
            }
            .onAppear {
                Task {
                    let chatId = await viewModel.setupChat(contact: contact, user: user)
                    viewModel.fetchChat(contact: contact, user: user, chatId: chatId)
                }
            }
            .onChange(of: viewModel.messages) {
                if let lastMessageId = viewModel.messages.last?.id {
                    withAnimation {
                        scrollViewProxy.scrollTo(lastMessageId, anchor: .bottom)
                    }
                }
            }
        }
    }

    var body: some View {
        GeometryReader { reader in
            ZStack {
                VStack {
                    headerView
                    messageScrollView(reader: reader)
                    senderView
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .navigationBarBackButtonHidden(true)
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }

    private var backButton: some View {
        Button(action: {
            navigationStore.popView()
        }, label: {
            Image(name: .backIcon)
        })
    }
}
