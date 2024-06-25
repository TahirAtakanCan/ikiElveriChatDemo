//
//  ChannelTableViewController.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 25.06.2024.
//

import UIKit

class ChannelTableViewController: UITableViewController {

    
    //MARK: - IBActions
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var aboutTextView: UITextView!
    
    
    //MARK: - Vars
    var channel: Channel!
    
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        showChannelData()
    }
    
    
    //MARK: - Configure
    private func showChannelData() {
        self.title = channel.name
        nameLabel.text = channel.name
        membersLabel.text = "\(channel.memberIds.count) Members"
        aboutTextView.text = channel.aboutChannel
        setAvatar(avatarLink: channel.avatarLink)
    }
    
    private func setAvatar(avatarLink: String) {
        print("avatar link is ",avatarLink )
        if avatarLink != "" {
            FileStorage.downloadImage(imageUrl: avatarLink) { (avatarImage) in
                
                DispatchQueue.main.async {
                    self.avatarImageView.image = avatarImage != nil ? avatarImage?.circleMasked : UIImage(named:"avatar")
                }
            }
        } else {
            self.avatarImageView.image = UIImage(named: "avatar")
        }
    }

}
