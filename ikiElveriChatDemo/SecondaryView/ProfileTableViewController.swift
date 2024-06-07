//
//  ProfileTableViewController.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 7.06.2024.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    //MARK: - IBOutlets
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    //MARK: - Vars
    var user: User?
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        
        setupUI()
    }
    
    
    //MARK: - TableView Delegates
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgroundColor")
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            print("Start Chatting")
            
        }
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        
        if user != nil {
            self.title = user!.username
            userNameLabel.text = user!.username
            statusLabel.text = user!.status
            
            if user!.avatarLink != "" {
                FileStorage.downloadImage(imageUrl: user!.avatarLink) { (avatarImage) in
                    
                    self.avatarImageView.image = avatarImage?.circleMasked
                }
            }
        }
        
    }
    
}

