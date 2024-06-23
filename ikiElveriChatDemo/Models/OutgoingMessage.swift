//
//  OutgoingMessage.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 12.06.2024.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift
import AVFoundation

class OutgoingMessage {
    
    class func send(chatId: String, text: String?, photo: UIImage?, video: Video?, audio: String?, audioDuration: Float = 0.0, location: String?, memberIds: [String]) {
        
        let currentUser = User.currentUser!
        
        let message = LocalMessage()
        message.id = UUID().uuidString
        message.chatRoomId = chatId
        message.senderId = currentUser.id
        message.senderName = currentUser.username
        message.senderinitials = String(currentUser.username.first!)
        message.date = Date()
        message.status = kSENT
        
        if  text != nil {
            sendTextMessage(message: message, text: text!, memberIds: memberIds)
        }
        
        if  photo != nil {
            sendPictureMessage(message: message, photo: photo!, memberIds: memberIds)
        }
        
        if  video != nil {
            sendVideoMessage(message: message, video: video!, memberIds: memberIds)
        }
        
        if  location != nil {
            sendLocationMessage(message: message, memberIds: memberIds)
        }
        
        if audio != nil {
            sendAudioMessage(message: message, audioFileName: audio!, audioDuration: audioDuration, memberIds: memberIds)
        }
        
        FirebaseRecentListener.shared.updateRecents(chatRoomId: chatId, lastMessage: message.message)
    }
    
    class func sendMessage(message: LocalMessage, memberIds: [String]) {
        
        RealmManager.shared.saveToRealm(message)
        
        for memberId in memberIds {
            FirebaseMessageListener.shared.addMessage(message, memberId: memberId)
        }
    }
    
    class func sendTextMessage(message: LocalMessage, text: String, memberIds: [String]) {
        message.message = text
        message.type = kTEXT
        sendMessage(message: message, memberIds: memberIds)
    }

    class func sendPictureMessage(message: LocalMessage, photo: UIImage, memberIds: [String]) {
        print("sending picture message")
        message.message = "Picture Message"
        message.type = kPHOTO

        let fileName = Date().stringDate()
        let fileDirectory = "MediaMessages/Photo/" + "\(message.chatRoomId)/" + "_\(fileName)" + ".jpg"
        
        FileStorage.saveFileLocally(fileData: photo.jpegData(compressionQuality: 0.6)! as NSData, fileName: fileName)
        
        FileStorage.uploadImage(photo, directory: fileDirectory) { (imageURL) in
            if let imageURL = imageURL {
                message.pictureUrl = imageURL
                print("Image URL: \(imageURL)")
                sendMessage(message: message, memberIds: memberIds)
            } else {
                print("Image URL is nil")
            }
        }
    }

    class func sendVideoMessage(message: LocalMessage, video: Video, memberIds: [String]) {
        message.message = "Video Message"
        message.type = kVIDEO
        
        let fileName = Date().stringDate()
        let thumbnailDirectory = "MediaMessages/Photo/" + "\(message.chatRoomId)/" + "_\(fileName)" + ".jpg"
        let videoDirectory = "MediaMessages/Photo/" + "\(message.chatRoomId)/" + "_\(fileName)" + ".mov"
        
        let editor = VideoEditor()
        
        editor.process(video: video) { (processedVideo, videoUrl) in
            if let tempPath = videoUrl {
                let thumbnail = videoThumbnail(video: tempPath)
                
                FileStorage.saveFileLocally(fileData: thumbnail.jpegData(compressionQuality: 0.7)! as NSData, fileName: fileName)
                
                FileStorage.uploadImage(thumbnail, directory: thumbnailDirectory) { (imageLink) in
                    if let imageLink = imageLink {
                        let videoData = NSData(contentsOf: tempPath)
                        
                        FileStorage.saveFileLocally(fileData: videoData!, fileName: fileName + ".mov")
                        
                        FileStorage.uploadVideo(videoData!, directory: videoDirectory) { (videoLink) in
                            message.pictureUrl = imageLink
                            message.videoUrl = videoLink ?? ""
                            
                            sendMessage(message: message, memberIds: memberIds)
                        }
                    }
                }
            }
        }
    }
    
    class func sendLocationMessage(message: LocalMessage, memberIds: [String]) {
        let currentLocation = LocationManager.shared.currentLocation
        message.message = "Location Message"
        message.type = kLOCATION
        message.latitude = currentLocation?.latitude ?? 0.0
        message.longitude = currentLocation?.longitude ?? 0.0
        
        OutgoingMessage.sendMessage(message: message, memberIds: memberIds)
    }
    
    
    class func sendAudioMessage(message: LocalMessage, audioFileName: String, audioDuration: Float, memberIds: [String]) {
        
        message.message = "Audio Message"
        message.type = kAUDIO
        
        let fileDirectory = "MediaMessages/Audio/" + "\(message.chatRoomId)/" + "_\(audioFileName)" + ".m4a"
        
        FileStorage.uploadAudio(audioFileName, directory: fileDirectory) { (audioUrl) in
            
            if audioUrl != nil {
                
                message.audioUrl = audioUrl!
                message.audioDuration = Double(audioDuration)
                
                OutgoingMessage.sendMessage(message: message, memberIds: memberIds)
            }
        }
    }
    
    // Thumbnail oluşturma fonksiyonu
    class func videoThumbnail(video: URL) -> UIImage {
        let asset = AVAsset(url: video)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        
        let time = CMTimeMake(value: 1, timescale: 60)
        var image: CGImage?
        do {
            image = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
        } catch {
            print("Error creating thumbnail: \(error.localizedDescription)")
        }
        
        return UIImage(cgImage: image!)
    }
}


