//
//  GlobalFunctions.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 6.06.2024.
//

import Foundation
import UIKit
import AVFoundation

func fileNameFrom(fileUrl: String) -> String {
    
    return ((fileUrl.components(separatedBy: "_").last)!.components(separatedBy: "?").first!).components(separatedBy: ".").first!
    
}

func timeElapsed(_ date: Date) -> String {
    
    let seconds = Date().timeIntervalSince(date)
    
    var elapsed = ""
    
    if seconds < 60 {
        elapsed = "Just Now"
    }else if seconds < 60 * 60 {
        let minutes = Int(seconds/60)
        let minText = minutes > 1 ? "mins" : "min"
        
        elapsed = "\(minutes) \(minText)"
    }else if seconds < 24 * 60 * 60 {
        let hours = Int(seconds / (60 * 60))
        let hourText = hours > 1 ? "hours" : "hour"
        
        elapsed = "\(hours) \(hourText)"
    } else {
        elapsed = date.longDate()
    }
    
    return elapsed
}


func videoThumbnail(video: URL) -> UIImage {
    
    let asset = AVURLAsset(url: video, options: nil)
    
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    imageGenerator.appliesPreferredTrackTransform = true
    
    let time = CMTimeMakeWithSeconds(0.5, preferredTimescale: 1000)
    var actualTime = CMTime.zero
    
    var image: CGImage?
    
    do {
        image = try imageGenerator.copyCGImage(at: time, actualTime: &actualTime)
    }catch let error as NSError {
        print("error making thumbnail", error.localizedDescription)
    }
    
    if image != nil {
        return UIImage(cgImage: image!)
    }else {
        return UIImage(named: "photoPlaceHolder")!
    }
    
    
}
