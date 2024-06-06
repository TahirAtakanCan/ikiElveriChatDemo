//
//  GlobalFunctions.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 6.06.2024.
//

import Foundation


func fileNameFrom(fileUrl: String) -> String {
    
    return ((fileUrl.components(separatedBy: "_").last)!.components(separatedBy: "?").first!).components(separatedBy: ".").first!
    
}
