//
//  AddChannelTableViewController.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 25.06.2024.
//

import UIKit
import YPImagePicker
import Toast

class AddChannelTableViewController: UITableViewController {

    //MARK: - IBOutlet
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var aboutTextView: UITextView!
    
    //MARK: - Vars
    var gallery: YPImagePicker!
    var tapGesture = UITapGestureRecognizer()
    var avatarLink = ""
    var channelId = UUID().uuidString
    
    var channelToEdit: Channel?
    
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        
        configureGestures()
        configureLeftBarButton()
        
        if channelToEdit != nil {
            configureEditingView()
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if nameTextField.text != "" {
                    
            channelToEdit != nil ? editChannel() : saveChannel()
        } else {
            self.view.makeToast("Channel name is empty!")
        }
    }
    
    
    @objc func avatarImageTap() {
            showGallery()
        }
        
        @objc func backButtonPressed() {
            self.navigationController?.popViewController(animated: true)
        }
        
        //MARK: - Configuration
        private func configureGestures() {
            tapGesture.addTarget(self, action: #selector(avatarImageTap))
            avatarImageView.isUserInteractionEnabled = true
            avatarImageView.addGestureRecognizer(tapGesture)
        }
        
        private func configureLeftBarButton() {
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonPressed))
        }
        
        private func configureEditingView() {
            self.nameTextField.text = channelToEdit!.name
            self.channelId = channelToEdit!.id
            self.aboutTextView.text = channelToEdit!.aboutChannel
            self.avatarLink = channelToEdit!.avatarLink
            self.title = "Editing Channel"
            
            setAvatar(avatarLink: channelToEdit!.avatarLink)
        }
        
        
        //MARK: - Save Channel
        private func saveChannel() {
            
            let channel = Channel(id: channelId, name: nameTextField.text!, adminId: User.currentId, memberIds: [User.currentId], avatarLink: avatarLink, aboutChannel: aboutTextView.text)
            
            FirebaseChannelListener.shared.saveCannel(channel)
            
            self.navigationController?.popViewController(animated: true)
        }

        private func editChannel() {
            
            channelToEdit!.name = nameTextField.text!
            channelToEdit!.aboutChannel = aboutTextView.text
            channelToEdit!.avatarLink = avatarLink
            
            FirebaseChannelListener.shared.saveCannel(channelToEdit!)
            self.navigationController?.popViewController(animated: true)
        }

        
        //MARK: - Gallery
        private func showGallery() {
            
            var config = YPImagePickerConfiguration()
            config.screens = [.library, .photo]
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            picker.didFinishPicking { [unowned picker] items, _ in
                if let photo = items.singlePhoto {
                    self.uploadAvatarImage(photo.image)
                    self.avatarImageView.image = photo.image.circleMasked
                }
                picker.dismiss(animated: true, completion: nil)
            }
            present(picker, animated: true, completion: nil)
        }

        //MARK: - Avatars
        private func uploadAvatarImage(_ image: UIImage) {
            
            let fileDirectory = "Avatars/" + "_\(channelId)" + ".jpg"
            
            FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 0.7)! as NSData, fileName: self.channelId)

            
            FileStorage.uploadImage(image, directory: fileDirectory) { (avatarLink) in
                
                self.avatarLink = avatarLink ?? ""
            }
        }


        private func setAvatar(avatarLink: String) {
            
            if avatarLink != "" {
                FileStorage.downloadImage(imageUrl: avatarLink) { (avatarImage) in
                    
                    DispatchQueue.main.async {
                        self.avatarImageView.image = avatarImage?.circleMasked
                    }
                }
            } else {
                self.avatarImageView.image = UIImage(named: "avatar")
            }
        }
    
    
}
