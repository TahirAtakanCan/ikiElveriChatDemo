//
//  SettingsTableViewController.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 5.06.2024.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    
    //MARK: - IBOutlets
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showUserInfo()
    }
    
    
    //MARK: - IBActions
    
    @IBAction func tellAFriendsButtonPressed(_ sender: Any) {
        print("Tell a friend")
    }
    @IBAction func termAndConditionsButtonPressed(_ sender: Any) {
        print("show t&C")
    }
    @IBAction func logOutButtonPressed(_ sender: Any) {
        print("log Out")
    }
    

    //MARK: - UpdateUI
    private func showUserInfo(){
        
        if let user = User.currentUser {
            usernameLabel.text = user.username
            statusLabel.text = user.status
            
            if user.avatarLink != "" {
                //download avatar
            }
        }
        
    }
    
    
}
