//
//  MessageLayoutDelegate.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 12.06.2024.
//

import Foundation
import MessageKit

extension ChatViewController : MessagesLayoutDelegate {
    
    //MARK: - Cell top Label
    
    func cellTopLabelHeight(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        if indexPath.section % 3==0 {
            
            if ((indexPath.section == 0) && (allLocalMessages.count > displayingMessagesCount)) {
                return 40
            }
            return 18
        }
        return 0
    }
    
    
    func cellBottomLabelHeight(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return isFromCurrentSender(message: message) ? 17 : 0
        
    }
    
    //MARK: - Message Bottom Label
    func messageBottomLabelHeight(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return indexPath.section != mkMessages.count - 1 ? 10 : 0
        
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        avatarView.set(avatar: Avatar(initials: mkMessages[indexPath.section].senderInitials))
    }
    
}


extension ChannelChatViewController: MessagesLayoutDelegate {
    
    //MARK: - Cell top Label
    
    func cellTopLabelHeight(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        if indexPath.section % 3==0 {
            
            if ((indexPath.section == 0) && (allLocalMessages.count > displayingMessagesCount)) {
                return 40
            }
            return 18
        }
        return 0
    }
    
    /*
    func cellBottomLabelHeight(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return isFromCurrentSender(message: message) ? 17 : 0
        
    }
    */
    
    //MARK: - Message Bottom Label
    func messageBottomLabelHeight(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return indexPath.section != mkMessages.count - 1 ? 10 : 0
        
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        avatarView.set(avatar: Avatar(initials: mkMessages[indexPath.section].senderInitials))
    }
}
