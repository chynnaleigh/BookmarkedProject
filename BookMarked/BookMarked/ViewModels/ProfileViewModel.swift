//
//  ProfileViewModel.swift
//  BookMarked
//
//  Created by Chynna Leigh Alcaide on 2024-07-16.
//

import Foundation

import FirebaseAuth
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfileModel?
    @Published var errorMessage: String?
        
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
        
    init() {
        fetchUserProfile()
    }
    
    func fetchUserProfile() {
        guard let userId = auth.currentUser?.uid else { return }
        
        db.collection("users").document(userId).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let name = data?["name"] as? String ?? ""
                let email = data?["email"] as? String ?? ""
                
                self.userProfile = UserProfileModel(id: userId, name: name, email: email)
            } else {
                self.errorMessage = "User data not found."
            }
        }
    }
    
    func updateProfile(name: String, email: String, password: String) {
        guard let userId = auth.currentUser?.uid else { return }
            
        let updateData: [String: Any] = ["name": name, "email": email]
            
        if !password.isEmpty {
            auth.currentUser?.updatePassword(to: password) { error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
            
        db.collection("users").document(userId).updateData(updateData) { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.fetchUserProfile()
            }
        }
    }
    
    func deleteUser() {
        guard let userId = auth.currentUser?.uid else { return }
        
        auth.currentUser?.delete { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.db.collection("users").document(userId).delete { error in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
        
}
