//
//  EditProfileTableViewController.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 5.06.2024.
//

import UIKit

class EditProfileTableViewController: UITableViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showUserInfo()
        configureTextField()
    }
    
    
    //MARK: - TableView Delegates
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgroundColor")
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 30.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - UpdateUI
    private func showUserInfo(){
        
        if let user = User.currentUser {
            usernameTextField.text = user.username
            statusLabel.text = user.status
            
            if user.avatarLink != "" {
                //set avatar
            }
        }
        
    }
    
    //MARK: - Configure
    
    private func configureTextField() {
        usernameTextField.delegate = self
        usernameTextField.clearButtonMode = .whileEditing
    }
}


extension EditProfileTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let textField = usernameTextField {
            
            if textField.text != "" {
                
                if var user = User.currentUser {
                    user.username = textField.text!
                    saveUserLocally(user)
                    FirebaseUserListener.shared.saveUserToFireStore(user)
                }
            }
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
}
