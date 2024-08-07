//
//  LoginViewController.swift
//  BookMarked
//
//  Created by Chynna Leigh Alcaide on 2024-07-05.
//

import UIKit
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    lazy var backButton: UIBarButtonItem = {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.tintColor = UIColor.black
        
        let backBarButton = UIBarButtonItem(customView: backButton)
        
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backBarButton
    }()
    
    lazy var imageView: UIImageView = {
        let ivLogin = UIImageView()
        ivLogin.image = UIImage(named: "logo")
        ivLogin.translatesAutoresizingMaskIntoConstraints = false
        return ivLogin
    }()
    
    lazy var titleLabel: UILabel = {
        let labelLogin = UILabel()
        labelLogin.text = "Welcome back,"
        labelLogin.font = UIFont.boldSystemFont(ofSize: 24)
        labelLogin.textColor = UIColor.black
        labelLogin.textAlignment = .center
        labelLogin.translatesAutoresizingMaskIntoConstraints = false
        return labelLogin
    }()
    
    lazy var subtitleLabel: UILabel = {
        let labelLogin = UILabel()
        labelLogin.text = "let's get back to reading!"
        labelLogin.textColor = UIColor.black
        labelLogin.textAlignment = .center
        labelLogin.translatesAutoresizingMaskIntoConstraints = false
        return labelLogin
    }()
    
    lazy var tfLabelStack: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.alignment = .fill //using fill instead of a set width so it'll scale well
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var emailTextField: UITextField = {
        let tfEmailLogin = UITextField()
        tfEmailLogin.placeholder = "Email"
        tfEmailLogin.font = UIFont.boldSystemFont(ofSize: 19)
        tfEmailLogin.backgroundColor = UIColor.white
        tfEmailLogin.heightAnchor.constraint(equalToConstant: 43).isActive = true
        tfEmailLogin.layer.shadowOpacity = 0.25
        tfEmailLogin.layer.shadowColor = UIColor(hexString: "#7090B0", alpha: 1.0).cgColor
        tfEmailLogin.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        tfEmailLogin.layer.shadowRadius = 10
        tfEmailLogin.layer.cornerRadius = 20
        tfEmailLogin.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: tfEmailLogin.frame.height))
        tfEmailLogin.leftView = paddingView
        tfEmailLogin.leftViewMode = .always
        tfEmailLogin.rightView = paddingView
        tfEmailLogin.rightViewMode = .always
        
        return tfEmailLogin
    }()
    
    lazy var passwordTextField: UITextField = {
        let tfPasswordLogin = UITextField()
        tfPasswordLogin.placeholder = "Password"
        tfPasswordLogin.isSecureTextEntry = true
        tfPasswordLogin.font = UIFont.boldSystemFont(ofSize: 18)
        tfPasswordLogin.backgroundColor = UIColor.white
        tfPasswordLogin.heightAnchor.constraint(equalToConstant: 43).isActive = true
        tfPasswordLogin.layer.shadowOpacity = 0.25
        tfPasswordLogin.layer.shadowColor = UIColor(hexString: "#7090B0", alpha: 1.0).cgColor
        tfPasswordLogin.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        tfPasswordLogin.layer.shadowRadius = 10
        tfPasswordLogin.layer.cornerRadius = 20
        tfPasswordLogin.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: tfPasswordLogin.frame.height))
        tfPasswordLogin.leftView = paddingView
        tfPasswordLogin.leftViewMode = .always
        tfPasswordLogin.rightView = paddingView
        tfPasswordLogin.rightViewMode = .always
        
        return tfPasswordLogin
    }()
    
    lazy var tfStack: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.spacing = 25
        stackView.alignment = .fill //using fill instead of a set width so it'll scale well
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var loginButton: UIButton = {
        let buttonLogin = UIButton()
        buttonLogin.setTitle("Log in", for: .normal)
        buttonLogin.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        buttonLogin.backgroundColor = UIColor(hexString: "#FF9900", alpha: 1.0)
        buttonLogin.heightAnchor.constraint(equalToConstant: 56).isActive = true
        buttonLogin.layer.cornerRadius = 30
        
        buttonLogin.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        
        buttonLogin.translatesAutoresizingMaskIntoConstraints = false
        return buttonLogin
    }()
    
    lazy var newAccountLabel: UILabel = {
        let newAccount = UILabel()
        newAccount.text = "Don't have an account?"
        newAccount.font = UIFont.boldSystemFont(ofSize: 15)
        newAccount.textColor = UIColor(hexString: "#4E4E4E", alpha: 1.0)
        newAccount.adjustsFontSizeToFitWidth = true
        newAccount.translatesAutoresizingMaskIntoConstraints = false
        return newAccount
    }()
    
    lazy var signUpLabel: UILabel = {
        let signUp = UILabel()
        signUp.text = " Sign up"
        signUp.font = UIFont.boldSystemFont(ofSize: 15)
        signUp.textColor = UIColor(hexString: "#64B1FE", alpha: 1.0)
        signUp.adjustsFontSizeToFitWidth = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signupLabelPressed))
                signUp.isUserInteractionEnabled = true
                signUp.addGestureRecognizer(tapGesture)
        
        signUp.translatesAutoresizingMaskIntoConstraints = false
        return signUp
    }()
    
    lazy var newAccStack: UIStackView = {
        let newAccStack = UIStackView()
        newAccStack.addArrangedSubview(newAccountLabel)
        newAccStack.addArrangedSubview(signUpLabel)
        newAccStack.axis = .horizontal
        newAccStack.heightAnchor.constraint(equalToConstant: 21).isActive = true
        newAccStack.widthAnchor.constraint(equalToConstant: 234).isActive = true
        newAccStack.translatesAutoresizingMaskIntoConstraints = false
        return newAccStack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = backButton
        
        // used the constraints on the figma for all of the below
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 146),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 205),
            imageView.widthAnchor.constraint(equalToConstant: 205)
        ])

        view.addSubview(tfLabelStack)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 363),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 29)
        ])
        
        view.addSubview(tfStack)
        NSLayoutConstraint.activate([
            tfStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 500),
            tfStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            tfStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 674),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])
        
        view.addSubview(newAccStack)
        NSLayoutConstraint.activate([
            newAccStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 771),
            newAccStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // error handling
    private func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // tap gestures
    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func loginButtonPressed() {
        guard let email = emailTextField.text, !email.isEmpty,
                let password = passwordTextField.text, !password.isEmpty else {
            showAlert("Error", "Email and password cannot be empty.")
            return
        }
        
        let authViewModel = AuthViewModel()

        authViewModel.signIn(email: email, password: password) { result in
            switch result {
            case .success(let user):
                // Handle successful login
                print("User signed in: \(user.uid)")
                let view = TabViewContainer()
                let viewHostingController = UIHostingController(rootView: view)
                self.navigationController?.pushViewController(viewHostingController, animated: true)
            case .failure(let error):
                // Handle login error
                print("Error logging in: \(error.localizedDescription)")
                self.showAlert("Error", error.localizedDescription)
            }
            
//            guard let uid = authResult?.user.uid else { return }
                        
//            let db = Firestore.firestore()
//            db.collection("users").document(uid).getDocument { (document, error) in
//                if let document = document, document.exists {
//                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                    print("Document data: \(dataDescription)")
//                    // Use the retrieved user data
////                    self.showAlert("Success", "User logged in successfully!")
//                    
////                    DispatchQueue.main.async {
//                        let view = TabViewContainer()
//                        let viewHostingController = UIHostingController(rootView: view)
//                        self.navigationController?.pushViewController(viewHostingController, animated: true)
////                    }
//                } else {
//                    print("Document does not exist")
//                    self.showAlert("Error", "User data not found.")
//                }
//            }
        }
    }
    
    @objc func signupLabelPressed() {
        let signupVC = SignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
}
