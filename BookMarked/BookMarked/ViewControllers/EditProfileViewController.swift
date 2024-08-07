//
//  EditProfileViewController.swift
//  BookMarked
//
//  Created by Chynna Leigh Alcaide on 2024-07-16.
//

import SwiftUI

struct EditProfileViewController: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var isSelected: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                if let userProfile = viewModel.userProfile {
                    TextField("Name", text: $name).textFieldStyle(RoundedBorderTextFieldStyle()).onAppear {
                        name = userProfile.name
                        email = userProfile.email
                    }
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Update Profile") {
                        viewModel.updateProfile(name: name, email: email, password: password)
                    }
                    
                    Button("Delete Account") {
                        self.viewModel.deleteUser()
                    }
                    .foregroundColor(.red)
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage).foregroundColor(.red)
                    }
                } else {
                    Text("Loading...")
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image("backIcon").resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        }
                        
                        Text("Edit Profile").font(.title2).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).foregroundColor(.black).padding(10)
                        
                    }
                }
            }
        }
        
    }
}

struct EditProfileViewController_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileViewController(isSelected: true)
    }
}

