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
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
