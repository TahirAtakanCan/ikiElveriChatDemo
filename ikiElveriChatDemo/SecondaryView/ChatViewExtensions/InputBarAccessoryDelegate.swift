//
//  InputBarAccessoryDelegate.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 12.06.2024.
//

import Foundation
import InputBarAccessoryView

extension ChatViewController : InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        if text != "" {
            //print("typing...")
        }
        
        updateMicButtonStatus(show: text == "")
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        for component in inputBar.inputTextView.components {
            if let text = component as? String {
                //print("send message with text", text)
                messageSend(text: text, photo: nil, video: nil, audio: nil, location: nil)
                
            }
        }
        messageInputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()
    }
}
