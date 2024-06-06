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
    @IBOutlet weak var appVerisonLabel: UILabel!
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showUserInfo()
    }
    
    
    //MARK: - TableView Delegates
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgroundColor")
        
        return headerView
    }
    //Düzenleme
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 5.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            performSegue(withIdentifier: "settingsToEditProfileSeg", sender: self)
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func tellAFriendsButtonPressed(_ sender: Any) {
        print("Tell a friend")
    }
    @IBAction func termAndConditionsButtonPressed(_ sender: Any) {
        print("show t&C")
    }
    @IBAction func logOutButtonPressed(_ sender: Any) {
        //print("log Out")
        
        FirebaseUserListener.shared.logOutCurrentUser {(error ) in
            
            if error == nil {
                
                let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
                
                DispatchQueue.main.async {
                    loginView.modalPresentationStyle = .fullScreen
                    self.present(loginView,animated: true,completion: nil)
                }
            }
        }
    }
    

    //MARK: - UpdateUI
    private func showUserInfo(){
        
        if let user = User.currentUser {
            usernameLabel.text = user.username
            statusLabel.text = user.status
            appVerisonLabel.text = "App Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
            
            if user.avatarLink != "" {
                //download avatar
                FileStorage.downloadImage(imageUrl: user.avatarLink) { (avatarImage) in
                    self.avatarImageView.image = avatarImage?.circleMasked
                }
            }
        }
        
    }
    
    
}
