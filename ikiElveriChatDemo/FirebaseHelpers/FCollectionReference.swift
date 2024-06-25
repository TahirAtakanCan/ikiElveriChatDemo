//
//  FCollectionReference.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 4.06.2024.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Recent
    case Messages
    case Typing
    case Channel
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
