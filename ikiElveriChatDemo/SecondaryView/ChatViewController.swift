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


    }
    



}
