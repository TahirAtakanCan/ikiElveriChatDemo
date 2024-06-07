//
//  ViewController.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 3.06.2024.
//

import UIKit
import ProgressHUD
import Toast

class LoginViewController: UIViewController {

    //MARK: - IBOutlets
    //labels
    @IBOutlet weak var emailLabelOutlet: UILabel!
    
    @IBOutlet weak var passwordLabelOutlet: UILabel!
    
    @IBOutlet weak var repeatPasswordLabel: UILabel!
    
    @IBOutlet weak var signUpLabel: UILabel!
    //textfields
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    //Buttons
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    
    @IBOutlet weak var resendEmailButtonOutlet: UIButton!
    
    
    //Views
    @IBOutlet var repeatPasswordLineView: UIView!
    
    
    //MARK: -Vars
    
    var isLogin = true
    
    //Mar: -View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFieldDelegates()
        updateIUFor(login: true)
        setupBackroundTap()
    }
    
    //MARK: - IBActions
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if isDataInputedFor(type: isLogin ? "Login" : "Register"){
            //login or register
            //print("have data for login/reg")
            isLogin ? loginUser(): registerUser()
        }else {
            view.makeToast("All Fields are required", duration: 3, position: .center)
        }
    }
    
    @IBAction func forgetPasswordButtonPressed(_ sender: Any) {
        
        if isDataInputedFor(type: "password"){
          resetPassword()
        }else {
            view.makeToast("All Fields are required", duration: 3, position: .center)
        }
        
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        
        if isDataInputedFor(type: "password"){
            resendVerificationEmail()
        }else {
            view.makeToast("All Fields are required", duration: 3, position: .center)
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        updateIUFor(login: sender.titleLabel?.text == "Login")
        isLogin.toggle()
    }
    
    
    //MARK: - Setup
    
    private func setupTextFieldDelegates() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        repeatPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        //print("tapped")
        updatePlaceholderLabels(textField: textField)
    }
    
    
    private func setupBackroundTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backroundTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backroundTap() {
        //print("backround Tap")
        view.endEditing(false)
    }
    
    //MARK: - Animations
    
    
    private func updateIUFor(login: Bool) {
        loginButtonOutlet.setImage(UIImage(named: login ? "loginBtn" : "registerBtn"), for: .normal)
        signUpButtonOutlet.setTitle(login ? "SignUp" : "Login", for: .normal)
        
        signUpLabel.text = login ? "Don't have an account?" : "Have an account ? "
        
        UIView.animate(withDuration: 0.5) {
            self.repeatPasswordLabel.isHidden = login
            self.repeatPasswordTextField.isHidden = login
            //self.repeatPasswordLineView.isHidden = login
        }
    }
    
    private func updatePlaceholderLabels(textField: UITextField) {
        
        switch textField {
        case emailTextField:
            emailLabelOutlet.text = textField.hasText ? "Email" : ""
        case passwordTextField:
            passwordLabelOutlet.text = textField.hasText ? "Password" : ""
        default:
            repeatPasswordLabel.text = textField.hasText ? "Password" : ""
        }
    }
    
    
    //MARK: - Helpers
    private func isDataInputedFor(type: String) -> Bool {
        
        switch type {
        case "login":
            return emailTextField.text != "" && passwordTextField.text != ""
        case "registration":
            return emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != ""
        default:
            return emailTextField.text != ""
        }
        
    }
    
    private func loginUser() {
        FirebaseUserListener.shared.loginUserWithEmail(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
            
            if error == nil {
                if isEmailVerified {
                    self.goToApp()
                    //print("User has logged in with email", User.currentUser?.email)
                }else {
                    self.view.makeToast("Please verify email.", duration: 2, position: .bottom)
                    self.resendEmailButtonOutlet.isHidden = false
                }
            }else {
                self.view.makeToast(error?.localizedDescription)
            }
            
        }
        
    }
    
    private func registerUser() {
        
        if passwordTextField.text! == repeatPasswordTextField.text! {
            
            FirebaseUserListener.shared.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
                if error == nil {
                    self.view.makeToast("Verification email sent", duration: 2, position: .bottom)
                    self.resendEmailButtonOutlet.isHidden = false
                }else {
                    self.view.makeToast(error!.localizedDescription, duration: 1, position: .bottom)
                }
            }
            
        }else {
            view.makeToast("The password don't match", duration: 3, position: .center)
        }
    }
    
    
    private func resetPassword(){
        
        FirebaseUserListener.shared.resetPasswordFor(email: emailTextField.text!) { (error) in
            
            if error == nil {
                self.view.makeToast("Resent link sent to email", duration: 2, position: .bottom)
            }else {
                //again
                self.view.makeToast(error?.localizedDescription)
            }
            
        }
        
    }
    
    private func resendVerificationEmail() {
        FirebaseUserListener.shared.resendVerificationEmail(email: emailTextField.text!) { (error) in
            if error == nil {
                self.view.makeToast("New Verification email sent.", duration: 2, position: .bottom)
            }else {
                //again
                self.view.makeToast(error?.localizedDescription)
            }
        }
    }
    
    //MARK: - Navigation
    private func goToApp() {
            
            let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainView") as! UITabBarController
            
            mainView.modalPresentationStyle = .fullScreen
            self.present(mainView, animated: true, completion: nil)
        }

}

