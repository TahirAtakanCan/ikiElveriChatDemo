//
//  ChatViewController.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 9.06.2024.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import YPImagePicker
import RealmSwift

class ChatViewController: MessagesViewController {
    
    //MARK: - Vars
    private var chatId = ""
    private var recipientId = ""
    private var recipientName = ""
    
    let currentUser = MKSender(senderId: User.currentId, displayName: User.currentUser!.username)
    
    let refreshController = UIRefreshControl()
    
    let micButton = InputBarButtonItem()
    
    var mkMessages: [MKMessage] = []
    var allLocalMessages: Results<LocalMessage>!
    
    let realm = try! Realm()
    
    //Listeners
    var notificationToken: NotificationToken?
    
    //MARK: - Inits
    init(chatId: String = "", recipientId: String = "", recipientName: String = "") {
        
        super.init(nibName: nil, bundle: nil)
        
        self.chatId = chatId
        self.recipientId = recipientId
        self.recipientName = recipientName
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureMessageCollectionView()
        configureMessageInputBar()
        
        loadChats()
    }
    
    
    //MARK: - Configurations
    private func configureMessageCollectionView(){
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        maintainPositionOnInputBarHeightChanged = true
        scrollsToLastItemOnKeyboardBeginsEditing = true
        
        messagesCollectionView.refreshControl = refreshController
        
    }
    
    private func configureMessageInputBar(){
        
        messageInputBar.delegate = self
        
        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        
        attachButton.onTouchUpInside { item in
            
            print("attach button pressed")
        }
        micButton.image = UIImage(systemName: "mic.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        micButton.setSize(CGSize(width: 30, height: 30), animated: false)
        
        //add gesture recognizer
        
        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
        
    }
    
    //MARK: - Load Chats
    private func loadChats(){
        
        let predicate = NSPredicate(format: "chatRoomId = %@", chatId)
        
        allLocalMessages = realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: kDATE, ascending: true)
        
        //print("we have \(allLocalMessages.count) messages")
        
        notificationToken = allLocalMessages.observe({ (changes: RealmCollectionChange) in
            
            switch changes {
            case .initial:
                print("we have \(self.allLocalMessages.count) messages")
            case .update(_, _, let insertions, _):
                for index in insertions {
                    print("new message \(self.allLocalMessages[index].message)")
                }
            case .error(let error):
                print("Error on new insertion", error.localizedDescription)
            }
            
        })
        
    }


    //MARK: - Actions
    
    func messageSend(text: String?, photo: UIImage?, video: String?, audio: String?, location: String?, audioDuration: Float = 0.0) {
        //print("sending text", text)
        
        OutgoingMessage.send(chatId: chatId, text: text, photo: photo, video: video, audio: audio, location: location, memberIds: [User.currentId,recipientId])
    }
    
}
