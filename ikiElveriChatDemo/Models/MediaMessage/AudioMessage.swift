//
//  AudioMessage.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 23.06.2024.
//

import Foundation
import MessageKit

class AudioMessage: NSObject, AudioItem {
    
    var url: URL
    var duration: Float
    var size: CGSize
    
    init(duration: Float) {
        
        self.url = URL(fileURLWithPath: "")
        self.size = CGSize(width: 160, height: 60)
        self.duration = duration
    }
    
    
}
