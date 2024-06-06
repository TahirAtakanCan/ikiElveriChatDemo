//
//  EditProfileTableViewController.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 5.06.2024.
//

import UIKit
import YPImagePicker
import Toast


class EditProfileTableViewController: UITableViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    //MARK: - Vars
    //var uploadAvatarImage: YPImagePicker!
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        configureTextField()
        
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 30.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 0 {
            //print("show status")
            performSegue(withIdentifier: "editProfileToStatusSeg", sender: self)
        }
    }
    
    
    //MARK: - IBActions
    
    @IBAction func editButtonPressed(_ sender: Any) {
        showImagePicker()
    }
    
    //MARK: - UpdateUI
    private func showUserInfo(){
        
        if let user = User.currentUser {
            usernameTextField.text = user.username
            statusLabel.text = user.status
            
            if user.avatarLink != "" {
                //set avatar
                FileStorage.downloadImage(imageUrl: user.avatarLink) { (avatarImage) in
                    self.avatarImageView.image = avatarImage?.circleMasked
                }
            }
        }
        
    }
    
    //MARK: - Configure
    
    private func configureTextField() {
        usernameTextField.delegate = self
        usernameTextField.clearButtonMode = .whileEditing
    }
    
    //MARK: - YPImagePicker
    func showImagePicker() {
        var config = YPImagePickerConfiguration()
        config.screens = [.library, .photo]
        config.library.mediaType = .photo
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.uploadAvatarImage(photo.image)
                self.avatarImageView.image = photo.image.circleMasked
            } else {
                //ProgressHUD.showError("Couldn't select image!")
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    private func uploadAvatarImage(_ image: UIImage) {
            
        let fileDictionary = "Avatars/" + "_\(User.currentId)" + ".jpg"
        
        FileStorage.uploadImage(image, directory: fileDictionary) { (avatarLink) in
            
            if var user = User.currentUser {
                user.avatarLink = avatarLink ?? ""
                saveUserLocally(user)
                FirebaseUserListener.shared.saveUserToFireStore(user)
            }
            FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 1.0)! as NSData, fileName: User.currentId)
            
        }
        
            print("Uploading avatar image...")
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



