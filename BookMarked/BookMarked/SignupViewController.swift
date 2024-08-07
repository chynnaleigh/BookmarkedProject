//
//  SignupViewController.swift
//  BookMarked
//
//  Created by Chynna Leigh Alcaide on 2024-07-05.
//

import UIKit
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class SignupViewController: UIViewController {
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
        labelLogin.text = "Hello,"
        labelLogin.font = UIFont.boldSystemFont(ofSize: 24)
        labelLogin.textColor = UIColor.black
        labelLogin.textAlignment = .center
        labelLogin.translatesAutoresizingMaskIntoConstraints = false
        return labelLogin
    }()
    
    lazy var subtitleLabel: UILabel = {
        let labelLogin = UILabel()
        labelLogin.text = "let's start your next adventure!"
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
    
    lazy var userTextField: UITextField = {
        let tfUserSignUp = UITextField()
        tfUserSignUp.placeholder = "Name"
        tfUserSignUp.font = UIFont.boldSystemFont(ofSize: 20)
        tfUserSignUp.backgroundColor = UIColor.white
        tfUserSignUp.heightAnchor.constraint(equalToConstant: 43).isActive = true
        tfUserSignUp.layer.shadowOpacity = 0.25
        tfUserSignUp.layer.shadowColor = UIColor(hexString: "#7090B0", alpha: 1.0).cgColor
        tfUserSignUp.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        tfUserSignUp.layer.shadowRadius = 10
        tfUserSignUp.layer.cornerRadius = 20
        tfUserSignUp.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: tfUserSignUp.frame.height))
        tfUserSignUp.leftView = paddingView
        tfUserSignUp.leftViewMode = .always
        tfUserSignUp.rightView = paddingView
        tfUserSignUp.rightViewMode = .always
        
        return tfUserSignUp
    }()
    
    lazy var emailTextField: UITextField = {
        let tfEmailSignUp = UITextField()
        tfEmailSignUp.placeholder = "Email"
        tfEmailSignUp.font = UIFont.boldSystemFont(ofSize: 18)
        tfEmailSignUp.backgroundColor = UIColor.white
        tfEmailSignUp.heightAnchor.constraint(equalToConstant: 43).isActive = true
        tfEmailSignUp.layer.shadowOpacity = 0.25
        tfEmailSignUp.layer.shadowColor = UIColor(hexString: "#7090B0", alpha: 1.0).cgColor
        tfEmailSignUp.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        tfEmailSignUp.layer.shadowRadius = 10
        tfEmailSignUp.layer.cornerRadius = 20
        tfEmailSignUp.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: tfEmailSignUp.frame.height))
        tfEmailSignUp.leftView = paddingView
        tfEmailSignUp.leftViewMode = .always
        tfEmailSignUp.rightView = paddingView
        tfEmailSignUp.rightViewMode = .always
        
        return tfEmailSignUp
    }()
    
    lazy var passwordTextField: UITextField = {
        let tfPasswordSignUp = UITextField()
        tfPasswordSignUp.placeholder = "Password"
        tfPasswordSignUp.isSecureTextEntry = true
        tfPasswordSignUp.font = UIFont.boldSystemFont(ofSize: 18)
        tfPasswordSignUp.backgroundColor = UIColor.white
        tfPasswordSignUp.heightAnchor.constraint(equalToConstant: 43).isActive = true
        tfPasswordSignUp.layer.shadowOpacity = 0.2
        tfPasswordSignUp.layer.shadowColor = UIColor(hexString: "#7090B0", alpha: 1.0).cgColor
        tfPasswordSignUp.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        tfPasswordSignUp.layer.shadowRadius = 10
        tfPasswordSignUp.layer.cornerRadius = 20
        tfPasswordSignUp.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: tfPasswordSignUp.frame.height))
        tfPasswordSignUp.leftView = paddingView
        tfPasswordSignUp.leftViewMode = .always
        tfPasswordSignUp.rightView = paddingView
        tfPasswordSignUp.rightViewMode = .always
        
        return tfPasswordSignUp
    }()
    
    lazy var tfStack: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(userTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.spacing = 21
        stackView.alignment = .fill //using fill instead of a set width so it'll scale well
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var signUpButton: UIButton = {
        let buttonSignUp = UIButton()
        buttonSignUp.setTitle("Sign up", for: .normal)
        buttonSignUp.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        buttonSignUp.backgroundColor = UIColor(hexString: "#FF9900", alpha: 1.0)
        buttonSignUp.heightAnchor.constraint(equalToConstant: 56).isActive = true
        buttonSignUp.widthAnchor.constraint(equalToConstant: 306).isActive = true
        buttonSignUp.layer.cornerRadius = 30
        
        buttonSignUp.addTarget(self, action: #selector(signupButtonPressed), for: .touchUpInside)
        
        buttonSignUp.translatesAutoresizingMaskIntoConstraints = false
        return buttonSignUp
    }()
    
    lazy var loginLabel: UILabel = {
        let loginAccount = UILabel()
        loginAccount.text = "Already have an account?"
        loginAccount.font = UIFont.boldSystemFont(ofSize: 15)
        loginAccount.textColor = UIColor(hexString: "#4E4E4E", alpha: 1.0)
        loginAccount.adjustsFontSizeToFitWidth = true
        loginAccount.translatesAutoresizingMaskIntoConstraints = false
        return loginAccount
    }()
    
    lazy var loginLinkLabel: UILabel = {
        let login = UILabel()
        login.text = " Login"
        login.font = UIFont.boldSystemFont(ofSize: 15)
        login.textColor = UIColor(hexString: "#64B1FE", alpha: 1.0)
        login.adjustsFontSizeToFitWidth = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loginLabelPressed))
        login.isUserInteractionEnabled = true
        login.addGestureRecognizer(tapGesture)
        
        login.translatesAutoresizingMaskIntoConstraints = false
        return login
    }()
    
    lazy var loginStack: UIStackView = {
        let newAccStack = UIStackView()
        newAccStack.addArrangedSubview(loginLabel)
        newAccStack.addArrangedSubview(loginLinkLabel)
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
            tfStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 463),
            tfStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            tfStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        view.addSubview(signUpButton)
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 674),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])
        
        view.addSubview(loginStack)
        NSLayoutConstraint.activate([
            loginStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 771),
            loginStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
    
    @objc func signupButtonPressed() {
        guard let name = userTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert("Error", "All fields are required.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
                self.showAlert("Error", error.localizedDescription)
            }
            
            guard let uid = authResult?.user.uid else { return }
                        
            let db = Firestore.firestore()
            db.collection("users").document(uid).setData([
                "name": name,
                "email": email
            ]) { error in
                if let error = error {
                    self.showAlert("Error", "Failed to save user data: \(error.localizedDescription)")
                } else {
                    self.showAlert("Success", "User signed up successfully!")
                    
                    let view = TabViewContainer()
                    let viewHostingController = UIHostingController(rootView: view)
                    self.navigationController?.pushViewController(viewHostingController, animated: true)
                }
            }
        }
        
        
    }
    
    @objc func loginLabelPressed() {
        let signupVC = LoginViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
}
