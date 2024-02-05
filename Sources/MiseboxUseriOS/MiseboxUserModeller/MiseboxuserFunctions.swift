//
//  MiseboxUserManagerFunctions.swift
//
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation

extension MiseboxUserManager {
    
    public func checkMiseboxUserExistsInFirestore(doc: DocCollection) async throws -> Bool {
        return try await firestoreManager.checkDocumentExists(collection: doc.collection, documentID: self.id)
    }
    
    public func primeMiseboxUser() {
        if self.imageUrl.isEmpty {
            self.miseboxUser.imageUrl = defaultImage
        }
    }
    public func primeMiseboxUserProfile() {
        self.miseboxUserProfile.id = self.id
        
    }
    
    public func setMiseboxUserAndProfile() async throws {
        primeMiseboxUser()
        
        try await firestoreManager.setDoc(entity: self.miseboxUser)
        
        try await firestoreManager.setDoc(entity: self.miseboxUserProfile)
    }
    
    
    public func documentListener<T: Listenable>(for entity: T, completion: @escaping (Result<T, Error>) -> Void) {
        self.listener = firestoreManager.addDocumentListener(for: entity) { result in
            completion(result)
        }
    }
    
    public func collectionListener(completion: @escaping (Result<[MiseboxUser], Error>) -> Void) {
        self.listener = firestoreManager.addCollectionListener(collection: self.miseboxUser.collection, completion: completion)
    }
}