//
//  WelcomeViewController.swift
//  BookMarked
//
//  Created by Jerad Jennings on 2024-07-04.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.center = self.view.center
        label.text = "Bookmark'd"
        label.font = UIFont.boldSystemFont(ofSize: 29)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var welcomeImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "welcomeimage")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var subheaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter a world,\nwhere every page counts!"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var statementLabel: UILabel = {
        let label = UILabel()
        label.text = "Let’s make a habit of reading and track \nyour reading journey together"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var labelStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.addArrangedSubview(subheaderLabel)
        stackView.addArrangedSubview(statementLabel)
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start Reading", for: .normal)
        button.backgroundColor = UIColor(hexString: "#FF9900", alpha: 1.0)
        button.layer.cornerRadius = 20
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 300).isActive = true
        button.layer.shadowOpacity = 0.5
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(startReadingTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var createAccountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create an account", for: .normal)
        button.backgroundColor = UIColor(hexString: "#FEC064", alpha: 1.0)
        button.layer.cornerRadius = 20
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 300).isActive = true
        button.layer.shadowOpacity = 0.5
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(createAccountTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonStack:  UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.addArrangedSubview(startButton)
        stackView.addArrangedSubview(createAccountButton)
        stackView.spacing = 20
        stackView.alignment = .leading
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        view.addSubview(welcomeImage)
        NSLayoutConstraint.activate([
            welcomeImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            welcomeImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            welcomeImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            welcomeImage.widthAnchor.constraint(equalToConstant: 125),
            welcomeImage.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        view.addSubview(labelStack)
        NSLayoutConstraint.activate([
            labelStack.topAnchor.constraint(equalTo: welcomeImage.bottomAnchor, constant: 20),
            labelStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
        ])
        
        view.addSubview(buttonStack)
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: labelStack.bottomAnchor, constant: 85),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
        ])
    }
    
    @objc func startReadingTapped() {
        let vc = LoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func createAccountTapped() {
        let vc = SignupViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
