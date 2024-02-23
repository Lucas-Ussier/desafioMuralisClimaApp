//
//  LoginViewController.swift
//  desafioMuralisClimaApp
//
//  Created by Lucas Galvao on 17/02/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    var network: NetworkServices = NetworkServices.shared
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.senhaTextField.isSecureTextEntry = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.senhaTextField.text = ""
        self.emailTextField.text = ""
        self.loginButton.isHidden = false
        self.loginActivityIndicator.isHidden = true
        self.loginActivityIndicator.stopAnimating()
    }
    
    @IBAction func loginButtonApertado(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        let password = senhaTextField.text ?? ""
        
        self.loginButton.isHidden = true
        self.loginActivityIndicator.isHidden = false
        self.loginActivityIndicator.startAnimating()
        
        self.login(username: email, password: password)
    }
    
    func login(username: String, password: String){
        if(username.isEmpty || password.isEmpty){
            Utils.errorAlert(message: "Please fill all the fields before confinue",
                             view: self) { action in
                self.loginButton.isHidden = false
                self.loginActivityIndicator.isHidden = true
            }
        }else{
            network.login(username: username, password: password)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: DispatchWorkItem(block: {
                
                if(self.network.getisError()){
                    Utils.errorAlert(message: "Internal Server Error please try again later",
                                     view: self) { action in
                        self.loginButton.isHidden = false
                        self.loginActivityIndicator.isHidden = true
                    }
                }else{
                    if(self.network.getLogin()){
                        self.performSegue(withIdentifier: "mainMenuSegue", sender: nil)
                    }else{
                        Utils.errorAlert(message: "Inavlid Credentials, review your username and/or password",
                                         view: self) { action in
                            self.loginButton.isHidden = false
                            self.loginActivityIndicator.isHidden = true
                        }
                    }
                }
            }))
        }
    }
    
    
}

