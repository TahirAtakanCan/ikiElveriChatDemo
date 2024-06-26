//
//  ChannelChatViewController.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 26.06.2024.
//

import Foundation
import MessageKit
import InputBarAccessoryView
import YPImagePicker
import RealmSwift
import AVFoundation
import UIKit


class ChannelChatViewController: MessagesViewController {
    
    
    //MARK: - Vars
    private var chatId = ""
    private var recipientId = ""
    private var recipientName = ""
    
    var channel: Channel!
    
    open lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)
    
    let currentUser = MKSender(senderId: User.currentId, displayName: User.currentUser!.username)
    
    let refreshController = UIRefreshControl()
    
    let micButton = InputBarButtonItem()
    
    var mkMessages: [MKMessage] = []
    var allLocalMessages: Results<LocalMessage>!
    
    let realm = try! Realm()
    
    var displayingMessagesCount = 0
    var maxMessageNumber = 0
    var minMessageNumber = 0
    
    
    
    var gallery: YPImagePicker!
    //Listeners
    var notificationToken: NotificationToken?
    
    var longPressGesture: UILongPressGestureRecognizer!
    var audioFileName = ""
    var audioDuration: Date!
    
    //MARK: - Inits
    init(channel: Channel) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.chatId = channel.id
        self.recipientId = channel.id
        self.recipientName = channel.name
        self.channel = channel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        //self.title = recipientName
        
        
        
        configureMessageCollectionView()
        configureGestureRecognizer()
        configureMessageInputBar()
        
        configureLeftBarButton()
        configureCustomTitle()

        
        loadChats()
        listenForNewChats()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FirebaseRecentListener.shared.resetRecentCounter(chatRoomId: chatId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        FirebaseRecentListener.shared.resetRecentCounter(chatRoomId: chatId)
        audioController.stopAnyOngoingPlaying()
    }
    
    
    //MARK: - Configurations
    private func configureMessageCollectionView(){
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        //maintainPositionOnInputBarHeightChanged = true
        //scrollsToLastItemOnKeyboardBeginsEditing = true
        
        messagesCollectionView.refreshControl = refreshController
        
    }
    
    private func configureGestureRecognizer() {
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(recordAudio))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delaysTouchesBegan = true
    }
    
    
    private func configureMessageInputBar(){
        
        messageInputBar.isHidden = channel.adminId != User.currentId
        
        messageInputBar.delegate = self
        
        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        
        attachButton.onTouchUpInside { item in
            
            self.actionAttachMessage()
        }
        micButton.image = UIImage(systemName: "mic.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        micButton.setSize(CGSize(width: 30, height: 30), animated: false)
        
        //add gesture recognizer
        micButton.addGestureRecognizer(longPressGesture)
        
        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        
        updateMicButtonStatus(show: true)
        
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
        
    }
    
    func updateMicButtonStatus(show : Bool) {
        
        if show {
            messageInputBar.setStackViewItems([micButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
        }else {
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 55, animated: false)
        }
    }
    
    private func configureLeftBarButton(){
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image:UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backButtonPressed))]
    }
    
    private func configureCustomTitle(){
       
        self.title = channel.name
    }
    
    //MARK: - Load Chats
    private func loadChats(){
        
        let predicate = NSPredicate(format: "chatRoomId = %@", chatId)
        allLocalMessages = realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: kDATE, ascending: true)
        
        //print("we have \(allLocalMessages.count) messages")  // Eklenen debug print
        if allLocalMessages.isEmpty {
            checkForOldChats()
        }
        
        notificationToken = allLocalMessages.observe({ (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self.insertMessages()
                self.messagesCollectionView.reloadData()
                //print("we have \(self.allLocalMessages.count) messages")  // Eklenen debug print
            case .update(_, _, let insertions, _):
                for index in insertions {
                    //print("new message \(self.allLocalMessages[index].message)")  // Eklenen debug print
                    self.insertMessage(self.allLocalMessages[index])
                    self.messagesCollectionView.reloadData()
                }
            case .error(let error):
                print("Error on new insertion", error.localizedDescription)
            }
        })
    }
    
    private func listenForNewChats(){
        FirebaseMessageListener.shared.listenForNewChats(User.currentId, collectionId: chatId, lastMessageDate: lastMessageDate())
    }
    
    private func checkForOldChats(){
        FirebaseMessageListener.shared.checkForOldChats(User.currentId, collectionId: chatId)
    }
    
    

    //MARK: - Insert Messages
    private func insertMessages() {
        
        maxMessageNumber = allLocalMessages.count - displayingMessagesCount
        minMessageNumber = maxMessageNumber - kNUMBEROFMESSAGES
        
        if minMessageNumber < 0 {
            minMessageNumber = 0
        }
        
        for i in minMessageNumber ..< maxMessageNumber {
            insertMessage(allLocalMessages[i])
        }
    }
    
    private func insertMessage(_ localMessage: LocalMessage) {
        //print("inserted message: \(localMessage.message)")  // Eklenen debug print
       
        let incoming = InComingMessage(_collectionView: self)
        self.mkMessages.append(incoming.createMessage(localMessage: localMessage)!)
        displayingMessagesCount += 1
        
    }
    
    private func loadMoreMessages(maxNumber: Int, minNumber: Int) {
        
        maxMessageNumber = minNumber - 1
        minMessageNumber = maxMessageNumber - kNUMBEROFMESSAGES
        
        if minMessageNumber < 0 {
            minMessageNumber = 0
        }
        
        for i in (minMessageNumber ... maxMessageNumber).reversed() {
            insertOlderMessage(allLocalMessages[i])
        }
        
        
    }
    
    private func insertOlderMessage(_ localMessage: LocalMessage) {
        print("inserted message: \(localMessage.message)")  // Eklenen debug print
        let incoming = InComingMessage(_collectionView: self)
        self.mkMessages.insert(incoming.createMessage(localMessage: localMessage)!, at: 0)
        displayingMessagesCount += 1
        
    }

    //MARK: - Actions
    
    func messageSend(text: String?, photo: UIImage?, video: Video?, audio: String?, location: String?, audioDuration: Float = 0.0) {
            print("Photo: \(String(describing: photo))")
            OutgoingMessage.send(chatId: chatId, text: text, photo: photo, video: video, audio: audio, audioDuration: audioDuration, location: location, memberIds: [User.currentId, recipientId])
        }
    
    @objc func backButtonPressed(){
        FirebaseRecentListener.shared.resetRecentCounter(chatRoomId: chatId)
        removeListeners()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func actionAttachMessage(){
        
        messageInputBar.inputTextView.resignFirstResponder()
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoOrVideo = UIAlertAction(title: "Camera", style: .default) { (alert) in
            self.showImageGallery(camera: true)
            print("show camera")
        }
        
        let shareMedia = UIAlertAction(title: "Library", style: .default) { (alert) in
            self.showImageGallery(camera: false)
            print("show library")
        }
        
        let shareLocation = UIAlertAction(title: "Location", style: .default) { (alert) in
            if let _ = LocationManager.shared.currentLocation {
                self.messageSend(text: nil, photo: nil, video: nil, audio: nil, location: kLOCATION)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        takePhotoOrVideo.setValue(UIImage(systemName: "camera"), forKey: "image")
        shareMedia.setValue(UIImage(systemName: "photo.fill"), forKey: "image")
        shareLocation.setValue(UIImage(systemName: "mappin.and.ellipse"), forKey: "image")
        
        
        optionMenu.addAction(takePhotoOrVideo)
        optionMenu.addAction(shareMedia)
        optionMenu.addAction(shareLocation)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    //MARK: - UIScrollViewDelegate
    override func scrollViewDidEndDecelerating(_: UIScrollView) {
        
        if refreshController.isRefreshing {
            if displayingMessagesCount < allLocalMessages.count {
                //load earlear messages
                self.loadMoreMessages(maxNumber: maxMessageNumber, minNumber: minMessageNumber)
                messagesCollectionView.reloadDataAndKeepOffset()
            }
            
            refreshController.endRefreshing()
        }
    }
    
    
    
    //MARK: - Helpers
    
    private func removeListeners() {
        
        FirebaseMessageListener.shared.removeListeners()
        
    }
    
    private func lastMessageDate() -> Date {
        
        let lastMessageDate = allLocalMessages.last?.date ?? Date()
        return Calendar.current.date(byAdding: .second, value: 1, to: lastMessageDate) ?? lastMessageDate
        
    }
    
    //MARK: - Gallery
    private func showImageGallery(camera: Bool) {
        var config = YPImagePickerConfiguration()
        
        
        config.screens = camera ? [.photo] : [.library, .photo, .video]
        
        
        config.library.mediaType = .photoAndVideo
        
        
        config.library.maxNumberOfItems = 1

        
        config.startOnScreen = .library

        
        config.video.libraryTimeLimit = 30.0
        config.video.compression = AVAssetExportPresetHighestQuality

        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
                return
            }
            
            for item in items {
                switch item {
                case .photo(let photo):
                    print("Picked photo: \(photo.image)")
                    self.messageSend(text: nil, photo: photo.image, video: nil, audio: nil, location: nil)
                case .video(let video):
                    print("Picked video: \(video.url)")
                    let videoItem = Video(url: video.url)
                    self.messageSend(text: nil, photo: nil, video: videoItem, audio: nil, location: nil)
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }

        self.present(picker, animated: true, completion: nil)
    }
    
    //MARK: - AudioMessages
    @objc func recordAudio(){
        
        switch longPressGesture.state {
        case .began:
            audioDuration = Date()
            audioFileName = Date().stringDate()
            //start recording
            AudioRecorder.shared.startRecording(fileName: audioFileName)
        case .ended:
            
            //stop recording
            AudioRecorder.shared.finishRecording()
            
            if fileExistsAtPath(path: audioFileName + ".m4a") {
                
                let audioD = audioDuration.interval(ofComponent: .second, from: Date())
                //send message
                messageSend(text: nil, photo: nil, video: nil, audio: audioFileName, location: nil, audioDuration: audioD)
                
            }else{
                print("no audio file")
            }
            
            audioFileName = ""
        @unknown default:
            print("unknown")
        }
        
    }
}

extension ChannelChatViewController {
    func presentImagePicker() {
        showImageGallery(camera: false)
    }
    
    func presentCamera() {
        showImageGallery(camera: true)
    }
}
