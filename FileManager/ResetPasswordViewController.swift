//
//  File.swift
//  FileManager
//
//  Created by ROMAN VRONSKY on 30.12.2022.
//

import UIKit
import KeychainAccess

class ResetPasswordViewController: UIViewController {
    let keyChain = Keychain(service: "Roman-Vronsky.FileManager")
    private lazy var newPasswordTextField: UITextField = {
        let newPassword = UITextField()
        newPassword.translatesAutoresizingMaskIntoConstraints = false
        newPassword.placeholder = "Введите новый пароль"
        newPassword.layer.borderWidth = 0.5
        newPassword.layer.cornerRadius = 10
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        newPassword.leftView = paddingView
        newPassword.leftViewMode = .always
        newPassword.becomeFirstResponder()
        return newPassword
    }()
    
    private lazy var repeatPasswordTextField: UITextField = {
        let repeatPassword = UITextField()
        repeatPassword.translatesAutoresizingMaskIntoConstraints = false
        repeatPassword.placeholder = "Повторите пароль"
        repeatPassword.layer.borderWidth = 0.5
        repeatPassword.layer.cornerRadius = 10
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        repeatPassword.leftView = paddingView
        repeatPassword.leftViewMode = .always
        return repeatPassword
    }()
    private lazy var changePasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Сменить пароль", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapPasswordButton), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        setupView()
    }
    
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.newPasswordTextField)
        self.view.addSubview(self.repeatPasswordTextField)
        self.view.addSubview(self.changePasswordButton)
        
        NSLayoutConstraint.activate([
        
            self.newPasswordTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30),
            self.newPasswordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.newPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            self.newPasswordTextField.widthAnchor.constraint(equalToConstant: 300),
            
            self.repeatPasswordTextField.topAnchor.constraint(equalTo: self.newPasswordTextField.bottomAnchor, constant: 16),
            self.repeatPasswordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.repeatPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            self.repeatPasswordTextField.widthAnchor.constraint(equalToConstant: 300),
            
            self.changePasswordButton.topAnchor.constraint(equalTo: self.repeatPasswordTextField.bottomAnchor, constant: 16),
            self.changePasswordButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.changePasswordButton.heightAnchor.constraint(equalToConstant: 50),
            self.changePasswordButton.widthAnchor.constraint(equalToConstant: 300),
            
            
        
        ])
    }
    
    private func showAlert(title: String, message: String?, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) {_ in
            completionHandler()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    @objc private func didTapPasswordButton() {
        guard newPasswordTextField.text != "" else { return showAlert(title: "Ошибка!", message: "Введите новый пароль") {
            self.newPasswordTextField.becomeFirstResponder()
        }}
        
        guard repeatPasswordTextField.text != "" else { return showAlert(title: "Ошибка!", message: "Повторите новый пароль") {
            self.repeatPasswordTextField.becomeFirstResponder()
        }}
        
        if newPasswordTextField.text == repeatPasswordTextField.text {
            keyChain["password"] = newPasswordTextField.text
            showAlert(title: "Пароль изменен!", message: nil) {
                self.dismiss(animated: true)
            }
        } else {
            showAlert(title: "Ошибка!", message: "Пароли не совпадают. Повторите новый пароль") {
                self.repeatPasswordTextField.text = ""
                self.repeatPasswordTextField.becomeFirstResponder()
            }}
        }
    
}

