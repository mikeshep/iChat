//
//  CustomTextField.swift
//  iChat
//
//  Created by Miguel Olmedo on 12/08/24.
//

import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var leftImage: ImageName?
    var isPasswordField: Bool = false
    @State private var showPassword: Bool = true

    var body: some View {
        ZStack {
            if let leftImage = leftImage {
                Image(name: leftImage)
                    .foregroundColor(.lightGreen)
                    .scaledToFit()
                    .frame(height: 20)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

            }

            if isPasswordField {
                if showPassword {
                    SecureField(placeholder, text: $text)
                        .padding(.leading, leftImage == nil ? 20 : 50)
                } else {
                    TextField(placeholder, text: $text)
                        .padding(.leading, leftImage == nil ? 20 : 50)
                }

                Image(sysNameImage: showPassword ? .eyeSlash : .eye)
                    .contentTransition(.symbolEffect(.replace))
                    .foregroundColor(.gray)
                    .scaledToFit()
                    .frame(height: 20)
                    .padding(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .onTapGesture {
                        showPassword.toggle()
                    }

            } else {
                TextField(placeholder, text: $text)
                    .padding(.leading, leftImage == nil ? 20 : 50)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
            }
        }
        .frame(height: 57)
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .inset(by: 0.5)
                .stroke(.gray.opacity(0.5), lineWidth: 1)

        }
    }
}

#Preview {
    CustomTextField(placeholder: "Test", text: .constant(""), leftImage: .person, isPasswordField: true)
}
