//
//  UserTableViewCell.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 7.06.2024.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    
    func configureC(user: User) {
        
        usernameLabel.text = user.username
        statusLabel.text = user.status
        setAvatar(avatarLink: user.avatarLink)
        
    }
    
    private func setAvatar(avatarLink: String) {
        
        if avatarLink != "" {
            FileStorage.downloadImage(imageUrl: avatarLink) { (avatarImage) in
                self.avatarImageView.image = avatarImage?.circleMasked
            }
        }else {
            self.avatarImageView.image = UIImage(named: "avatar")?.circleMasked
        }
        
    }
    
}
