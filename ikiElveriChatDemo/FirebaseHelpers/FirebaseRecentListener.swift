//
//  FirebaseRecentListener.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 8.06.2024.
//

import Foundation
import Firebase


class FirebaseRecentListener {
    
    static let shared = FirebaseRecentListener()
    
    private init(){}
    
    
    func addRecent(_ recent: RecentChat) {
        
        do{
            try FirebaseReference(.Recent).document(recent.id).setData(from: recent)
        }
        catch {
            print("Error saving recent chat", error.localizedDescription)
        }
        
    }
    
}
