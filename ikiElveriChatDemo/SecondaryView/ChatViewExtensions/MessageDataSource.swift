//
//  MessageDataSource.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 12.06.2024.
//

import Foundation
import MessageKit
import UIKit

extension ChatViewController: MessagesDataSource {
    
    var currentSender: SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return mkMessages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return mkMessages.count
    }
    
    //MARK: - Cell top Labels
    func cellTopLabelAttributedText(for message: any MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if indexPath.section % 3==0 {
            
            let showLoadMore = (indexPath.section == 0) && (allLocalMessages.count > displayingMessagesCount)
            let text = showLoadMore ? "Pull to load more" : MessageKitDateFormatter.shared.string(from: message.sentDate)
            let font = showLoadMore ? UIFont.systemFont(ofSize: 13) : UIFont.boldSystemFont(ofSize: 10)
            let color = showLoadMore ? UIColor.systemBlue : UIColor.darkGray
            
            return NSAttributedString(string: text, attributes: [.font : font, .foregroundColor : color])
        }
        return nil
    }
    
    //Cell bottom label
    
    func cellBottomLabelAttributedText(for message: any MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if isFromCurrentSender(message: message) {
            let message = mkMessages[indexPath.section]
            let status = indexPath.section == mkMessages.count - 1 ? message.status + "" + message.readDate.time() : ""
            
            
            return NSAttributedString(string: status, attributes: [.font : UIFont.boldSystemFont(ofSize: 10), .foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    //Message bottom Label
    func messageBottomLabelAttributedText(for message: any MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section != mkMessages.count - 1 {

            return NSAttributedString(string: message.sentDate.time(), attributes: [.font : UIFont.boldSystemFont(ofSize: 10), .foregroundColor : UIColor.darkGray])
            
        }
        return nil
    }
    
    
}

extension ChannelChatViewController: MessagesDataSource {
    
    var currentSender: SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return mkMessages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return mkMessages.count
    }
    
    //MARK: - Cell top Labels
    func cellTopLabelAttributedText(for message: any MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if indexPath.section % 3==0 {
            
            let showLoadMore = (indexPath.section == 0) && (allLocalMessages.count > displayingMessagesCount)
            let text = showLoadMore ? "Pull to load more" : MessageKitDateFormatter.shared.string(from: message.sentDate)
            let font = showLoadMore ? UIFont.systemFont(ofSize: 13) : UIFont.boldSystemFont(ofSize: 10)
            let color = showLoadMore ? UIColor.systemBlue : UIColor.darkGray
            
            return NSAttributedString(string: text, attributes: [.font : font, .foregroundColor : color])
        }
        return nil
    }
    
    //Message bottom Label
    func messageBottomLabelAttributedText(for message: any MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(string: message.sentDate.time(),attributes: [.font : UIFont.boldSystemFont(ofSize: 10), .foregroundColor : UIColor.darkGray])
    }
    
    
}
