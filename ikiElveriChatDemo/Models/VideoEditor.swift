//
//  VideoEditor.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 20.06.2024.
//

import Foundation
import UIKit
import AVFoundation

class VideoEditor {
    func process(video: Video, completion: @escaping (_ processedVideo: URL?, _ videoUrl: URL?) -> Void) {
        // Videoyu işleme kodlarını buraya ekleyin
        let videoUrl = video.url
        // İşlem sonucunda video url'sini döndürüyoruz
        completion(videoUrl, videoUrl)
    }
}
