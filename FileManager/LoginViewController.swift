//
//  LoginViewController.swift
//  FileManager
//
//  Created by ROMAN VRONSKY on 30.12.2022.
//

import UIKit
import KeychainAccess

class LoginViewController: UIViewController {

    var chek = UserDefaults.standard.bool(forKey: "isLogin")
//    var chek: Void = UserDefaults.standard.set(true, forKey: "isLogin")
    let keyChain = Keychain(service: "Roman-Vronsky.FileManager")
    private lazy var passwordTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Введите пароль"
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordButton: UIButton = {
       let button = UIButton()
//        button.setTitle("Создать пароль", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapPasswordButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        print( try! keyChain.get("password") ?? "nil")
        if chek == true {
            print("isLogin")
        } else {
            print("no Login")
        }
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if chek == true {
            self.passwordButton.setTitle("Введите пароль", for: .normal)
        } else {
            self.passwordButton.setTitle("Создать пароль", for: .normal)
        }
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.passwordTextField)
        self.view.addSubview(self.passwordButton)
       
        
        NSLayoutConstraint.activate([
        
            self.passwordTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.passwordTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            self.passwordTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            self.passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            self.passwordButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 16),
            self.passwordButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            self.passwordButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            self.passwordButton.heightAnchor.constraint(equalToConstant: 50),
            
            
           
        
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
       
        guard passwordTextField.text != "" else { return showAlert(title: "Ошибка!", message: "Введите пароль") {
            self.passwordTextField.becomeFirstResponder()
        }}
        guard passwordTextField.text!.count  >= 4 else { return showAlert(title: "Короткий пароль", message: "Пароль должен состоять минимум из 4 символов") {
            self.passwordTextField.becomeFirstResponder()
        }}
        
        if chek == true {
           signIn()
            print("isLogin")
           } else if chek == false {
               print("no login")
            keyChain["password"] = passwordTextField.text
               chek.toggle()
            showAlert(title: "Пароль создан", message: "Повторите ввод пароля") {
                self.passwordTextField.text = ""
                self.passwordTextField.becomeFirstResponder()
                self.passwordButton.setTitle("Повторите пароль", for: .normal)
            }
        }
    }
    
    private func signIn() {
//        var chek = UserDefaults.standard.bool(forKey: "isLogin")
        let password = try? keyChain.get("password")
        if password == passwordTextField.text {
            self.navigationController?.pushViewController(DocViewController(), animated: true)
            
        } else {
            showAlert(title: "Ошибка!", message: "Неверный пароль. Пароль сброшен. Придумайте новый пароль"){
                self.keyChain["password"] = nil
                self.chek.toggle()
                self.passwordTextField.text = ""
                self.passwordTextField.becomeFirstResponder()
                self.passwordButton.setTitle("Создать пароль", for: .normal)
                
            }
        }
    }
}
