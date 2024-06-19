//
//  OutgoingMessage.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 12.06.2024.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift

class OutgoingMessage {
    
    class func send(chatId: String, text: String?, photo: UIImage?, video: String?, audio: String?, audioDuration: Float = 0.0, location: String?, memberIds: [String]) {
        
        let currentUser = User.currentUser!
        
        let message = LocalMessage()
        message.id = UUID().uuidString
        message.chatRoomId = chatId
        message.senderId = currentUser.id
        message.senderName = currentUser.username
        message.senderinitials = String(currentUser.username.first!)
        message.date = Date()
        message.status = kSENT
        
        if text != nil {
            sendTextMessage(message: message, text: text!, memberIds: memberIds)
        }
        
        if photo != nil {
            sendPictureMessage(message: message, photo: photo!, memberIds: memberIds)
        }
        
        FirebaseRecentListener.shared.updateRecents(chatRoomId: chatId, lastMessage: message.message)
    }
    
    class func sendMessage(message: LocalMessage, memberIds: [String]) {
        
        RealmManager.shared.saveToRealm(message)
        
        for memberId in memberIds {
            //print("save message for \(memberId)")
            FirebaseMessageListener.shared.addMessage(message,memberId:memberId)
        }
    }
}


        func sendTextMessage(message: LocalMessage, text: String, memberIds: [String]) {
    
        message.message = text
        message.type = kTEXT
        OutgoingMessage.sendMessage(message: message, memberIds: memberIds)
    }

func sendPictureMessage(message: LocalMessage, photo: UIImage, memberIds: [String]) {
    print("sending picture message")
    message.message = "Picture Message"
    message.type = kPHOTO

    let fileName = Date().stringDate()
    let fileDirectory = "MediaMessages/Photo/" + "\(message.chatRoomId)/" + "_\(fileName)" + ".jpg"
    
    FileStorage.saveFileLocally(fileData: photo.jpegData(compressionQuality: 0.6)! as NSData, fileName: fileName)
    
    FileStorage.uploadImage(photo, directory: fileDirectory) { (imageURL) in
        if let imageURL = imageURL {
            message.pictureUrl = imageURL
            print("Image URL: \(imageURL)") // Bu satırı ekleyin
            OutgoingMessage.sendMessage(message: message, memberIds: memberIds)
        } else {
            print("Image URL is nil") // Bu satırı ekleyin
        }
    }
}



