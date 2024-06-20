//
//  VideoMessage.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 20.06.2024.
//

import Foundation
import MessageKit
import UIKit


class VideoMessage: NSObject, MediaItem {
    
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    
    init(url: URL?) {
        self.url = url
        self.placeholderImage = UIImage(named: "photoPlaceholder")!
        self.size = CGSize(width: 240, height: 240)
    }
    
}
